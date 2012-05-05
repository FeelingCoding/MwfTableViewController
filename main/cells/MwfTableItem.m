//
//  MwfTableItem.m
//  MwfTableViewController
//
//  Created by Meiwin Fu on 30/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import "MwfTableItem.h"

@implementation MwfTableItem
@synthesize cellClass = _cellClass;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize userInfo = _userInfo;

#pragma mark - Init
- (id)init {
  self = [super init];
  if (self) {
    
    // by convention, reuseIdentifier & cellClass = Item class name + 'Cell'
    _reuseIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"Cell"];
    _cellClass = NSClassFromString(_reuseIdentifier);
    
  }
  return self;
}
@end

@implementation MwfTableItemCell
@synthesize item = _item;
@end
