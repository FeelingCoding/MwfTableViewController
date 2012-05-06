//
//  MwfDemoTableViewController.m
//  MwfTableViewController
//
//  Created by Meiwin Fu on 23/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import "MwfDemoTableViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface MwfDemoTableViewController ()
- (void)loadMoreInTheBackground;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface DemoData : NSObject
@property (nonatomic,retain) NSString * value;
- (id)initWithValue:(NSString *)value;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation DemoData
@synthesize value = _value;
- (id)initWithValue:(NSString *)value;
{
  self = [super init];
  if (self) {
    _value = value;
  }
  return self;
}
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#define $data(_val_) [[DemoData alloc] initWithValue:(_val_)]

@implementation MwfDemoTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"No Section";
    self.wantSearch = YES;
    self.searchDelayInSeconds = 0.1;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  UIBarButtonItem * toggleButton = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(toggle:)];
  self.navigationItem.rightBarButtonItem = toggleButton;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.rowHeight = 60;
}

- (MwfTableData *)createAndInitTableData;
{
  MwfTableData * tableData = [MwfTableData createTableData];
  [tableData addRow:$data(@"Row 1")];
  [tableData addRow:$data(@"Row 2")];
  [tableData addRow:$data(@"Row 3")];
  [tableData addRow:$data(@"Load More")];
  return tableData;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  MwfTableData * tableData = [self tableDataForTableView:tableView];
  DemoData * row = [tableData objectForRowAtIndexPath:indexPath];
  if ([@"Load More" isEqual:row.value]) {
    [self performUpdates:^(MwfTableData * data) {
      MwfDemoLoadingItem * loadingItem = [[MwfDemoLoadingItem alloc] init];
      if (!_withSection) {
        loadingItem.userInfo = @"Adding 5 new rows...";
      } else {
        loadingItem.userInfo = @"Adding new section...";
      }
      [data updateRow:loadingItem atIndexPath:indexPath];
    }];
    [self loadMoreInTheBackground];
  }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return ((DemoData *)[[self tableDataForTableView:tableView] objectForSectionAtIndex:section]).value;
}
- (void)loadMoreInTheBackground;
{
  __block MwfDemoTableViewController * weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [NSThread sleepForTimeInterval:1]; // simulate loading for 1 second
    if (!_withSection) {
      [weakSelf performUpdates:^(MwfTableData * data) {
        NSUInteger lastRowIndex = [data numberOfRows]-1;
        for (int i = 0; i < 5; i++) {
          NSString * rowValue = [NSString stringWithFormat:@"Row %d", lastRowIndex+1];
          [data insertRow:$data(rowValue) atIndex:lastRowIndex++];
        }
        [data updateRow:$data(@"Load More") atIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:0]];
      }];
    } else {
      [weakSelf performUpdates:^(MwfTableData * data) {
        NSUInteger nextSection = [data numberOfSections];
        [data removeRowAtIndexPath:[NSIndexPath indexPathForRow:[data numberOfRowsInSection:nextSection-1]-1 inSection:nextSection-1]];
        NSString * sectionTitle = [NSString stringWithFormat:@"Section %d", nextSection+1];
        [data addSection:$data(sectionTitle)];
        [data addRow:$data(@"Row 1") inSection:nextSection];
        [data addRow:$data(@"Row 2") inSection:nextSection];
        [data addRow:$data(@"Row 3") inSection:nextSection];
        [data addRow:$data(@"Load More") inSection:nextSection];
      }];
    }
  });
}
- (void)toggleInBackground;
{
  _withSection = !_withSection;
  self.title = (_withSection ? @"With Section(s)" : @"No Section");
  
  __block MwfDemoTableViewController * weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    [NSThread sleepForTimeInterval:1]; // simulate loading for 1 second
    [self setLoading:NO];
    
    MwfTableData * newTableData = nil;
    MwfTableData * newSearchResultsTableData = nil;
    
    if (!_withSection) {
      newTableData = [MwfTableData createTableData];
      newSearchResultsTableData = [MwfTableData createTableData];
    } else {
      newTableData = [MwfTableData createTableDataWithSections];
      [newTableData insertSection:$data(@"Section 1") atIndex:0];
      newSearchResultsTableData = [MwfTableData createTableDataWithSections];
    }
    [newTableData addRow:$data(@"Row 1")];
    [newTableData addRow:$data(@"Row 2")];
    [newTableData addRow:$data(@"Row 3")];
    [newTableData addRow:$data(@"Load More")];
    
    weakSelf.tableData = newTableData;
    weakSelf.searchResultsTableData = newSearchResultsTableData;
  });
}

