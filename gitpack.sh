#!/bin/zsh

if [ ! -e .git ]
then
  git init
  if [ $? ]
  then
    echo "could not initialise git."
    return 3
  fi
fi


#### figure out project

packageentries=($(svn pg packages http://svn.cern.ch/guest/lhcb | grep $1 | sed "s/.* //"))
#packageentries=($(cat allpacks | grep $1))

if [ ! ${#packageentries} -eq 1 ]
then
  echo "couldn't determine project accurately"
  echo "choices are:"
  echo $packageentries
  return 1
else
  echo "Project is " $packageentries[1]
fi
project=($(echo $packageentries[1] | sed "s/.* //"))
package=($(echo $packageentries[1] | sed "s/ .*//"))

#### figure out if project needs to be added

git remote | grep $project

if [ $? ]
then
  echo "Adding project $project"
  git lb-use $project
  if [ $? ]
  then
    echo "could not add project $project"
    return 2
  fi
else
  echo "Project already in use"
fi

#### determine version (master=default)

version=master
if [ $2 ]
then
  version=$2
fi


echo "git lb-checkout $project/$version $package"
git lb-checkout $project/$version $package
return $?
