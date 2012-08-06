//
//  IconTabBar.m
//  CocosGame
//
//  Created by Balázs Faludi on 20.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
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

#import "BFIconTabBar.h"

@implementation BFIconTabBar

@synthesize items = _items;
@synthesize itemWidth = _itemWidth;
@synthesize multipleSelection = _multipleSelection;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_itemWidth = 32.0f;
		_multipleSelection = NO;
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
		
    }
    return self;
}


#pragma mark -
#pragma mark Convenience Methods

// x coordinate of the first item.
- (CGFloat)startX {
	int itemCount = (int)[_items count];
	CGFloat totalWidth = itemCount * _itemWidth;
	CGFloat startX = (self.bounds.size.width - totalWidth) / 2.0f;
	return startX;
}

- (BFIconTabBarItem *)itemAtX:(CGFloat)x {
	int index = floorf((x - [self startX]) / _itemWidth);
	if (index >= 0 && index < [_items count]) {
		return [_items objectAtIndex:index];
	}
	return nil;
}

#pragma mark -
#pragma mark Getters & Setters

- (NSMutableArray *)items {
	if (!_items) {
		_items = [NSMutableArray arrayWithCapacity:3];
	}
	return _items;
}

- (void)setItems:(NSArray *)newItems {
	if (newItems != _items) {
		_items = [NSMutableArray arrayWithArray:newItems];
		
		for (BFIconTabBarItem *item in _items) {
			item.tabBar = self;
		}
		
		if ([_selectedIndexes count] < 1) {
			[_selectedIndexes addIndex:0];
		}
		
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Selection

- (BFIconTabBarItem *)selectedItem {
	if ([_selectedIndexes count] > 0) {
		return [_items objectAtIndex:[_selectedIndexes firstIndex]];
	}
	return nil;
}

- (NSInteger)selectedIndex {
	return [_selectedIndexes count] < 1 ? -1 : [_selectedIndexes firstIndex];
}

- (NSArray *)selectedItems {
	if ([_selectedIndexes count] > 0) {
		return [_items objectsAtIndexes:_selectedIndexes];
	}
	return nil;
}

- (NSIndexSet *)selectedIndexes {
	return [[NSIndexSet alloc] initWithIndexSet:_selectedIndexes];
}

- (void)setMultipleSelection:(BOOL)multiple {
	if (multiple != _multipleSelection) {
		_multipleSelection = multiple;
		if (!_multipleSelection && [_selectedIndexes count] > 1) {
			NSUInteger firstIndex = [_selectedIndexes firstIndex];
			[_selectedIndexes removeAllIndexes];
			[_selectedIndexes addIndex:firstIndex];
			[self setNeedsDisplay];
		}
	}
}

- (void)selectIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extending {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Selection indexset empty.");
		return;
	}
	if (!extending || !_multipleSelection) {
		[self deselectAll];
	}
	if (_multipleSelection) {
		[_selectedIndexes addIndexes:indexes];
//		for (IconTabBarItem *item in [_items objectsAtIndexes:_selectedIndexes]) {
//			item.selected = YES;
//		}
	} else {
		[_selectedIndexes addIndex:[indexes firstIndex]];
//		IconTabBarItem *item = [_items objectAtIndex:[indexes firstIndex]];
//		item.selected = YES;
	}
	[self setNeedsDisplay];
}

- (void)selectIndex:(NSUInteger)index {
	[self selectIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:YES];
}

- (void)selectItem:(BFIconTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self selectIndex:index];
	}
}

- (IBAction)selectAll {
//	for (IconTabBarItem *item in _items) {
//		item.selected = YES;
//	}
	[_selectedIndexes addIndexesInRange:(NSRange){0, [_items count] - 1}];
	[self setNeedsDisplay];
}

- (void)deselectIndexes:(NSIndexSet *)indexes {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Deselection indexset empty.");
		return;
	}
//	for (IconTabBarItem *item in [_items objectsAtIndexes:indexes]) {
//		item.selected = NO;
//	}
	[_selectedIndexes removeIndexes:indexes];
	[self setNeedsDisplay];
}

