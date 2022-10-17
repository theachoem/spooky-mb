# build
fvm flutter build appbundle --release

# deploy
fastlane supply --aab ../../build/app/outputs/bundle/release/app-release.aab --track internal
