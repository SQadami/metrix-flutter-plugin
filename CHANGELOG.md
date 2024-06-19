# Metrix SDK Flutter plugin Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.2] - 2023-12-01

### Changed
- Use Android SDK v2.1.2

## [2.1.0] - 2023-12-01

### Changed
- Use Android SDK v2.1.0

## [1.6.0] - 2022-08-06

### Changed
- Use Android SDK v1.6.0
- initialize event channels in android

## [1.5.0] - 2022-08-06

### Added
- Added `acquisitionSubID` to attribution info

### Changed
- Use Android SDK v1.5.1
- Use iOS SDK v2.1.0


## [1.4.2] - 2022-06-19

### Changed
- Use Android SDK v1.4.0


## [1.4.1] - 2022-06-18

### Changed
- Use iOS SDK v2.0.3

### Added
- Added missing `trackerToken`, `store` and `sdkSignature` methods for iOS.


## [1.4.0] - 2022-06-14

### Added
- Added iOS support using iOS native SDK v2.0.2

### Changed
- Use EventChannel instead of MethodChannel for attribution info


## [1.3.0] - 2022-03-05

### Changed
- Use Android SDK v1.3.0
- Migrate to kotlin completely and upgrade to v1.5.31
- Upgrade `compileSdkVersion` to 32
- Upgrade gradle build tools version to v4.1.3

### Fixed
- Use EventChannel for userId instead of MethodChannel


## [1.2.1] - 2022-02-19

### Changed
- Use Android SDK v1.2.1


## [1.2.0] - 2022-02-19

### Changed
- Use Android SDK v1.2.0


## [1.1.8] - 2021-11-09

### Changed
- Use Android SDK v1.1.5


## [1.1.7] - 2021-10-19

### Changed
- Use Android SDK v1.1.4


## [1.1.6] - 2021-09-18

### Added
- Migrate to null-safety
- Change platform check to support web apps


## [1.1.5] - 2021-08-29

### Fixed
- Remove iOS platform


## [1.1.4] - 2021-06-02

### Changed
- Use Android SDK v1.1.3


## [1.1.3] - 2021-05-26

### Changed
- Use Android SDK v1.1.2


## [1.1.2] - 2021-05-17

### Changed
- Use Android SDK v1.1.1


## [1.1.1] - 2021-05-09

### Changed
- Use `mavenCentral` repository for Android native SDK retrieval.


## [1.1.0] - 2021-04-10

### Changed
- Use Android SDK v1.1.0
- [BREAKING] App config API methods are now used only for iOS builds. The config is now retrieved from application manifest file for Android builds.


## [1.0.5] - 2021-03-07

### Changed
- Use Android SDK v1.0.5


## [1.0.4] - 2021-03-06

### Changed
- Use Android SDK v1.0.4


## [1.0.0] - 2021-01-17

### Added
- Use Android SDK v1.0.0