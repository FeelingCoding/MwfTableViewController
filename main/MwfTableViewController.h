//
//  MwfTableViewController.h
//  MwfTableViewController
//
//  Created by Meiwin Fu on 23/4/12.
//  Copyright (c) 2012 –MwF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MwfTableItem.h"

#pragma mark - MwfTableData
#define mwf_ip NSIndexPath*
#define mwf_indexSet(_idx_) [NSIndexSet indexSetWithIndex:(_idx_)]

@interface MwfTableDataUpdates : NSObject
@property (nonatomic,readonly) NSIndexSet * reloadSections;
@property (nonatomic,readonly) NSIndexSet * deleteSections;
@property (nonatomic,readonly) NSIndexSet * insertSections;
@property (nonatomic,readonly) NSArray    * reloadRows;
@property (nonatomic,readonly) NSArray    * deleteRows;
@property (nonatomic,readonly) NSArray    * insertRows;
@end

@interface MwfTableData : NSObject {
  NSMutableArray * _sectionArray;
  NSMutableArray * _dataArray;
}
// Creating instance
+ (MwfTableData *) createTableData;
+ (MwfTableData *) createTableDataWithSections;

// Accessing data
- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection:(NSUInteger)section;
- (NSUInteger) numberOfRows;
- (id) objectForSectionAtIndex:(NSUInteger)section;
- (id) objectForRowAtIndexPath:(mwf_ip)ip;
- (mwf_ip) indexPathForRow:(id)object;
- (NSUInteger) indexForSection:(id)sectionObject;

// Inserting data
- (NSUInteger)addSection:(id)sectionObject;
- (NSUInteger)insertSection:(id)sectionObject atIndex:(NSUInteger)sectionIndex;
- (mwf_ip)addRow:(id)object inSection:(NSUInteger)sectionIndex;
- (mwf_ip)insertRow:(id)object atIndexPath:(mwf_ip)indexPath;
- (mwf_ip)addRow:(id)object;
- (mwf_ip)insertRow:(id)object atIndex:(NSUInteger)index;

// Deleting data
- (mwf_ip)removeRowAtIndexPath:(mwf_ip)indexPath;
- (NSUInteger)removeSectionAtIndex:(NSUInteger)sectionIndex;

// Update data
- (NSUInteger)updateSection:(id)object atIndex:(NSUInteger)section;
- (mwf_ip)updateRow:(id)object atIndexPath:(mwf_ip)indexPath;

// Bulk Updates
- (MwfTableDataUpdates *)performUpdates:(void(^)(MwfTableData *))updates;

@end

#pragma mark - MwfTableViewController
typedef enum {
  MwfTableViewLoadingStyleHeader = 0, // default
  MwfTableViewLoadingStyleFooter
} MwfTableViewLoadingStyle;

@interface MwfTableViewController : UITableViewController <UISearchDisplayDelegate,UISearchBarDelegate> {
  UIView * _emptyTableFooterBottomView;

  // for table cells
  id                    _implementationTarget;
  Class                 _implementationTargetClass;
  NSMutableDictionary * _createImplementationCache;
  NSMutableDictionary * _createSelectorCache;
  NSMutableDictionary * _configImplementationCache;
  NSMutableDictionary * _configSelectorCache;
  
  // for search
  // http://stackoverflow.com/questions/7679501/uiviewcontroller-does-not-retain-its-programmatically-created-uisearchdisplaycon
  UISearchDisplayController * __searchDisplayController;
  NSMutableDictionary       * _previousSearchCriteria;
}
@property (nonatomic) MwfTableViewLoadingStyle       loadingStyle;
@property (nonatomic) BOOL                           loading;
@property (nonatomic,readonly) UIView              * tableHeaderTopView;
@property (nonatomic,readonly) UIView              * loadingView;
@property (nonatomic,retain)   MwfTableData        * tableData;
@property (nonatomic,retain)   MwfTableData        * searchResultsTableData;
@property (nonatomic)          BOOL                  wantSearch;
@property (nonatomic)          CGFloat               searchDelayInSeconds;

- (void)setLoading:(BOOL)loading animated:(BOOL)animated;
@end

@interface MwfTableViewController (OverrideForCustomView)
- (UIView *)createTableHeaderTopView;
- (UIView *)createLoadingView;
- (void)willShowLoadingView:(UIView *)loadingView;
- (void)didHideLoadingView:(UIView *)loadingView;
@end

@interface MwfTableViewController (TableData)
- (MwfTableData *) createAndInitTableData;
- (void)performUpdates:(void(^)(MwfTableData *))updates;
- (MwfTableData *) tableDataForTableView:(UITableView *)tableView;
@end

@interface MwfTableViewController (TableViewCell)
- (UITableViewCell *) tableView:(UITableView *)tableView 
                  cellForObject:(id)rowItem
                    atIndexPath:(NSIndexPath *)ip; 
@end

@interface MwfTableViewController (Search)
- (void)setWantSearch:(BOOL)wantSearch;
- (MwfTableData *)createAndInitSearchResultsTableData;
- (void)performUpdatesForSearchResults:(void(^)(MwfTableData *))updates;
- (MwfTableData *)createSearchResultsTableDataForSearchText:(NSString *)searchText scope:(NSString *)scope;
@end

@interface MwfDefaultTableLoadingView : UIView
@property (nonatomic,readonly) UILabel * textLabel;
@property (nonatomic,readonly) UIActivityIndicatorView * activityIndicatorView;
+ (MwfDefaultTableLoadingView *)create;
@end

#define mwf_cellFor(_klass) \
  (UITableViewCell*)tableView:(UITableView*)tableView cellFor##_klass##AtIndexPath:(NSIndexPath*)indexPath
#define mwf_configCell(_klass,_cellClass) \
  (void)tableView:(UITableView*)tableView configCell:(_cellClass *)cell for##_klass:(_klass *)item
#define mwf_configCellWithUserInfo(_klass,_cellClass,_userInfoClass) \
  (void)tableView:(UITableView*)tableView configCell:(_cellClass *)cell for##_klass##UserInfo:(_userInfoClass *)userInfo

#ifdef CK_SHORTHAND
#define $indexSet(_idx_)                                          mwf_indexSet(_idx_)
#define $cellFor(_klass)                                          mwf_cellFor(_klass)
#define $configCell(_klass,_cellClass)                            mwf_configCell(_klass, _cellClass)
#define $configCellWithUserInfo(_klass,_cellClass,_userInfoClass) mwf_configCellWithUserInfo(_klass, _cellClass, _userInfoClass)
#endif
