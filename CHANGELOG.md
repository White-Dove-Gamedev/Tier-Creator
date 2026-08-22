# Changelog

All changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0]

### Added

A Card class.
The Card can have text and texture, as well as being moved and deleted.

A new default font: CourierPrime - Regular

### Changed

The DragComponent won't change state if the mouse is hovering over a button.
Will probably look into making this more customizable than hard-coding this feature.

## [0.3.0]

### Added

A DropComponent that becomes the DragComponents target. When the DragComponent gets
released, the parent node will center on the parent node of the DropComponent

### Fixed

DragComponent to only drag if the mouse hovers over the parents area.

## [0.2.0]

### Added

A DragComponent that makes its parent (Control) node draggable by the user.

## [0.1.0]

### Added

Initial commit
