# BFColorPickerPopover

[![Pod Version](http://img.shields.io/cocoapods/v/BFColorPickerPopover.svg?style=flat)](https://github.com/DrummerB/BFColorPickerPopover)
[![Pod Platform](http://img.shields.io/cocoapods/p/BFColorPickerPopover.svg?style=flat)](https://github.com/DrummerB/BFColorPickerPopover)
[![Pod License](http://img.shields.io/cocoapods/l/BFColorPickerPopover.svg?style=flat)](http://opensource.org/licenses/BSD-3-Clause)
[![Dependency Status](https://www.versioneye.com/objective-c/BFColorPickerPopover/badge.svg?style=flat)](https://www.versioneye.com/objective-c/BFColorPickerPopover)

![Screenshot](http://i.imgur.com/Qm38i.png)

Summary
-------

BFColorPickerPopover is a subclass of NSPopover that includes the standard OS X color picker user interface. This helps reducing the inspector window and panel clutter on the screen, as the popover sticks to the content it belongs to. However it's still possible to transform it into an inspector style floating panel by simply dragging it off from the color well.

Requirements
------------

BFColorPickerPopover was written using [ARC](http://developer.apple.com/library/mac/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226) and Modern Objective-C.
ARC (with weak references) is supported since OS X 10.7.
For Modern Objective-C you'll need Xcode 4.4 or later and LLVM.
I also had to use a few undocumented methods, so I can't guarantee that Apple won't reject an app with this code. They aren't that strict with OS X apps though.

Instructions
------------

Create a [Podfile](http://cocoapods.org), if you don't have one already. Add the following line.

    pod 'BFColorPickerPopover'
    
Run the following command.

    pod install
    
Alternatively, you can just drag the BFColorPickerPopover folder into your your project in Xcode. Choose "Create groups for any added folders and make sure your target is checked.

BFColorPickerPopover is a singleton class. Use `[BFColorPickerPopover sharedPopover]` to access it. The reason for this is, that it uses NSColorPanel to create its GUI and there is only one shared NSColorPanel available per app.

You can use the usual `showRelativeToRect:ofView:preferredEdge:` method of NSPopover to show the shared BFColorPickerPopover instance. But there is also a subclass of NSColorWell included (BFPopoverColorWell) that already handles presenting the popover when needed.

Check out the example application for both approaches.

License
-------

[New BSD License](http://en.wikipedia.org/wiki/BSD_licenses). For the full license text, see [here](https://raw.github.com/DrummerB/BFColorPickerPopover/master/License).

Credits
-------
BFColorPickerPopover was created by [Balázs Faludi](https://github.com/DrummerB).</br>