- (void)deselectIndex:(NSUInteger)index {
	[self deselectIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deselectItem:(BFIconTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self deselectIndex:index];
	}
}

- (IBAction)deselectAll {
//	for (IconTabBarItem *item in [_items objectsAtIndexes:_selectedIndexes]) {
//		item.selected = NO;
//	}
	[_selectedIndexes removeAllIndexes];
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{

	//--------------------------
	// DRAW BACKGROUND GRADIENT
	//--------------------------
	
	//// Color Declarations
	NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.83 green: 0.83 blue: 0.83 alpha: 1];
	NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 0.68 green: 0.68 blue: 0.68 alpha: 1];
	NSColor* lineColor = [NSColor colorWithCalibratedRed:0.537 green:0.537 blue:0.537 alpha:1.000];
	
	if (![[self window] isKeyWindow])
	{
		gradientColor = [NSColor colorWithCalibratedRed:0.961 green:0.961 blue:0.961 alpha:1.000];
		gradientColor2 = [NSColor colorWithCalibratedRed:0.855 green:0.855 blue:0.855 alpha:1.000];
		lineColor = [NSColor colorWithCalibratedRed:0.537 green:0.537 blue:0.537 alpha:1.000];
	}
	
	//------------------
	// DRAW BUTTON ITEMS
	//------------------
	
	//// Prepare selection border gradients.
	
	//// Color Declarations
	NSColor* gradientOutsideTop = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
	NSColor* gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.37 alpha:1.0];
	NSColor* gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.59 alpha:1.0];
	NSColor* gradientInsideTop = gradientColor;
	NSColor* gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.59 alpha:1.0];
	NSColor* gradientInsideBottom = gradientColor2;
	NSColor* selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.67 alpha:1.0];
	
	if (![self.window isKeyWindow]) {
		gradientOutsideTop = [NSColor colorWithDeviceWhite:0.83 alpha:1.0];
		gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.43 alpha:1.0];
		gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.79 alpha:1.0];
	}
	
	NSGradient* selectionGradient = [[NSGradient alloc] initWithColorsAndLocations: 
									 gradientColor, 0.0, 
									 selectionGradientMiddle, 0.50, 
									 gradientColor2, 1.0, nil];
	NSGradient* gradientOutside = [[NSGradient alloc] initWithColorsAndLocations: 
								   gradientOutsideTop, 0.0, 
								   gradientOutsideMiddle, 0.50, 
								   gradientOutsideBottom, 1.0, nil];
	NSGradient* gradientInside = [[NSGradient alloc] initWithColorsAndLocations: 
								  gradientInsideTop, 0.0, 
								  gradientInsideMiddle, 0.50, 
								  gradientInsideBottom, 1.0, nil];
	
	
	CGFloat startX = [self startX];
	[self removeAllToolTips];
	
	for (int i = 0; i < [_items count]; i++) {
		BFIconTabBarItem *item = [_items objectAtIndex:i];
		CGFloat currentX = startX + i * _itemWidth;
		
		// Add tooltip area.
		NSRect selectionFrame = NSMakeRect(floorf(currentX + 0.5), 1, _itemWidth, self.bounds.size.height - 2);
		[self addToolTipRect:selectionFrame owner:item.tooltip userData:nil];
		
		if ([_selectedIndexes containsIndex:i]) {
			
			//// Draw selection gradients
			CGFloat gradientHeight = self.bounds.size.height - 2;
			NSRect outsideLineFrameLeft = NSMakeRect(floorf(currentX + 0.5), 1, 1, gradientHeight);
			NSRect insideLineFrameLeft = NSMakeRect(floorf(currentX + 1.5), 1, 1, gradientHeight);
			NSRect outsideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth + 0.5), 1, 1, gradientHeight);
			NSRect insideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth - 0.5), 1, 1, gradientHeight);
			
			NSBezierPath* selectionFramePath = [NSBezierPath bezierPathWithRect: selectionFrame];
			[selectionGradient drawInBezierPath: selectionFramePath angle: -90];
			
			NSBezierPath* outsideLinePathLeft = [NSBezierPath bezierPathWithRect: outsideLineFrameLeft];
			[gradientOutside drawInBezierPath: outsideLinePathLeft angle: -90];
			
			NSBezierPath* insideLinePathLeft = [NSBezierPath bezierPathWithRect: insideLineFrameLeft];
			[gradientInside drawInBezierPath: insideLinePathLeft angle: -90];
			
			NSBezierPath* outsideLinePathRight = [NSBezierPath bezierPathWithRect: outsideLineFrameRight];
			[gradientOutside drawInBezierPath: outsideLinePathRight angle: -90];
			
			NSBezierPath* insideLinePathRight = [NSBezierPath bezierPathWithRect: insideLineFrameRight];
			[gradientInside drawInBezierPath: insideLinePathRight angle: -90];
		}
		
		// Draw icon
		CGPoint center = CGPointMake(currentX + _itemWidth / 2.0f, self.bounds.size.height / 2.0f);
		
		NSImage *embossedImage = item.icon;
		
		CGRect fromRect = CGRectMake(0.0f, 0.0f, embossedImage.size.width, embossedImage.size.height);
		CGPoint position = CGPointMake(roundf(center.x - embossedImage.size.width / 2.0f), roundf(center.y - embossedImage.size.height / 2.0f));
		[embossedImage drawAtPoint:position fromRect:fromRect operation:NSCompositeSourceOver fraction:1.0f];
	}
	
	
	
	//// Line Drawing
	NSBezierPath* line1 = [NSBezierPath bezierPath];
	[line1 moveToPoint: NSMakePoint(0.0, 0.5)];
	[line1 lineToPoint: NSMakePoint(self.bounds.size.width, 0.5)];
	[lineColor setStroke];
	[line1 setLineWidth: 1];
	[line1 stroke];
}

