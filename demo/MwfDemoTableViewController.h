//
//  MwfDemoTableViewController.h
//  MwfTableViewController
//
//  Created by Meiwin Fu on 23/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewController+Cells.h"
#import "MwfTableViewController.h"

@interface MwfDemoTableViewController : MwfTableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
  BOOL _withSection;
  NSString * _searchText;
}
@end

@interface MwfDemoLoadingItem : MwfTableItem
@property (nonatomic,retain) NSString * loadingText;
@end

@interface MwfDemoLoadingItemCell : MwfTableItemCell
@property (nonatomic,retain) UIActivityIndicatorView * activityIndicatorView;
@end