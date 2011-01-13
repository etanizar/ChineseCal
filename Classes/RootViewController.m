/*
 Copyright (C) 2011 by Edwin Tanizar
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

//
//  RootViewController.m
//  ChineseCal
//

#import "RootViewController.h"
#import "CalendarViewController.h"
#import "InfoViewController.h"
#import "LSCalendarViewController.h"

@interface RootViewController ()
- (void)showView: (enum viewType) showViewType;
@end

@implementation RootViewController

@synthesize calendarViewController;
@synthesize lsCalendarViewController;
@synthesize infoViewController;
@synthesize lsInfoViewController;

- (void)showView: (enum viewType) showViewType {
	
	// Remove the current view
	switch (currentViewType) {
		case portraitCalendar:
			[calendarViewController.view removeFromSuperview];
			break;
		case portraitInfo:
			[infoViewController.view removeFromSuperview];
			break;
		case landscapeCalendar:
			[lsCalendarViewController.view removeFromSuperview];
			break;
		case landscapeInfo:
			[lsInfoViewController.view removeFromSuperview];
			break;
		default:
			break;
	}
	
	// Create the new view and insert to rootView
	switch (showViewType) {
		case portraitCalendar:
			if (self.calendarViewController==nil) {
				CalendarViewController *calendarController = [[CalendarViewController alloc]
															  initWithNibName:@"CalendarView" bundle:nil];
				self.calendarViewController = calendarController;
				[calendarController release];
			}
			[self.view insertSubview:calendarViewController.view atIndex:0];
			break;
		case portraitInfo:
			if (self.infoViewController==nil) {
				InfoViewController *infoController = [[InfoViewController alloc]
													  initWithNibName:@"InfoView" bundle:nil];
				self.infoViewController = infoController;
				[infoController release];
			}
			[self.view insertSubview:infoViewController.view atIndex:0];
			break;
		case landscapeCalendar:
			if (self.lsCalendarViewController==nil) {
				LSCalendarViewController *lsCalendarController = [[LSCalendarViewController alloc] 
																  initWithNibName:@"LSCalendarView" bundle:nil];
				self.lsCalendarViewController = lsCalendarController;
				[lsCalendarController release];
			}
			[self.view insertSubview:lsCalendarViewController.view atIndex:0];
			break;
		case landscapeInfo:
			if (self.lsInfoViewController==nil) {
				InfoViewController *lsInfoController = [[InfoViewController alloc]
														initWithNibName:@"LSInfoView" bundle:nil];
				self.lsInfoViewController = lsInfoController;
				[lsInfoController release];
			}
			[self.view insertSubview:lsInfoViewController.view atIndex:0];
			break;
		default:
			break;
	}

	currentViewType = showViewType;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.view.autoresizesSubviews = NO;

	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(viewSwitched:)
												 name: @"viewSwitched"
											   object: nil ];
	
	[self showView:portraitCalendar];
    [super viewDidLoad];
}

- (void) viewSwitched: (NSNotification *) notification {
	[UIView beginAnimations:@"ViewFlip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	
	switch (currentViewType) {
		case portraitCalendar:
			[self showView:portraitInfo];
			break;
		case portraitInfo:
			[self showView:portraitCalendar];
			break;
		case landscapeCalendar:
			[self showView:landscapeInfo];
			break;
		case landscapeInfo:
			[self showView:landscapeCalendar];
			break;
		default:
			break;
	}

	[UIView commitAnimations];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
										 duration:(NSTimeInterval)duration {
	
	if (toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) return;
	
	switch (currentViewType) {
		case portraitCalendar:
			if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft ||
				toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
				[self showView:landscapeCalendar];
			}
			break;
		case portraitInfo:
			if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft ||
				toInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
				[self showView:landscapeInfo];
			}
			break;
		case landscapeCalendar:
			if (toInterfaceOrientation==UIInterfaceOrientationPortrait) {
				[self showView:portraitCalendar];
			}
			break;
		case landscapeInfo:
			if (toInterfaceOrientation==UIInterfaceOrientationPortrait) {
				[self showView:portraitInfo];
			}
			break;
		default:
			break;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[infoViewController release];
	[calendarViewController release];
	[lsInfoViewController release];
	[lsCalendarViewController release];
    [super dealloc];
}


@end
