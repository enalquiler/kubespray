#!/bin/sh -eo pipefail
#Generate MD formatted tags from roles and cluster yaml files
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
printf "|%25s |%9s\n" "Tag name" "Used for"
echo "|--------------------------|---------"
tags=$(grep -r tags: . | perl -ne '/tags:\s\[?(([\w\-_]+,?\s?)+)/ && printf "%s ", "$1"'|\
  perl -ne 'print join "\n", split /\s|,/' | sort -u)
for tag in $tags; do
  match=$(cat ${DIR}/../docs/ansible.md | perl -ne "/^\|\s+${tag}\s\|\s+((\S+\s?)+)/ && printf \$1")
  printf "|%25s |%s\n" "${tag}" " ${match}"
done