- (void)toggle:(id)sender;
{
  [self setLoading:YES animated:YES];
  [self toggleInBackground];
}

#pragma mark - Cells
- (UITableViewCell *)tableView:(UITableView *)tv createCellForDemoData:(DemoData *)demoData;
{
  UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:@"DemoDataCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:@"DemoDataCell"];
  }
  return cell;
}
- (void)tableView:(UITableView*)tv configCell:(UITableViewCell *)cell forDemoData:(DemoData *)demoData;
{
  cell.textLabel.text = demoData.value;
}

- (void)tableView:(UITableView *)tableView configMwfDemoLoadingItemCell:(MwfDemoLoadingItemCell *)cell forUserInfo:(NSString *)userInfo;
{
  cell.detailTextLabel.text = userInfo;
}

#pragma mark - Search
- (MwfTableData *)createSearchResultsTableDataForSearchText:(NSString *)searchText scope:(NSString *)scope;
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchInBackground) object:nil];
  [self performUpdatesForSearchResults:^(MwfTableData * tableData) {
    id firstItem = nil;
    NSIndexPath * firstRowIp = [NSIndexPath indexPathForRow:0 inSection:0];
    @try {
      firstItem = [tableData objectForRowAtIndexPath:firstRowIp];
    }
    @catch (NSException *exception) {}
    if (!firstItem || ![firstItem isKindOfClass:[MwfDemoLoadingItem class]]) {
      if (_withSection) {
        [tableData insertSection:$data(@"") atIndex:0];
      }
      MwfDemoLoadingItem * loadingItem = [[MwfDemoLoadingItem alloc] init];
      [tableData insertRow:loadingItem atIndexPath:firstRowIp];
    }
  }];
  _searchText = searchText;
  [self performSelectorInBackground:@selector(searchInBackground:) withObject:searchText];
  return nil;
}
- (void)searchInBackground:(NSString *)searchText {
  // simulate long running search operation
  [NSThread sleepForTimeInterval:1];
  MwfTableData * results = nil;
  if (_withSection) results = [MwfTableData createTableDataWithSections];
  else results = [MwfTableData createTableData];
  
  NSUInteger numberOfSections = self.tableData.numberOfSections;
  for (int i = 0; i < numberOfSections; i++) {
    NSUInteger numberOfRows = [self.tableData numberOfRowsInSection:i];
    if (_withSection) [results insertSection:[self.tableData objectForSectionAtIndex:i] atIndex:i];
    for (int j = 0; j < numberOfRows; j++) {
      id item = [self.tableData objectForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
      if ([item isKindOfClass:[DemoData class]]) {
        DemoData * demoItem = (DemoData *)item;
        if ([[demoItem.value lowercaseString] hasPrefix:[searchText lowercaseString]]) {
          [results addRow:demoItem inSection:i];
        }
      }
    }
  }
  if (searchText == _searchText) {
    self.searchResultsTableData = results;
  }
}
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation MwfDemoLoadingItem
@synthesize loadingText = _loadingText;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation MwfDemoLoadingItemCell
@synthesize activityIndicatorView = _activityIndicatorView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.accessoryView = _activityIndicatorView;
  }
  return self;
}
- (void)setItem:(MwfDemoLoadingItem *)item;
{
  [super setItem:item];
  if (item.loadingText) self.textLabel.text = item.loadingText;
  else self.textLabel.text = @"Loading...";
  [_activityIndicatorView startAnimating];
}
@end
