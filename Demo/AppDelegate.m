//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "BFColorPickerPopover.h"
#import "NSColor+BFColorPickerPopover.h"
#import "ColoredView.h"
#import "NSColorWell+BFColorPickerPopover.h"
#import "BFPopoverColorWell.h"
#import "NSColorPanel+BFColorPickerPopover.h"

@implementation AppDelegate

@synthesize colorWell1;
@synthesize colorWell2;
@synthesize colorWell3;
@synthesize colorWell4;
@synthesize colorWell5;
@synthesize colorWell6;
@synthesize colorWell7;
@synthesize colorWell8;
@synthesize button;
@synthesize backgroundView;
@synthesize animateCheckmark;
@synthesize usePanelCheckmark;

- (void)awakeFromNib {
	
//	[[BFColorPickerPopover sharedPopover] setAnimates:NO];
	
	for (NSColorWell *well in @[colorWell1, colorWell2, colorWell3, colorWell4, colorWell5, colorWell6, colorWell7, colorWell8])
		well.color = [NSColor randomColor];
}
- (IBAction)buttonClicked:(id)sender {
	
	[[BFColorPickerPopover sharedPopover] showRelativeToRect:button.frame ofView:button.superview preferredEdge:NSMinYEdge];
	[[BFColorPickerPopover sharedPopover] setTarget:self];
	[[BFColorPickerPopover sharedPopover] setAction:@selector(colorChanged:)];
	[[BFColorPickerPopover sharedPopover] setColor:backgroundView.backgroundColor];
}

- (void)colorChanged:(id)sender {
	backgroundView.backgroundColor = [BFColorPickerPopover sharedPopover].color;
}

- (IBAction)animateCheckClicked:(id)sender {
	[[BFColorPickerPopover sharedPopover] setAnimates:(animateCheckmark.state == NSOnState)];
}

- (IBAction)usePanelCheckmarkClicked:(id)sender {
	for (BFPopoverColorWell *well in @[colorWell1, colorWell2, colorWell3, colorWell4]) {
		well.useColorPanelIfAvailable = (usePanelCheckmark.state == NSOnState);
	}
}


@end