#pragma mark -
#pragma mark Events

- (void)notify {
	[NSApp sendAction:[self action] to:[self target] from:self];
	if ([_delegate respondsToSelector:@selector(tabBarChangedSelection:)]) {
		[_delegate tabBarChangedSelection:self];
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	BFIconTabBarItem *item = [self itemAtX:point.x];
	if (item) {
		_pressedItem = item;
		if (_multipleSelection) {
			// Remember if the first clicked item was selected or deselected. Dragging onto other items will do the same operation, if multipleSelection is enabled.
			_firstItemWasSelected = ![[self selectedItems] containsObject:_pressedItem];
			if (_firstItemWasSelected) {
				[self selectItem:_pressedItem];
			} else {
				[self deselectItem:_pressedItem];
			}
		} else {
			[self selectItem:_pressedItem];
		}
		[self notify];
		[self setNeedsDisplay];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	[super mouseDragged:theEvent];
	CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	BFIconTabBarItem *item = [self itemAtX:point.x];
	if (item != _pressedItem) {
		_pressedItem = item;
		if (_multipleSelection && !_firstItemWasSelected) {
			[self deselectItem:_pressedItem];
		} else {
			[self selectItem:_pressedItem];
		}
		[self notify];
		[self setNeedsDisplay];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	[super mouseUp:theEvent];
	_pressedItem = nil;
	[self setNeedsDisplay];
}

@end

#pragma mark -
#pragma mark -

@implementation BFIconTabBarItem

@synthesize icon = _icon;
@synthesize tooltip = _tooltip;
@synthesize tabBar = _tabBar;

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
    self = [super init];
    if (self) {
        self.icon = image;
		self.tooltip = tooltipString;
    }
    return self;
}

+ (BFIconTabBarItem *)itemWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
	return [[BFIconTabBarItem alloc] initWithIcon:image tooltip:tooltipString];
}


#pragma mark -
#pragma mark Getters & Setters

- (void)setIcon:(NSImage *)newIcon {
	if (newIcon != _icon) {
		_icon = newIcon;
		
		[_tabBar setNeedsDisplay];
	}
}


@end





