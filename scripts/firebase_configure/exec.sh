#!/bin/bash -e

# include
. "$(dirname $(dirname "$0"))/helpers/helpers.sh"

# ENV or exported variables
function setup_exports() {
  [ -n $FIREBASE_CLI_TOKEN ] && export TOKEN="$FIREBASE_CLI_TOKEN" && echo "SET FIREBASE_CLI_TOKEN"
  [ -n $FIREBASE_PLATFORMS ] && export PLATFORMS="$FIREBASE_PLATFORMS" && echo "SET FIREBASE_PLATFORMS"
}

function save_configs_file() {
  FLAVOR=$1

  TEMPLATE_FILE=configs/flavor.json
  CONFIGS_FILE=configs/$FLAVOR.json

  if [ ! -f "$CONFIGS_FILE" ]; then
    cat $TEMPLATE_FILE >$CONFIGS_FILE
    echo "[CREATED] $TEMPLATE_FILE -> $CONFIGS_FILE"
  fi
}

# eg. main_prod.dart
function save_dart_main_file() {
  TEMPLATE_DATA=$(cat "scripts/firebase_configure/main_flavor.dart.template")
  FLAVOR=$1
  DESTINATION="lib/main_$FLAVOR.dart"

  echo "${TEMPLATE_DATA/"#{FLAVOR}"/$FLAVOR}" >$DESTINATION
  echo "[CREATED] main_flavor.dart.template -> $DESTINATION"

  log_args "TO RUN PROJECT: fvm flutter run --flavor $FLAVOR --target $DESTINATION --dart-define-from-file=configs/$FLAVOR.json"
}

function configure() {
  FLAVOR=$1
  PRODUCT=$2
  APPLICATION_ID=$3
  ACCOUNT=$4
  PLATFORMS=${PLATFORMS:-'android,ios,macos,web'}

  # TODO: MacOS is not support flavor yet until Flutter 3.8
  run_command "flutterfire configure
    --project=$PRODUCT
    --ios-bundle-id=$APPLICATION_ID
    --android-package-name=$APPLICATION_ID
    --macos-bundle-id="com.juniorise.spooky"
    --web-app-id=$APPLICATION_ID
    --platforms=$PLATFORMS
    --ios-out="ios/Firebase/$FLAVOR/GoogleService-Info.plist"
    --macos-out="macos/Runner/GoogleService-Info.plist"
    --out="lib/firebase_options/$FLAVOR.dart"
    --account=$ACCOUNT
    --token=$TOKEN
    --overwrite-firebase-options
    --verbose
    --yes"

  echo

  # TODO: move to use android-out="/path/to/json" instead of mv once it fixed:
  #  > https://github.com/invertase/flutterfire_cli/issues/155
  [[ $PLATFORMS == *android* ]] && move_file android/app/google-services.json "android/app/src/$FLAVOR"

  save_configs_file $FLAVOR
  save_dart_main_file $FLAVOR
}

function help() {
  log_args "Firebase Flavor Configure"

  echo "Common commands:"
  echo "  ./scripts/firebase_configure/exec.sh --dev"
  echo "  ./scripts/firebase_configure/exec.sh --prod"
  echo "  ./scripts/firebase_configure/exec.sh --staging"
  echo "  ./scripts/firebase_configure/exec.sh --dev example@vtenh.com"
  echo
  echo "Usage: ./scripts/firebase_configure/exec.sh [options] [account]"
  echo
  echo "options:"
  echo "  -h, --help      Print this usage information"
  echo "  -s, --staging   Setup project with staging environment"
  echo "  -p, --prod      Setup project with production enviroment"
  echo "  -d, --dev       Setup project with development enviroment"
  echo
  echo "account:"
  echo "  [Optional] Specify account for Firebase. Make sure firebase login:add [your_email]"
  echo
}

function main() {
  exit_if_file_not_exist "pubspec.yaml" "Make sure to execute scripts from project directory."
  setup_exports

  case $1 in

  -h | --help)
    help
    exit 0
    ;;

  -d | --dev)
    configure 'dev' 'juniorise-spooky-community' 'com.juniorise.spooky.dev' $2
    exit 0
    ;;

  -s | --staging)
    configure 'staging' 'juniorise-spooky-community' 'com.juniorise.spooky.staging' $2
    exit 0
    ;;

  -p | --prod)
    configure 'prod' 'juniorise-spooky' 'com.juniorise.spooky' $2
    exit 0
    ;;

  *)
    help
    exit 0
    ;;

  esac
  shift
}

main $@
