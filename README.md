# Christ Church Waterkloof Prayer App

Church prayer app running off a Trello board as the CMS.

## Setup

For setting up the Dart SDK and Flutter, see the [official documentation](https://flutter.io/)

## Build

```
flutter run
```

Use `flutter packages get` to update packages before running in the terminal (VS Code will do this for you automatically if you run through there)

## Test

run the model unit tests:

```
flutter run --target=test/model_test.dart
```

## Release

Update the release version number in pubspec.yaml, for example:

```
version: 0.2.2+5
```

### Google Play Store

```
flutter build appbundle
```

Upload the apk to the new build in Google Play Console.

### Apple TestFlight

Run flutter build:

```
flutter build ios
```

Use Xcode to make an archive of the build and upload it to Appstore Connect:

```
open ios/Runner.xcworkspace
```

1. In Project settings > General > Signing make sure CCW is selected
2. Select the destination from Product > Destination (usually Generic ios Device)
3. select Product > Archive
4. After the build succeeds, run Validation on the package


## Roadmap

- name search improvements
- birthday highlight (including milestone)