//
//  ChineseCalAppDelegate.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ChineseCalAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

