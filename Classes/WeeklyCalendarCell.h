//
//  WeeklyCalendarCell.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayCell;

@interface WeeklyCalendarCell : UITableViewCell {
	UIButton *dayButtons[7];
	UILabel *dayLabels[7];
	UILabel *cnameLabels[7];
}

- (void) clear;
- (UILabel *) dayLabelAtIndex: (NSInteger)index;
- (UILabel *) cnameLabelAtIndex: (NSInteger)index;
- (UIButton *) dayButtonAtIndex: (NSInteger)index;

@end
