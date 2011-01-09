//
//  CalendarViewController.m
//  ChineseCal
//
//  Created by Edwin Tanizar on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarYear.h"
#import "CalendarCell.h"
#import "RootViewController.h"

@implementation CalendarViewController

@synthesize rootController;
@synthesize prevButton;
@synthesize nextButton;
@synthesize navBar;
@synthesize calendarTableView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	calendarYear = [CalendarYear sharedInstance];
	
	[self initInfoButton];
	
	// Add a custom accessibility label to the button because it has no associated text.
	[infoButton setAccessibilityLabel:NSLocalizedString(@"MoreInfoButton", @"")];
	[self.view addSubview:infoButton];

	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(yearChanged:)
												 name: @"yearChanged"
											   object: nil ];
	
	[self yearChanged:nil];
	[super viewDidLoad];
}

- (void) initInfoButton {
	// create a UIButton (UIButtonTypeInfoLight)
	infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	infoButton.frame = CGRectMake(290.0, 425.0, 25.0, 25.0);
	infoButton.backgroundColor = [UIColor clearColor];
	[infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) gotoPrevYear {
	[calendarYear loadCalendarForYear:(calendarYear.year-1)];
}

- (IBAction) gotoToday {
	[calendarYear loadCalendarForYear:(calendarYear.todayYear)];
}

- (IBAction) gotoNextYear {
	[calendarYear loadCalendarForYear:(calendarYear.year+1)];
}

- (void) yearChanged: (NSNotification *) notification
{
	prevButton.title = [NSString stringWithFormat:@"%d", (calendarYear.year - 1)];
	navBar.topItem.title = [NSString stringWithFormat:@"%d", calendarYear.year];
	nextButton.title = [NSString stringWithFormat:@"%d", (calendarYear.year + 1)];
	[calendarTableView reloadData];
	
	if (calendarYear.year==calendarYear.todayYear) {
		[self scrollToToday];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.prevButton = nil;
	self.nextButton = nil;
	self.navBar = nil;
	self.calendarTableView = nil;
	
	[infoButton release];
	infoButton = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	[prevButton release];
	[nextButton release];
	[navBar	release];
	[calendarTableView release];
	[infoButton release];
	
	[super dealloc];
}

- (void)scrollToToday {
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(calendarYear.todayDay - 1) 
													  inSection:(calendarYear.todayMonth - 1)];
	[[self calendarTableView] scrollToRowAtIndexPath:scrollIndexPath 
									atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)infoButtonPressed {
	[rootController switchViews]; 
}

- (void) showYearPicker {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
													  delegate:self
											 cancelButtonTitle:@"Cancel"
										destructiveButtonTitle:@"OK"
											 otherButtonTitles:nil];
	// Add the picker
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,150,0,0)];
	
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES; // Note: this defaults to NO
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet addSubview:pickerView];
	[actionSheet showInView:self.view];
	[actionSheet setBounds:CGRectMake(0,0,320,580)];
	
	selectedYear = calendarYear.year; 
	[pickerView selectRow:(selectedYear-1800) inComponent:0 animated:YES];
	
	[pickerView release];
	[actionSheet release];
}

#pragma mark -
#pragma mark YearPicker Data Source Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row 
			forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i", (row+1800)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 400;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selectedYear = row + 1800;
}

#pragma mark -
#pragma mark ActionSheet Button Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex==0){
		[calendarYear loadCalendarForYear:selectedYear];
	}
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
    return [[calMonth days] count];
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
    CalendarDay *calDay = [[calMonth days] objectAtIndex: row]; 
    
	static NSString *CalendarCellId = @"DefaultCalendarCell";
    
    CalendarCell *cell = (CalendarCell *) [tableView dequeueReusableCellWithIdentifier:
						  CalendarCellId];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CalendarCellId owner:self options:nil];
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[CalendarCell class]])
				cell = (CalendarCell *)oneObject;
	}

	cell.dayLabel.text = [NSString stringWithFormat:@"%d", [calDay day]];
	cell.weekDayLabel.text = [calendarYear.weekDays objectAtIndex:[calDay weekDay]];
	cell.cweekDayLabel.text = [calendarYear.cweekDays objectAtIndex:[calDay weekDay]];
    cell.cnameLabel.text = [NSString stringWithFormat:@"%@ %@", [calDay cmonthName], [calDay cdateName]];

	UIColor *textColor;
	switch ([calDay weekDay]) {
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
		
	cell.dayLabel.textColor = textColor;
	cell.weekDayLabel.textColor = textColor;
	cell.cweekDayLabel.textColor = textColor;
	cell.cnameLabel.textColor = textColor;
	
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
	if (calendarYear.year==calendarYear.todayYear && [indexPath section]==(calendarYear.todayMonth-1) && [indexPath row]==(calendarYear.todayDay-1)) 
		cell.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3F];
}

@end
