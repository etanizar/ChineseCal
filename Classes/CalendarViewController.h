//
//  CalendarViewController.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class CalendarYear;

@interface CalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate> {
	UIBarButtonItem *prevButton;
	UIBarButtonItem *nextButton;
	UINavigationBar *navBar;
	UITableView *calendarTableView;
	UIButton *infoButton;
	CalendarYear *calendarYear;
	
	NSInteger selectedYear; // for year picker
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar; 
@property (nonatomic, retain) IBOutlet UITableView *calendarTableView;

- (IBAction)gotoPrevYear;
- (IBAction)gotoNextYear;
- (IBAction)gotoToday;
- (IBAction)showYearPicker;

- (void) yearChanged: (NSNotification *) notification;
- (void) initInfoButton;
- (void) scrollToToday;
- (void) infoButtonPressed;

@end
