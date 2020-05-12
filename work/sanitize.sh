#!/bin/bash
# sanitize.sh
##########################################################################################
# Do a series of sanitization fixes prior to commit of Mule projects
#
# Usage
#   sanitize.sh
#

if [[ "$1" == "--help" ]]; then
  cat <<'EOF'
Usage:
  cd <project-root>
  sanitize.sh

This script does a series of sanitization fixes on the Mule project text fileset. Do note
that this has not been tested on Windows or Cygwin environments. It works currently for
Mac OS-X.

Operates on:
  cat.txt
  dog.txt
  pom.xml
  README*.md
  src/{main,test}/**/README*.md
  src/{main.test}/**/*.xml
  src/{main,test}/**/*.wsdl
  src/{main,test}/**/*.properties
  src/{main,test}/**/*.yaml
  src/{main,test}/**/*.yml

EOF
    exit
fi
##########################################################################################

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
#echo ${machine}

##########################################################################################
h
if [[ "$machine" ==  "Mac" ]]; then
  echo "This script is currently being used with Mac OS-X";

  # ignore any command customizations via alias
  unalias find 2> /dev/null
  unalias grep 2> /dev/null
  unalias sed  2> /dev/null


  find_project_files() {
      echo cat.txt
      echo dog.txt
      echo pom.xml
      echo README*.md
      echo .gitignore
      local dirs=(src/main) 
      local dirs2=(src/test) 
      #echo ${dirs[@]}

      for dir in "${dirs[@]}"; do
          if [[ -d ${dir} ]]; then
              find ${dir} -name 'README*.md'
              find ${dir} -name '*.xml'
              find ${dir} -name '*.wsdl'
              find ${dir} -name '*.properties'
              find ${dir} -name '*.yml'
              find ${dir} -name '*.yaml'
              find ${dir} -name '*.dwl'
              find ${dir} -name '*.txt'
              find ${dir} -name '*.java'
              find ${dir} -name '*.json'
          fi
      done
      for dir in "${dirs2[@]}"; do
          if [[ -d ${dir} ]]; then
              find ${dir} -name 'README*.md'
              find ${dir} -name '*.xml'
              find ${dir} -name '*.wsdl'
              find ${dir} -name '*.properties'
              find ${dir} -name '*.yml'
              find ${dir} -name '*.yaml'
              find ${dir} -name '*.dwl'
              find ${dir} -name '*.txt'
              find ${dir} -name '*.java'
              find ${dir} -name '*.json'
          fi
      done
  }

  trailing_whitespace() {
      for file in "$@"; do
         sed -i '' 's/ *$//' ${file};
      done
  }

  remove_docids() {
      for file in "$@"; do
         sed -i '' -e 's/ doc:id="[^"]*"//' ${file};
      done
  }

  linefeed_file_ends() {
      for file in "$@"; do
         sed -i '' -e '$a\' ${file}; 
      done
  }

  list_files() {
      for file in "$@"; do
         echo ${file}; 
      done
  } 

  # driving logic
  (
    if [[ $# > 0 ]]; then
        FILESET=("$@")                     # as specified on command line
    else
        FILESET=("$(find_project_files)")  # all standard project files
    fi

    for filepath in ${FILESET[@]}; do
         #list_files ${filepath}
         echo ${filepath}
         trailing_whitespace ${filepath}
         remove_docids ${filepath}
         #linefeed_file_ends ${filepath}
    done
  )

elif [[ "$machine" ==  "Linux" ]]; then
  echo "This script has not been tested with Bash on the Linux OS";

elif [[ "$machine" ==  "Cygwin" ]]; then
  echo "This script has not been tested with Bash for Cygwin";

elif [[ "$machine" ==  "MinGw" ]]; then
  echo "This script has not been tested with Bash for MinGw";

else
  echo "Your system could not be determined using uname -s";
fi

