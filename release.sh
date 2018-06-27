#!/bin/bash

# ensure we're up to date
git pull

# bump version
increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  echo -e "${new// /.}"
}

OLD_VERSION=`cat VERSION`
VERSION=`echo $OLD_VERSION | awk -F "-" {'print $2'}`
NEW_VERSION="`date  "+%Y%m%d%H%M%S"`-`increment_version $VERSION`"
echo $NEW_VERSION > VERSION

# tag it
git log --reverse --pretty=format:"%h%+ %B" --since="$(git show -s --format=%ad `git rev-list --tags --max-count=1`)"  | grep -v VERSION | sed '/^$/d' > CHANGELOG.md
git add -A
git commit -m "VERSION $NEW_VERSION"
git tag -a "$NEW_VERSION" -F CHANGELOG.md
git push ; git push --tags
