//
//  MwfTableItem.h
//  MwfTableViewController
//
//  Created by Meiwin Fu on 30/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MwfTableItem : NSObject
@property (nonatomic,readonly) Class      cellClass;
@property (nonatomic,readonly) NSString * reuseIdentifier;
@property (nonatomic,retain)   id         userInfo;
@end

@interface MwfTableItemCell : UITableViewCell
@property (nonatomic,retain) MwfTableItem * item;
@end