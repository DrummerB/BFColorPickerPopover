//
//  ColorPickerPopover.m
//  ColorPickerPopup
//
//  Created by Balázs Faludi on 05.08.12.
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

#import "BFColorPickerPopover.h"
#import "BFColorPickerViewController.h"

@interface NSPopover (ColorPickerPopover)
- (BOOL)_delegatePopoverShouldClose:(id)sender;
@end


@implementation BFColorPickerPopover

+ (BFColorPickerPopover *)sharedPopover
{
    static BFColorPickerPopover *sharedPopover = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPopover = [[BFColorPickerPopover alloc] init];
    });
    return sharedPopover;
}

- (id)init
{
    self = [super init];
    if (self) {
		self.behavior = NSPopoverBehaviorSemitransient;
	}
    return self;
}

- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {
	
	// Close the popover without an animation if it's already on screen.
	if (self.isShown) {
		BOOL animatesBackup = self.animates;
		self.animates = NO;
		[self close];
		self.animates = animatesBackup;
	}
	
	self.contentViewController = [[BFColorPickerViewController alloc] init];
	[super showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
}

- (NSColorPanel *)colorPanel {
	return ((BFColorPickerViewController *)self.contentViewController).colorPanel;
}

// On pressing Esc, close the popover.
- (void)cancelOperation:(id)sender {
	[self close];
}

// Deactive any color wells on close.
- (void)close {
	[super close];
	[self.colorWell deactivate];
	self.colorWell = nil;
}

- (BOOL)_delegatePopoverShouldClose:(id)sender {
	if ([super _delegatePopoverShouldClose:sender]) {
		[self.colorWell deactivate];
		return YES;
	}
	return NO;
}

@end
