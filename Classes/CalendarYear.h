//
//  CalendarYear.h
//  ChineseCal
//
//  Created by Edwin Tanizar on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
