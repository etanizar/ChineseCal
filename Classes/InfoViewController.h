//
//  InfoViewController.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface InfoViewController : UIViewController {
	RootViewController *rootController;
}

@property (nonatomic, retain) RootViewController *rootController;

- (IBAction)doneButtonPressed;

@end
