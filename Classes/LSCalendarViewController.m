//
//  LSCalendarViewController.m
//  ChineseCal
//
//  Created by Edwin Tanizar on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LSCalendarViewController.h"
#import "CalendarYear.h"
#import "WeeklyCalendarCell.h"

@implementation LSCalendarViewController

- (void) initInfoButton {
	// create a UIButton (UIButtonTypeInfoLight)
	infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	infoButton.frame = CGRectMake(450.0, 265.0, 25.0, 25.0);
	infoButton.backgroundColor = [UIColor clearColor];
	[infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void) scrollToToday {
	CalendarMonth *calMonth = [calendarYear.months objectAtIndex:(calendarYear.todayMonth -1)];
	NSInteger weekIndex = 0;
	for (int i=0; i<[[calMonth weeks] count]; i++) {
		CalendarWeek *calWeek = [[calMonth weeks] objectAtIndex:i];
		for (CalendarDay *calDay in calWeek.days) {
			if (calDay.day==calendarYear.todayDay) {
				weekIndex = i;
				break;
			}
		}
		if (weekIndex>0) break;
	}		
	
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:weekIndex inSection:(calendarYear.todayMonth - 1)];
	[[self calendarTableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	DebugLog(@"Loading LSViewController");
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [calendarYear.months count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	CalendarMonth *calMonth = [calendarYear.months objectAtIndex:section];
    return [[calMonth weeks] count];
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	CalendarMonth *calMonth = [calendarYear.months objectAtIndex:section];
	NSString *title = [NSString stringWithFormat:@"%@ (%@)", calMonth.name, calMonth.cname];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
	CalendarMonth *calMonth = [calendarYear.months objectAtIndex:section];
	CalendarWeek *calWeek = [[calMonth weeks] objectAtIndex:row];
    
	static NSString *CalendarCellId = @"WeeklyCalendarCell";
    
    WeeklyCalendarCell *cell = (WeeklyCalendarCell *) [tableView dequeueReusableCellWithIdentifier:
										   CalendarCellId];
    if (cell == nil) {
		cell = [[WeeklyCalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CalendarCellId];
	} else {
		[cell clear];
	}
	
	for (CalendarDay *calDay in [calWeek days]) {
		UILabel* dayLabel = [cell dayLabelAtIndex:[calDay weekDay]];
		dayLabel.text = [NSString stringWithFormat:@"%d", [calDay day]];
		
		UILabel* cnameLabel = [cell cnameLabelAtIndex:[calDay weekDay]];
		cnameLabel.text = [NSString stringWithFormat:@"%@%@", [calDay cmonthName], [calDay cdateName]];
	}

    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return calendarYear.shortMonths;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];

	if (calendarYear.year==calendarYear.todayYear && section==(calendarYear.todayMonth-1)) {
		CalendarMonth *calMonth = [calendarYear.months objectAtIndex:section];
		CalendarWeek *calWeek = [[calMonth weeks] objectAtIndex:row];

		for (CalendarDay *calDay in calWeek.days) {
			if (calDay.day==calendarYear.todayDay) {
				WeeklyCalendarCell *calCell = (WeeklyCalendarCell *)cell;
				[calCell dayButtonAtIndex:[calDay weekDay]].backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3F];
				break;
			}
		} 
	} 
}
@end
