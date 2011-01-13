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
//  CalendarYear.m
//  ChineseCal
//

#import "CalendarYear.h"
#import "GDataXMLNode.h"

#include "ccal.h"
#include <stdio.h>

#pragma mark CalendarDay implementation

@implementation CalendarDay

@synthesize weekDay;
@synthesize day;
@synthesize cmonth;
@synthesize cdate;
@synthesize leap;
@synthesize cmonthName;
@synthesize cdateName;

- (void)dealloc {
	[leap release];
	[cmonthName release];
	[cdateName release];
	[super dealloc];
}

@end

#pragma mark -
#pragma mark CalendarWeek implementation

@implementation CalendarWeek

@synthesize weekOfMonth;
@synthesize days;

- (id)init {
	self = [super init];
	
	if (self) {
		days = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addDay:(CalendarDay *)calDay {
	[days addObject:calDay];
}

- (void)dealloc {
	[days release];
	[super dealloc];
}

@end


#pragma mark -
#pragma mark CalendarMonth implementation

@implementation CalendarMonth

@synthesize month;
@synthesize name;
@synthesize cname;
@synthesize days;
@synthesize weeks;

- (id)init {
	self = [super init];
	
	if (self) {
		days = [[NSMutableArray alloc] init];
		weeks = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addDay:(CalendarDay *)calDay {
	[days addObject:calDay];
}

- (void)addWeek:(CalendarWeek *)calWeek {
	[weeks addObject:calWeek];
}

- (void)dealloc {
	[name release];
	[cname release];
	[days release];
	[weeks release];
	[super dealloc];
}

#pragma mark -
#pragma mark CalendarYear (Private) interface

@end

@interface CalendarYear (Private)
- (void)loadCalendarFromFile:(NSString *)filePath;
- (NSString *) getXmlPathForYear: (NSInteger)year;
@end

#pragma mark -
#pragma mark CalendarYear implementation

static CalendarYear *sharedInstance = nil;

@implementation CalendarYear

// Global variable to hold the file pointer to the calendar file
FILE *g_ccal_ofp;

#pragma mark -
#pragma mark class instance methods

@synthesize weekDays;
@synthesize cweekDays;
@synthesize shortMonths;

@synthesize year;
@synthesize months;

@synthesize today;
@synthesize todayYear;
@synthesize todayMonth;
@synthesize todayDay;

- (id) init {
	DebugLog(@"init CalendarYear");
	
	// Init shortMonths
	shortMonths = [[NSArray alloc] initWithObjects: 
				   @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", 
				   @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
	
	// Init weekDays
	weekDays = [[NSArray alloc] initWithObjects:
				@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
	cweekDays = [[NSArray alloc] initWithObjects:
				 @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
	
	months = [[NSMutableArray alloc] init];	
	
	[self refreshToday];
	[self loadCalendarForYear:todayYear];
	
	return self;
}

- (void)dealloc {
	[shortMonths release];
	[weekDays release];
	[cweekDays release];
	[months release];
	[today release];
	[super dealloc];
}

- (void)refreshToday {
	DebugLog(@"refreshToday");
	self.today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *calComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
	todayDay = [calComponents day];
	todayMonth = [calComponents month];
	todayYear = [calComponents year];
	[gregorian release];
}

- (NSString *) getXmlPathForYear:(NSInteger)calYear {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%d.xml", calYear];
	NSString *xmlPath = [docDir stringByAppendingPathComponent:filename];
	return xmlPath;
}

- (void)loadCalendarForYear:(NSInteger)loadYear {
	DebugLog(@"loadCalendarForYear: loadYear=%d", loadYear);

	NSString *xmlPath = [[NSString alloc] initWithString: [self getXmlPathForYear:loadYear]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:xmlPath]) {
		char outputPath[500];
		strcpy(outputPath, [xmlPath UTF8String]);
		g_ccal_ofp = fopen(outputPath, "w");
		
		char *arg0 = (char*)"ccal";
		char *arg1 = (char*)"-b"; // BIG5 (Chinese Traditional)
		char *arg2 = (char*)"-x"; // XML Output
		char yearArg[5];
		strcpy(yearArg, [[NSString stringWithFormat:@"%d", loadYear] UTF8String]);
		char *args[] = {arg0, arg1, arg2, yearArg, NULL};
		ccal_main(4, args);

		fclose(g_ccal_ofp);
	}
	[self loadCalendarFromFile:xmlPath];
	[[NSFileManager defaultManager] removeItemAtPath:xmlPath error:NULL];
	[xmlPath release];
	
	year = loadYear;
	[self refreshToday];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"yearChanged" object:nil];
}

// Loads all the months from the xml file
- (void)loadCalendarFromFile:(NSString *)filePath {
	DebugLog(@"loadCalendarFromFile: filePath=%@", filePath);
	
	[months removeAllObjects];
	NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
    if (doc == nil) { return; }
	
	NSArray *ccalMonths = [doc.rootElement elementsForName:@"ccal:month"];
	for (GDataXMLElement *ccalMonth in ccalMonths) {
		CalendarMonth *calMonth = [[CalendarMonth alloc] init];
		calMonth.month = [[[ccalMonth attributeForName:@"value"] stringValue] intValue];
		calMonth.name = [[ccalMonth attributeForName:@"name"] stringValue];
		calMonth.cname = [[ccalMonth attributeForName:@"cname"] stringValue];
		
		NSArray *ccalWeeks = [ccalMonth elementsForName:@"ccal:week"];
		
		NSInteger weekOfMonth = 0;
		for (GDataXMLElement *ccalWeek in ccalWeeks) {
			CalendarWeek *calWeek = [[CalendarWeek alloc] init];
			calWeek.weekOfMonth = ++weekOfMonth;
			
			NSInteger weekDay = 0;
			NSArray *ccalDays = [ccalWeek elementsForName:@"ccal:day"];
			for (GDataXMLElement *ccalDay in ccalDays) {
				NSString *day = [[ccalDay attributeForName:@"value"] stringValue];
				if (day!=nil) {
					CalendarDay *calDay = [[CalendarDay alloc] init];
					calDay.weekDay = weekDay;
					calDay.day = [day intValue];
					calDay.cmonth = [[[ccalDay attributeForName:@"cmonth"] stringValue] intValue];
					calDay.cdate = [[[ccalDay attributeForName:@"cdate"] stringValue] intValue];
					calDay.leap	= [[ccalDay attributeForName:@"leap"] stringValue]; 
					calDay.cmonthName = [[ccalDay attributeForName:@"cmonthname"] stringValue]; 
					calDay.cdateName = [[ccalDay attributeForName:@"cdatename"] stringValue];
					[calWeek addDay:calDay];
					[calMonth addDay:calDay]; 
					[calDay release];
				}
				weekDay++;
			}
			
			[calMonth addWeek:calWeek];
			[calWeek release];
		}
		
		[months addObject:calMonth];
		[calMonth release];
	}
	
    [doc release];
    [xmlData release];
    return;
}

#pragma mark -
#pragma mark Singleton methods

+ (CalendarYear*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[CalendarYear alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end