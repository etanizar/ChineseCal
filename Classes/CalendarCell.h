//
//  CalendarCell.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarCell : UITableViewCell {
	UILabel *dayLabel;
	UILabel	*weekDayLabel;
	UILabel *cweekDayLabel;
	UILabel *cnameLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *dayLabel;
@property (nonatomic, retain) IBOutlet UILabel *weekDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *cweekDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *cnameLabel;

@end
