#!/bin/zsh

touch CMakeLists.txt

if [ ! -e .git ]
then
  git init
  if [ $? -ne 0 ]
  then
    echo "could not initialise git."
    return 3
  fi
fi


#### figure out project

packageentries=($(svn pg packages http://svn.cern.ch/guest/lhcb | grep $1" "))
#packageentries=($(cat allpacks | grep $1))

if [ ! ${#packageentries} -eq 2 ]
then
  echo "couldn't determine project accurately"
  echo "choices are:"
  echo $packageentries
  return 1
else
  echo "projectline is " $packageentries
fi
project=($(echo $packageentries[2]))
package=($(echo $packageentries[1]))

echo "Project " $project
echo "Package " $package

#### figure out if project needs to be added

git remote | grep $project

if [ $? -ne 0 ]
then
  echo "Adding project $project"
  git lb-use $project
  if [ $? -ne 0 ]
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
