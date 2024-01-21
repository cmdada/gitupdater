#!/bin/bash
set -o pipefail
while [ $# -gt 0 ]; do
    case $1 in
        --force) _FORCE=true; shift 1; ;;
        --no-stash) _NO_STASH=true; shift 1; ;;
        *) shift ;;
    esac
done
for dir in ./*/; do
    echo "--- Working on \"$(realpath "${dir}")\""
    pushd "$(realpath "${dir}")" > /dev/null
        if [[ ! -d ".git" ]]; then
            echo "  x: \"$(realpath "${dir}")\" is not a git repository, continue next directory."
            popd > /dev/null
            continue
        fi
        if [[ "${_NO_STASH:=false}" != "true" ]]; then git stash --quiet; fi
        if [[ "${_FORCE:=false}" == "true" ]]; then git reset --hard; fi
        git pull
        if [[ "${_NO_STASH:=false}" != "true" ]]; then git stash apply --quiet; fi
    popd > /dev/null
done
