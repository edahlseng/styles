#!/usr/bin/env bash

# Check formatting in all C/C++/Protobuf/CUDA files:
#   h, H, hpp, hh, h++, hxx
#   c, C, cpp, cc, c++, cxx
#   ino, pde
#   proto
#   cu

returnCode=0

IFS=$'\n'
for file in $(find "." -name .git -prune -o -regextype posix-egrep -regex "^.*\.(h|H|hpp|hh|h\+\+|hxx|c|C|cpp|cc|c\+\+|cxx|ino|pde|proto|cu)$" -print); do
	clang-format --dry-run --Werror --style=file "${file}" || returnCode=$?
done

exit ${returnCode}
