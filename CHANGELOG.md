# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2021-01-20
### Added
- Add improved collection rendering
### Removed
- Collection class is no longer needed

## [1.0.11] - 2020-04-24
### Added
- Added `to_h` and  `to_hash` aliases for dumping locals

## [1.0.10] - 2020-04-06
### Added
- Added `render?` method for checking complex logic

## [1.0.9] - 2020-01-08
### Added
- Added block support to yield other components
### Changed
- Changed how the helper generated the component

## [1.0.8] - 2019-12-26
### Added
- Added `c` local variable to access the component

## [1.0.7] - 2019-12-24
### Changed
- Fixed path to nested partials

## [1.0.6] - 2019-12-21
### Removed
- Removed generator empty directory check

## [1.0.5] - 2019-12-21
### Added
- Added support for `to_a` and `to_hash` for size check

## [1.0.4] - 2019-12-20
### Changed
- Fixed generator template name

## [1.0.3] - 2019-12-20
### Changed
- Reworked component generator

## [1.0.2] - 2019-12-19
### Changed
- Rewrite the internals of component building and rendering
- Move location of generators to be rails namespaced

## [1.0.1] - 2019-12-13
### Added
- Included action view helpers and context
### Changed
- Renamed view variable to context to allow more action view includes

## [1.0.0] - 2019-12-12
### Added
- Initial project version
