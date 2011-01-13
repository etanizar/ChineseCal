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
//  CalendarYear.h
//  ChineseCal
//

#import <Foundation/Foundation.h>

#pragma mark CalendarDay interface

@interface CalendarDay : NSObject {
	NSInteger weekDay; // 0=Sunday ... 6=Saturday
	NSInteger day;
	NSInteger cmonth;
	NSInteger cdate;
	NSString *leap;
	NSString *cmonthName;
	NSString *cdateName;
}

@property (nonatomic) NSInteger weekDay;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger cmonth;
@property (nonatomic) NSInteger cdate;
@property (nonatomic, retain) NSString *leap;
@property (nonatomic, retain) NSString *cmonthName;
@property (nonatomic, retain) NSString *cdateName;

@end

#pragma mark -
#pragma mark CalendarWeek interface

@interface CalendarWeek : NSObject
{
	NSInteger weekOfMonth;
	NSMutableArray *days;
}

@property (nonatomic) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSMutableArray *days;

- (void)addDay: (CalendarDay *)calDay;

@end

#pragma mark -
#pragma mark CalendarMonth interface

@interface CalendarMonth : NSObject {
	NSInteger month;
	NSString *name;
	NSString *cname;
	NSMutableArray *days;
	NSMutableArray *weeks;
}

@property (nonatomic) NSInteger month;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *cname;
@property (nonatomic, readonly) NSMutableArray *days;
@property (nonatomic, readonly) NSMutableArray *weeks;

- (void)addDay: (CalendarDay *)calDay;
- (void)addWeek: (CalendarWeek *)calWeek;

@end

#pragma mark -
#pragma mark CalendarYear interface

@interface CalendarYear : NSObject {
	NSArray *weekDays;
	NSArray *cweekDays;
	NSArray *shortMonths;
	
	NSInteger year;
	NSMutableArray *months;
	
	NSDate *today;
	NSInteger todayDay;
	NSInteger todayMonth;
	NSInteger todayYear;
}

+ (CalendarYear*)sharedInstance;

@property (nonatomic, readonly) NSArray *weekDays;
@property (nonatomic, readonly) NSArray *cweekDays;
@property (nonatomic, readonly) NSArray *shortMonths; 

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSMutableArray *months;

@property (nonatomic, retain) NSDate *today;
@property (nonatomic, readonly) NSInteger todayDay;
@property (nonatomic, readonly) NSInteger todayMonth;
@property (nonatomic, readonly) NSInteger todayYear;

- (void) refreshToday;
- (void) loadCalendarForYear: (NSInteger)year;

@end
