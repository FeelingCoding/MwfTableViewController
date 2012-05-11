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
-$cellFor(NSObject)
{
  _createCellForNSObject++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSObjectCell"];
}

-$configCell(NSObject,UITableViewCell)
{
  _configCellForNSObject++;
}

-$configCellWithUserInfo(SpecTableItem,SpecTableItemCell,Spec)
{
  _configCellForSpec++;
}

-$cellFor(Spec)
{
  _createCellForSpec++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpecCell"];
}

-$cellFor(Spec2)
{
  _createCellForSpec2++;
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Spec2Cell"];
}
@end