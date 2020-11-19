#! /bin/bash

git remote add upstream https://github.com/facebookresearch/pyrobot.git
echo "-----------------------------------------------------------------------"
echo "------------pull upstream facbookresearch pyrobot repo-----------------"
echo "-----------------------------------------------------------------------"

# echo "password: $2"
BRANCH=master
if [ ! -z "$1" ]; then
    echo "pull upstream branch: $1"
    BRANCH=$1
else
    echo "pull upstream branch: $BRANCH"
fi

echo "-----------------------------------------------------------------------"
echo "----------------pull pyrobot (facebook research)-----------------------"
echo "-----------------------------------------------------------------------"
git pull upstream $BRANCH

CONFLICTS=$(git ls-files -u | wc -l)
if [ "$CONFLICTS" -gt 0 ] ; then
   echo "There is conflict in pyrobot. Aborting"
   return 1
fi

return 0
