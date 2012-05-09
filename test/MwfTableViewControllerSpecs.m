#import "SpecHelper.h"
#import "MwfTableItem.h"
#import <objc/runtime.h>

#define $ip(_section,_row) [NSIndexPath indexPathForRow:(_row) inSection:(_section)]

SpecBegin(MwfTableViewController)

__block MwfTableViewController * controller = nil;
__block id                       mockController = nil;

context(@"loading features", ^{

  beforeEach(^{
    controller = [[MwfTableViewController alloc] initWithNibName:nil bundle:nil];
    mockController = [OCMockObject partialMockForObject:controller];
  });

  it(@"creates internal views", ^{

    expect(controller.view).Not.toBeNil();
    expect(controller.loadingStyle).toEqual(MwfTableViewLoadingStyleHeader);
    expect(controller.loading).toEqual(NO);
    expect(controller.loadingView).Not.toBeNil();
    expect(controller.tableHeaderTopView).Not.toBeNil();
    
  });
  
  it(@"calling method for custom view overrides", ^{
    
    [[mockController expect] createLoadingView];
    [[mockController expect] createTableHeaderTopView];
    __attribute__((__unused__)) UIView * view = controller.view;
    [mockController verify];
    
  });
  
  it(@"loading header", ^{
  
    controller.loadingStyle = MwfTableViewLoadingStyleHeader;
    
    [[mockController expect] willShowLoadingView:[OCMArg any]];
    [controller setLoading:YES];
    expect(controller.loading).toEqual(YES);
    [[mockController expect] didHideLoadingView:[OCMArg any]];
    [controller setLoading:NO];
    expect(controller.loading).toEqual(NO);
    [mockController verify];
    
  });
  
  it(@"loading footer", ^{
    
    controller.loadingStyle = MwfTableViewLoadingStyleFooter;

    [[mockController expect] willShowLoadingView:[OCMArg any]];
    [controller setLoading:YES];
    expect(controller.loading).toEqual(YES);
    [[mockController expect] didHideLoadingView:[OCMArg any]];
    [controller setLoading:NO];
    expect(controller.loading).toEqual(NO);
    [mockController verify];
    
  });
  
});

it(@"tests tableView:cellForRowAtIndexPath:", ^{
  
  SpecTableViewController * controller = [[SpecTableViewController alloc] initWithNibName:nil bundle:nil];
  
  UITableView * tableView = controller.tableView;

  [controller.tableData addRow:[[MwfTableItem alloc] init]];
  [controller.tableData addRow:[[NSObject alloc] init]];
  SpecTableItem * specItem = [[SpecTableItem alloc] init];
  [controller.tableData addRow:specItem];
  SpecTableItem * specItem2 = [[SpecTableItem alloc] init];
  specItem2.userInfo = [[Spec alloc] init];
  [controller.tableData addRow:specItem2];
  
  Spec * spec1 = [[Spec alloc] init];
  Spec2 * spec2 = [[Spec2 alloc] init];
  Spec3 * spec3 = [[Spec3 alloc] init];
  [controller.tableData addRow:spec1];
  [controller.tableData addRow:spec2];
  [controller.tableData addRow:spec3];

  expect([[controller tableView:tableView cellForRowAtIndexPath:$ip(0,0)] class]).toEqual([MwfTableItemCell class]);
  
  expect([[controller tableView:tableView cellForRowAtIndexPath:$ip(0,1)] class]).toEqual([UITableViewCell class]);
  
  UITableViewCell* specCell = [controller tableView:tableView cellForRowAtIndexPath:$ip(0,2)];
  expect([specCell class]).toEqual([SpecTableItemCell class]);
  expect(((MwfTableItemCell *)specCell).item).Not.toBeNil();
  expect(((MwfTableItemCell *)specCell).item).toEqual(specItem);

  UITableViewCell* specCell2 = [controller tableView:tableView cellForRowAtIndexPath:$ip(0,3)];
  expect([specCell class]).toEqual([SpecTableItemCell class]);
  expect(((MwfTableItemCell *)specCell2).item).Not.toBeNil();
  expect(((MwfTableItemCell *)specCell2).item).toEqual(specItem2);
  
  expect([controller tableView:tableView cellForRowAtIndexPath:$ip(0,4)].reuseIdentifier).toEqual(@"SpecCell");
  expect([controller tableView:tableView cellForRowAtIndexPath:$ip(0,5)].reuseIdentifier).toEqual(@"Spec2Cell");
  expect([controller tableView:tableView cellForRowAtIndexPath:$ip(0,6)].reuseIdentifier).toEqual(@"SpecCell");
  
  expect(controller.createCellForNSObject).toEqual(1);
  expect(controller.configCellForNSObject).toEqual(4);
  expect(controller.configCellForSpec).toEqual(1);
  expect(controller.createCellForSpec).toEqual(2);
  expect(controller.createCellForSpec2).toEqual(1);
  
});

SpecEnd