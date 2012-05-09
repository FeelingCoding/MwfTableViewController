#import "SpecHelper.h"

@implementation Spec
@end

@implementation Spec2
@synthesize val1 = _val1;
@synthesize val2 = _val2;
@end

@implementation Spec3
@end

@implementation SpecTableItem
@end

@implementation SpecTableItemCell
@end

@implementation SpecTableViewController
@synthesize createCellForNSObject = _createCellForNSObject;
@synthesize configCellForNSObject = _configCellForNSObject;
@synthesize configCellForSpec = _configCellForSpec;
@synthesize createCellForSpec = _createCellForSpec;
@synthesize createCellForSpec2 = _createCellForSpec2;

#pragma mark - Table View Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNSObjectAtIndexPath:(NSIndexPath *)ip
{
  NSLog(@"!");
  _createCellForNSObject++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSObjectCell"];
}

- (void)tableView:(UITableView *)tableView configCell:(UITableViewCell *)cell forNSObject:(NSObject *)item;
{
  _configCellForNSObject++;
  NSLog(@"!");
}

- (void)tableView:(UITableView *)tableView configSpecTableItemCell:(SpecTableItemCell *)cell forUserInfo:(Spec *)item;
{
  _configCellForSpec++;
  NSLog(@"!");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSpecAtIndexPath:(NSIndexPath *)ip;
{
  _createCellForSpec++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpecCell"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSpec2AtIndexPath:(NSIndexPath *)ip;
{
  _createCellForSpec2++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spec2Cell"];
}
@end