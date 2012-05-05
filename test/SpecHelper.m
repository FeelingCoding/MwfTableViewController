#import "SpecHelper.h"

@implementation Spec
@end

@implementation SpecTableItem
@end

@implementation SpecTableItemCell
@end

@implementation SpecTableViewController
@synthesize createCellForNSObject = _createCellForNSObject;
@synthesize configCellForNSObject = _configCellForNSObject;
@synthesize configCellForSpec = _configCellForSpec;

#pragma mark - Table View Cell
- (UITableViewCell *)tableView:(UITableView *)tableView createCellForNSObject:(NSObject *)item;
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
@end