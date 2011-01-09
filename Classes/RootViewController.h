//
//  RootViewController.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSCalendarViewController;
@class CalendarViewController;
@class InfoViewController;

enum viewType {
	portraitCalendar, 
	portraitInfo,
	landscapeCalendar,
	landscapeInfo
};

@interface RootViewController : UIViewController {
	CalendarViewController *calendarViewController;
	LSCalendarViewController *lsCalendarViewController;
	InfoViewController *infoViewController;
	InfoViewController *lsInfoViewController;
	enum viewType currentViewType;
}

@property (retain, nonatomic) CalendarViewController *calendarViewController;
@property (retain, nonatomic) LSCalendarViewController *lsCalendarViewController;
@property (retain, nonatomic) InfoViewController *infoViewController;
@property (retain, nonatomic) InfoViewController *lsInfoViewController;

- (void) switchViews;

@end
