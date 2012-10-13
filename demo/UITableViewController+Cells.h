//
//  UITableViewController+Cells.h
//  MwfTableViewController
//
//  Created by Meiwin Fu on 13/10/12.
//
//

#import <UIKit/UIKit.h>

@interface DemoData : NSObject
@property (nonatomic,retain) NSString * value;
- (id)initWithValue:(NSString *)value;
@end

@interface UITableViewController (Cells)

@end
