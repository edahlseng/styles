#!/usr/bin/env bash

set -o errexit

executedFileUnresolved="${BASH_SOURCE[0]}"
scriptsDirectoryUnresolved="$(cd "$(dirname "${executedFileUnresolved}")" && pwd)"
baseDirectoryUnresolved="$(cd "$(dirname "${scriptsDirectoryUnresolved}")" && pwd)"
workingDirectory="$(pwd -P)"

function continuePrompt() {
	read -p "${2}" response

	if [[ -z "${response}" ]]; then
		response="${1}"
	fi

	# Convert to lowercase:
	response="$(echo "${response}" | tr '[:upper:]' '[:lower:]')"

	case "${response}" in
		y|yes) return 0;;
		*) return 1;;
	esac
}

# If "grealpath" exists, we're probably on macOS with grealpath installed, so let's default to that if it works as expected
grealpathPath="$(which grealpath)"
realpathPath="$(which realpath)"
if [[ -n "${grealpathPath}" && "$("${grealpathPath}" --relative-to . .)" == "." ]]; then
	realpath="${grealpathPath}"
elif [[ -n "${realpathPath}" ]]; then
	realpath="${realpathPath}"
else
	echo $'Neither realpath nor grealpath exist on your system, but a realpath utility is required\nfor this script. Install a realpath utility for your system and try again.'
	exit 1
fi

if [[ "$("${realpath}" --relative-to . .)" != "." ]]; then
	echo "${realpath}"$' did not produce the expected output, so this script does not know\nhow to work with your system\'s realpath utility. You can (re)install the coreutils\nrealpath utility and try again.'
	exit 1
fi

if [[ ! -d "${workingDirectory}/.git" ]]; then
	if ! continuePrompt "no" $'The current directory that you are in is not the root of a Git repository. Usually\nthis script should be run from the root of a Git repository. Are you sure you want\nto continue? (yes/No) '; then
		exit 1
	fi
	echo ""
fi

executedFileResolved="$("${realpath}" "${executedFileUnresolved}")"
workingDirectoryWithTrailingSlash="${workingDirectory}/"
if ! [[ "${workingDirectoryWithTrailingSlash}" == "${executedFileResolved:0:${#workingDirectoryWithTrailingSlash}}" ]]; then
	if ! continuePrompt "no" $'This setup script is not in a subpath of your current working directory. Usually\nthis script should be run from a parent directory (with this script in a submodule).\nAre you sure you want to continue? (yes/No) '; then
		exit 1
	fi
	echo ""
fi

function linkConfigurationFile() {
	echo ""

	if [[ -e "${workingDirectory}/${1}" ]]; then
		echo "${1} already exists in your working directory:"
		echo -n "    "
		ls -al "${1}"
		echo ""
		if ! continuePrompt "no" "Would you like to overwrite it? (yes/No) "; then
			return
		fi

		echo ""
		rm "${1}"
		echo "Removed ${1}"
	fi

	relativePath="$("${realpath}" --relative-to="${workingDirectory}" "${baseDirectoryUnresolved}/${1}")"

	ln -s "${relativePath}" "${1}"

	echo "Linked ${relativePath} to ${1}"
	echo ""
}

echo ""
echo "Available linting tools:"
echo ""
lintingTools=("clang-format (C/C++/...)" "commitlint (Git commits)" "(quit)")
PS3=$'\nWhich linting tool would you like to setup (select only one at a time)? '
select tool in "${lintingTools[@]}"; do
	case "${tool}" in
		"clang-format (C/C++/...)")
			linkConfigurationFile ".clang-format"
			;;
		"commitlint (Git commits)")
			linkConfigurationFile ".commitlintrc.json"
			;;
		"(quit)")
			break
			;;
		*)
			echo "Unsupported input. Please select again."
			;;
	esac
	REPLY=
done
