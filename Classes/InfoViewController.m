    //
//  InfoViewController.m
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "RootViewController.h"

@implementation InfoViewController

@synthesize rootController;

- (IBAction)doneButtonPressed {
	[rootController switchViews]; 
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
    [super dealloc];
}

@end
