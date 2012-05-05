#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "MwfTableViewController.h"
#import "MwfTableItem.h"

@interface Spec : NSObject

@end

@interface SpecTableItem : MwfTableItem
@end


@interface SpecTableItemCell : MwfTableItemCell
@end

@interface SpecTableViewController : MwfTableViewController
@property (nonatomic) NSUInteger createCellForNSObject;
@property (nonatomic) NSUInteger configCellForNSObject;
@property (nonatomic) NSUInteger configCellForSpec;
- (UITableViewCell *)tableView:(UITableView *)tableView createCellForNSObject:(NSObject *)obj;
- (void)tableView:(UITableView*)tableView configCell:(UITableViewCell *)cell forNSObject:(NSObject *)item;
@end