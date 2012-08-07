//
//  AppDelegate.m
//  ColorPickerPopup
//
//  Created by Balázs Faludi on 05.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//
//	This software is supplied to you by Balázs Faludi in consideration
//	of your agreement to the following terms, and your use, installation,
//	modification or redistribution of this software constitutes
//	acceptance of these terms. If you do not agree with these terms,
//  please do not use, install, modify or redistribute this software.
//
//	In consideration of your agreement to abide by the following terms,
//	and subject to these terms, Balázs Faludi grants you a personal,
//	non-exclusive license, to use, reproduce, modify and redistribute
//	the software, with or without modifications, in source and/or binary
//	forms; provided that if you redistribute the software in its entirety
//	and without modifications, you must retain this notice and the
//	following text and disclaimers in all such redistributions of the
//	software, and that in all cases attribution of Balázs Faludi as the
//	original author of the source code shall be included in all such
//	resulting software products or distributions. Neither the name,
//	trademarks, service marks or logos of Balázs Faludi may be used to
//	endorse or promote products derived from the software without specific
//	prior written permission from Balázs Faludi. Except as expressly stated
//	in this notice, no other rights or licenses, express or implied, are
//	granted by Balázs Faludi herein, including but not limited to any patent
//	rights that may be infringed by your derivative works or by other works
//	in which the software may be incorporated.
//
//	THIS SOFTWARE IS PROVIDED BY BALÁZS FALUDI ON AN "AS IS" BASIS. BALÁZS
//	FALUDI MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT
//	LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY
//	AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE
//	AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//	IN NO EVENT SHALL BALÁZS FALUDI BE LIABLE FOR ANY SPECIAL, INDIRECT,
//	INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//	PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE
//	USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE,
//	HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING
//	NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF BALÁZS FALUDI HAS
//	BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "AppDelegate.h"
#import "BFColorPickerPopover.h"
#import "NSColor+BFColorPickerPopover.h"
#import "ColoredView.h"
#import "NSColorWell+BFColorPickerPopover.h"

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

- (void)awakeFromNib {
	
//	[[BFColorPickerPopover sharedPopover] setAnimates:NO];
	[[BFColorPickerPopover sharedPopover] setDelegate:self];
	
	for (NSColorWell *well in @[colorWell1, colorWell2, colorWell3, colorWell4, colorWell5, colorWell6, colorWell7, colorWell8])
		well.color = [NSColor randomColor];
}

- (IBAction)buttonClicked:(id)sender {
	[[BFColorPickerPopover sharedPopover] showRelativeToRect:button.frame ofView:button.superview preferredEdge:NSMinYEdge];
//	[[BFColorPickerPopover sharedPopover] setDelegate:self];
	[[[BFColorPickerPopover sharedPopover] colorPanel] setColor:backgroundView.backgroundColor];
	[[[BFColorPickerPopover sharedPopover] colorPanel] addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == [[BFColorPickerPopover sharedPopover] colorPanel] && [keyPath isEqualToString:@"color"]) {
		backgroundView.backgroundColor = [[[BFColorPickerPopover sharedPopover] colorPanel] color];
	}
}

- (void)popoverDidClose:(NSNotification *)notification {
	[[[BFColorPickerPopover sharedPopover] colorPanel] removeObserver:self forKeyPath:@"color"];
}

- (IBAction)animateCheckClicked:(id)sender {
	[[BFColorPickerPopover sharedPopover] setAnimates:(animateCheckmark.state == NSOnState)];
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover {
	return [[BFColorPickerPopover sharedPopover] colorPanel];
}

@end
