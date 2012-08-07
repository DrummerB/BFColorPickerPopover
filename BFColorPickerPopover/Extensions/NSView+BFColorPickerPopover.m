//
//  NSView+BFColorPickerPopover.m
//  BFColorPickerPopover Demo
//
//  Created by Balázs Faludi on 07.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import "NSView+BFColorPickerPopover.h"

@implementation NSView (BFColorPickerPopover)

- (NSImage *)imageWithSubviews
{
	NSSize mySize = self.bounds.size;
	NSSize imgSize = NSMakeSize( mySize.width, mySize.height );
	
	NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
	[bir setSize:imgSize];
	[self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
	
	NSImage *image = [[NSImage alloc] initWithSize:imgSize];
	[image addRepresentation:bir];
	return image;
}

@end
