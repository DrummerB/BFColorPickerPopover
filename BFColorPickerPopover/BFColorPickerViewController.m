//
//  ColorPickerViewController.m
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

#import "BFColorPickerViewController.h"
#import "BFIconTabBar.h"
#import "NSColorWell+BFColorPickerPopover.h"

#define kColorPickerViewControllerTabbarHeight 30.0f

@interface BFColorPickerViewController ()

@property (nonatomic) BFIconTabBar *tabbar;
@property (nonatomic, weak) NSView *colorPanelView;

@end


@implementation BFColorPickerViewController

- (void)loadView {
	CGFloat tabbarHeight = 30.0f;
	NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 400.0f)];
	self.view = view;
	
	// If the shared color panel is visible, close it, because we need to steal its views.
	if ([NSColorPanel sharedColorPanelExists]) {
		[NSColorWell deactivateAll];
		[[NSColorPanel sharedColorPanel] orderOut:self];
	}
	
	self.colorPanel = [NSColorPanel sharedColorPanel];
	self.colorPanel.showsAlpha = YES;
	
	// Steal the color panel's toolbar icons ...
	NSMutableArray *tabbarItems = [[NSMutableArray alloc] initWithCapacity:6];
	NSToolbar *toolbar = self.colorPanel.toolbar;
	NSInteger selectedIndex = 0;
	for (int i = 0; i < toolbar.items.count; i++) {
		NSToolbarItem *toolbarItem = toolbar.items[i];
		NSImage *image = toolbarItem.image;
		
		BFIconTabBarItem *tabbarItem = [[BFIconTabBarItem alloc] initWithIcon:image tooltip:toolbarItem.toolTip];
		[tabbarItems addObject:tabbarItem];
		
		if ([toolbarItem.itemIdentifier isEqualToString:toolbar.selectedItemIdentifier]) {
			selectedIndex = i;
		}
	}

	// ... and put them into a custom toolbar replica.
	self.tabbar = [[BFIconTabBar alloc] init];
	self.tabbar.delegate = self;
	self.tabbar.items = tabbarItems;
	self.tabbar.frame = CGRectMake(0.0f, view.bounds.size.height - tabbarHeight, view.bounds.size.width, tabbarHeight);
	self.tabbar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	[self.tabbar selectIndex:selectedIndex];
	[view addSubview:self.tabbar];
	
	// Add the color picker view.
	self.colorPanelView = self.colorPanel.contentView;
	self.colorPanelView.frame = CGRectMake(0.0f, 0.0f, view.bounds.size.width, view.bounds.size.height - tabbarHeight);
	self.colorPanelView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	[view addSubview:self.colorPanelView];
	
	// Find and remove the color swatch resize dimple, because it crashes if used outside of a panel.
	NSArray *panelSubviews = [NSArray arrayWithArray:self.colorPanelView.subviews];
	for (NSView *subview in panelSubviews) {
		if ([subview isKindOfClass:NSClassFromString(@"NSColorPanelResizeDimple")]) {
			[subview removeFromSuperview];
		}
	}
}

// Forward the selection action message to the color panel.
- (void)tabBarChangedSelection:(BFIconTabBar *)tabbar {
	NSToolbarItem *selectedItem = self.colorPanel.toolbar.items[tabbar.selectedIndex];
	SEL action = selectedItem.action;
	[self.colorPanel performSelector:action withObject:selectedItem];
}

@end
