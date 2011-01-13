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
//  WeeklyCalendarCell.m
//  ChineseCal
//

#import "WeeklyCalendarCell.h"

@interface WeeklyCalendarCell (Private) 
- (DayCell *) loadDayCellFromNib;
@end

@implementation WeeklyCalendarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		for (int i=0; i<7; i++) {
			UIButton *dayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			dayButton.frame = CGRectMake(i*62.0, 0, 62.0, 44.0);
			[self.contentView addSubview:dayButton];
			
			CGRect dayLabelRect = CGRectMake(i*62 + 10, 1, 42, 26);
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelRect];
			dayLabel.textAlignment = UITextAlignmentCenter;
			dayLabel.font = [UIFont boldSystemFontOfSize:21.0];
			[self.contentView addSubview:dayLabel];
			
			CGRect cnameLabelRect = CGRectMake(i*62 + 1, 22, 60, 21);
			UILabel *cnameLabel = [[UILabel alloc] initWithFrame:cnameLabelRect];
			cnameLabel.textAlignment = UITextAlignmentCenter;
			cnameLabel.font = [UIFont systemFontOfSize:11.0];
			[self.contentView addSubview:cnameLabel];
			
			UIColor *textColor;
			switch (i) {
				case 0:
					textColor = [UIColor redColor];
					break;
				case 6:
					textColor = [UIColor orangeColor];
					break;
				default:
					textColor = [UIColor blackColor];
					break;
			}

			dayLabel.textColor = textColor;
			cnameLabel.textColor = textColor;
			
			dayButtons[i] = dayButton;
			dayLabels[i] = dayLabel;
			cnameLabels[i] = cnameLabel;
		}
    }
	[self clear];

    return self;
}

- (void) clear {
	for (int i=0; i<7; i++) {
		dayButtons[i].backgroundColor = [UIColor clearColor];
		dayLabels[i].backgroundColor = [UIColor clearColor];
		cnameLabels[i].backgroundColor = [UIColor clearColor];
		dayLabels[i].text = nil;
		cnameLabels[i].text = nil;
	}
}

- (UILabel *) dayLabelAtIndex:(NSInteger)index {
	return dayLabels[index];
}

- (UILabel *) cnameLabelAtIndex:(NSInteger)index {
	return cnameLabels[index];	
}

- (UIButton *) dayButtonAtIndex:(NSInteger)index {
	return dayButtons[index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

- (void)dealloc {
	for (int i=0; i<7; i++) {
		[dayButtons[i] release];
		[dayLabels[i] release];
		[cnameLabels[i] release];
	}
    [super dealloc];
}

@end
