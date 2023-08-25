# #!/bin/bash

function move_file() {
  SOURCE=$1
  DESTINATION=$2

  mkdir -p $DESTINATION
  mv $SOURCE $DESTINATION

  echo "[MOVED] $SOURCE -> $DESTINATION"
}

function exit_if_file_not_exist() {
  if ! [[ -f $1 ]]; then
    echo "🚨 $2"
    exit 1
  fi
}

function run_command() {
  echo -e "\n[EXECUTING] $1\n"
  eval $1
}

function log_args() {
  msg="=    $*    ="
  edge=$(echo "$msg" | sed 's/./=/g')

  echo -e "\n$edge"
  echo -e "$msg"
  echo -e "$edge\n"
}
