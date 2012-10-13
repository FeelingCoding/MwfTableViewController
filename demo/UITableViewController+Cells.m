//
//  UITableViewController+Cells.m
//  MwfTableViewController
//
//  Created by Meiwin Fu on 13/10/12.
//
//

#import "UITableViewController+Cells.h"
#import "MwfTableViewController.h"

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
@implementation UITableViewController (Cells)

#pragma mark - Cells
//- $cellFor(DemoData)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForDemoDataAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DemoDataCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"DemoDataCell"];
    }
    return cell;
}

//- $configCell(DemoData,UITableViewCell);
- (void)tableView:(UITableView *)tableView configCell:(UITableViewCell *)cell forDemoData:(DemoData *)item
{
    cell.textLabel.text = item.value;
}

// -$configCellWithUserInfo(MwfDemoLoadingItem,MwfDemoLoadingItemCell,NSString);
- (void)tableView:(UITableView *)tableView configCell:(UITableViewCell *)cell forDemoDataUserInfo:(NSString *)userInfo
{
    cell.detailTextLabel.text = userInfo;
}

@end
