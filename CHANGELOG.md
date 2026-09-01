# Changelog

All changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.23.0]

### Added

Importing and Exporting of created Tierlists. With it comes SaveData Custom Resources.

Additional Export/Import Buttons to the CardCreator scene.

## [0.22.0]

### Added

Screenshot functionality. Screenshots the entire tierlist to save and share.

## [0.21.0]

### Added

PreviewComponent to preview where nodes will be placed. Requires DragComponent sibling to function.

Abstract ComponentBase that every Component node will inherit from.

### Changed

Renamed Autoloads folder to Globals.

## [0.20.0]

### Added

CardLayer added back.

TierCreator. The Main scene from this point on.

### Changed

Moved SettingsWindow logic from TierList to TierCreator due to control layout.

DragComponent input becomes unhandled_input.

SettingsWindow now hides by default in its own code.

TiersVBoxContainer in the TierList scene is now a child of a ScrollContainer node to support scrolling.

## [0.19.0]

### Added

CardBench which will automatically host newly created cards.

### Removed

CardLayer in favour of CardBench.

## [0.18.0]

### Added

DEADZONE state for the DragComponent. The draggable stays "Idle" until the mouse has moved a certain distance from the origin point.

### Removed

Print statements.

## [0.17.1]

### Changed

TierName with new default Color and Text.

## [0.17.0]

### Added

TierList that can be renamed, recolored, added, removed, shuffled and cards assigned.
Currently known issue: The tier name does not scale well when the label exceeds a minimum size.

### Changed

Some control nodes to ignore mouse input.

## [0.16.0]

### Added

SettingsWindow for setting various options for a CategoryTier.

CategorySettings to edit or move a category. More specifically the tools made available to do the aforementioned things.

### Changed

TierName to remove resizing. Planning to relegate the resizing to TierList.

### Removed

PanelContainer from CardGrid.

## [0.15.0]

### Added

CategorySettings for editing TierName label and background aswell as moving them up and down.

### Changed

Utils.gd is no longer an autoload and instead a class_name with constants

## [0.14.0]

### Changed

TierLabel to TierName

### Fixed

TierName background improperly resizing

## [0.13.0]

### Added

A TierLabel that can expand vertically as needed.

## [0.12.0]

### Added

A Utils Autoload for getting standard Control node sizes.

## [0.11.0]

### Added

Drop Targets, meaning Draggables will only drop with matching Droppables.

## [0.10.0]

### Added

A Cardgrid node for holding an array of DropNodes which dynamically change in size depending on the amount of Cards.

Added a check to discard any already occupied DropComponents.

### Changed

Drop component now checks for any descendants when they exit a tree.

Changed static typing logic for a loop.

## [0.9.0]

### Added

A simple DropNode

## [0.8.1]

### Fixed

The delete button not deleting because of the DragComponent.

## [0.8.0]

### Added

A state on whether DropComponent is occupied by another DragComponent. Also emits a signal with the new state.

### Fixed

A draggable nodes state wouldn't reset to IDLE if a drop got rejected.

A missing check for releasing the mouse button.

All draggable calculations now use global_position.

## [0.7.0]

### Added

A pickup State for DragComponent to simplify code.

Draggable nodes reparent to the droppable nodes on success.

### Fixed

A calculation error when reparenting a draggable node by using global_position.
Size of the card got reset on reparent so it's been set to a minimum and maximum of 96.0 by 96.0.

## [0.6.0]

### Added

Added a CardLayer node for all instantiated cards to reparent to by default.

### Changed

CardCreator now tries to reparent created cards to the CardLayer if it exists, otherwise nothing happens.

## [0.5.0]

### Added

Added a card creator that lets the user set text and texture for any card.

### Changed

DragComponent now moves the parent node to the front of the screen.

Cards now have a PanelContainer as a background if no texture is selected.

### Fixed

DragComponent now consumes the input. Prevents stacked draggables that become inseperable from ocurring.

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

A DropComponent that becomes the DragComponents target. When the DragComponent gets released, the parent node will center on the parent node of the DropComponent

### Fixed

DragComponent to only drag if the mouse hovers over the parents area.

## [0.2.0]

### Added

A DragComponent that makes its parent (Control) node draggable by the user.

## [0.1.0]

### Added

Initial commit
