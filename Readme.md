# BFColorPickerPopover

![Screenshot](http://i.imgur.com/Qm38i.png)

Summary
-------

BFColorPickerPopover is a subclass of NSPopover that includes the standard OS X color picker user interface. This helps reducing the inspector window and panel clutter on the screen, as the popover sticks to the content it belongs to.

Requirements
------------

BFColorPickerPopover was writhed using [ARC](http://developer.apple.com/library/mac/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226) and Modern Objective-C.
ARC (with weak references) is supported since OS X 10.7.
For Modern Objective-C you'll need Xcode 4.4 or later and LLVM.


Instructions
------------

Drag the folder BFColorPickerPopover into your your project in Xcode.</br>
Choose "Create groups for any added folders and make sure your target is checked.</br>
BFColorPickerPopover is a singleton class. Use [BFColorPickerPopover sharedPopover] to access it. The reason for this is, that it uses NSColorPanel to create it's GUI and there is only one shared NSColorPanel available per app.</br>
You can use the usual showRelativeToRect:ofView:preferredEdge: method of NSPopover to show the shared BFColorPickerPopover instance. But there is also a subclass of NSColorWell included (BFPopoverColorWell) that already handles presenting the popover when needed.</br>
Check out the example application for both approaches.


Credits
-------
BFColorPickerPopover was created by [Balázs Faludi](https://github.com/DrummerB).</br>
You can e-mail me at <balazsfaludi@gmail.com>.