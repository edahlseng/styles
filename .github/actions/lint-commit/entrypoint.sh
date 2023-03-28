#!/usr/bin/env sh

git config --global --add safe.directory /github/workspace

git fetch --unshallow --quiet

if [[ "${GITHUB_REF_NAME}" == "main" ]]; then
	commitlint --from=HEAD~1
elif [[ -n "${GITHUB_BASE_REF}" ]]; then
	commitlint --from="${GITHUB_BASE_REF}"
else
	commitlint --from=origin/main
fi
