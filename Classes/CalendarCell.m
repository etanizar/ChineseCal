//
//  CalendarCell.m
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarCell.h"


@implementation CalendarCell

@synthesize dayLabel;
@synthesize weekDayLabel;
@synthesize cweekDayLabel;
@synthesize cnameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[dayLabel release];
	[weekDayLabel release];
	[cweekDayLabel release];
	[cnameLabel release];
    [super dealloc];
}


@end
