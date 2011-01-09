//
//  RootViewController.m
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
				calendarController.rootController = self;
				[calendarController release];
			}
			[self.view insertSubview:calendarViewController.view atIndex:0];
			break;
		case portraitInfo:
			if (self.infoViewController==nil) {
				InfoViewController *infoController = [[InfoViewController alloc]
													  initWithNibName:@"InfoView" bundle:nil];
				self.infoViewController = infoController;
				infoController.rootController = self;
				[infoController release];
			}
			[self.view insertSubview:infoViewController.view atIndex:0];
			break;
		case landscapeCalendar:
			if (self.lsCalendarViewController==nil) {
				LSCalendarViewController *lsCalendarController = [[LSCalendarViewController alloc] 
																  initWithNibName:@"LSCalendarView" bundle:nil];
				self.lsCalendarViewController = lsCalendarController;
				lsCalendarController.rootController = self;
				[lsCalendarController release];
			}
			[self.view insertSubview:lsCalendarViewController.view atIndex:0];
			break;
		case landscapeInfo:
			if (self.lsInfoViewController==nil) {
				InfoViewController *lsInfoController = [[InfoViewController alloc]
														initWithNibName:@"LSInfoView" bundle:nil];
				self.lsInfoViewController = lsInfoController;
				lsInfoController.rootController = self;
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
	[self showView:portraitCalendar];
    [super viewDidLoad];
}

- (void) switchViews {
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
