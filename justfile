run:
  flutter run

build:

publish:
  flutter build apk
  cp ./build/app/outputs/apk/release/app-release.apk ./build/app/outputs/apk/release/app-release.apknt

start-emulator:
  emulator -avd psp &> /dev/null &
