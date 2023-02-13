//
//  ColorWellWithPopover.m
//  ColorPickerPopup
//
//  Created by Balázs Faludi on 06.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  - Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  - Neither the name of the copyright holders nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL BALÁZS FALUDI BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "BFPopoverColorWell.h"
#import "BFColorPickerPopover.h"
#import "NSColorPanel+BFColorPickerPopover.h"

@interface BFColorPickerPopover ()
@property (nonatomic) NSColorPanel *colorPanel;
@property (nonatomic, weak) NSColorWell *colorWell;
@end

@interface BFPopoverColorWell ()
@property (nonatomic, weak) BFColorPickerPopover *popover;
@property (nonatomic, readwrite) BOOL isActive;
@end

@interface NSColorWell (BFColorPickerPopover)

- (void)popoverDidClose:(NSNotification *)notification;
- (void)_performActivationClickWithShiftDown:(BOOL)shift;

@end

@implementation BFPopoverColorWell

static NSColorWell *hiddenWell = nil;

+ (void)deactivateAll {
    [[NSColorPanel sharedColorPanel] disablePanel];
    hiddenWell = [[NSColorWell alloc] init];
    hiddenWell.color = [NSColor colorWithCalibratedRed:1/255.0 green:2/255.0 blue:3/255.0 alpha:1];
    [hiddenWell activate:YES];
    [hiddenWell deactivate];
    [[NSColorPanel sharedColorPanel] enablePanel];
}

- (void)setup {
    if (@available(macOS 13.0, *)) {
        // this will show a small popover in macOS 13.0
        self.colorWellStyle = NSColorWellStyleExpanded;
        return;
    }

    self.preferredEdgeForPopover = NSMaxXEdge;
	self.useColorPanelIfAvailable = YES;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)activateWithPopover {
    if (@available(macOS 13.0, *)) {
        return;
    }

    if (self.isActive) {
        return;
    }
	
	// Setup and show the popover.
	self.popover = [BFColorPickerPopover sharedPopover];
    self.popover.delegate = self;
	self.popover.color = self.color;
	self.popover.colorWell = self;
	[self.popover showRelativeToRect:self.frame ofView:self.superview preferredEdge:self.preferredEdgeForPopover];
	
	// Disable the shared color panel, while the NSColorWell implementation is executed.
	// This is done by overriding the orderFront: method of NSColorPanel in a category.
	[[NSColorPanel sharedColorPanel] disablePanel];
	[super activate:YES];
	[[NSColorPanel sharedColorPanel] enablePanel];
	
	self.isActive = YES;
}

- (void)activate:(BOOL)exclusive {
    if (@available(macOS 13.0, *)) {
        [super activate:exclusive];
        return;
    }

    if (self.isActive) {
        return;
    }

	if (self.useColorPanelIfAvailable && [NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
		[super activate:exclusive];
		self.isActive = YES;
	} else {
		[self activateWithPopover];
	}
}

- (void)deactivate {
    if (@available(macOS 13.0, *)) {
        [super deactivate];
        return;
    }

    if (!self.isActive) {
        return;
    }

	[super deactivate];
	self.popover.colorWell = nil;
    self.popover.delegate = nil;
	self.popover = nil;
	self.isActive = NO;
}

// Force using a popover (even if useColorPanelIfAvailable = YES), when the user double clicks the well.
- (void)mouseDown:(NSEvent *)theEvent {
    if (@available(macOS 13.0, *)) {
        [super mouseDown:theEvent];
        return;
    }

    if([theEvent clickCount] == 2 && [NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
		[self deactivate];
		[self activateWithPopover];
	} else {
		[super mouseDown:theEvent];
	}
	
}

- (void)popoverDidClose:(NSNotification *)notification
{
    if ([super respondsToSelector:@selector(popoverDidClose:)]) {
        [super popoverDidClose:notification];
        return;
    }

    [self deactivate];
}

- (void)_performActivationClickWithShiftDown:(BOOL)shift {
    if (@available(macOS 13.0, *)) {
        if ([super respondsToSelector:@selector(_performActivationClickWithShiftDown:)]) {
            [super _performActivationClickWithShiftDown:shift];
        }

        return;
    }

    if (!self.isActive) {
        BFColorPickerPopover *popover = [BFColorPickerPopover sharedPopover];
        if (popover.isShown) {
            BOOL animatesBackup = popover.animates;
            popover.animates = NO;
            [popover close];
            popover.animates = animatesBackup;
        }
        [BFColorPickerPopover sharedPopover].target = nil;
        [BFColorPickerPopover sharedPopover].action = NULL;
        [self activate:!shift];
    } else {
        [self deactivate];
    }
}

@end
