# MwfTableViewController

Extension to UITableViewController in attempt to provide additional features that are reusable in most scenarios.

## Features

### Show Loading

*Configure the loading style, currently support header and footer.*

  ```objective-c
  - (void)viewDidLoad
  {
    [super viewDidLoad];
    theTableViewController.loadingStyle = MwfTableViewLoadingStyleFooter; // default is MwfTableViewLoadingStyleHeader
  }
  ```

*Programmatically trigger loading animation*

  ```objective-c
  [theTableViewController setLoading:YES animated:YES];
  ```
  
*Programmatically stop loading animation*
    
  ```objective-c
  [theTableViewController setLoading:YES animated:NO];
  ```
  
If you need to, you can override few methods to provide custom look and feel for your app.

  ```objective-c
  - (UIView *)createLoadingView
  {
    // ... construct your custom loading view
    return yourAwesomeCustomLoadingView;
  }
  
  - (void)willShowLoadingView:(UIView *)loadingView
  {
    // cast to your implementation
    YourAwesomeLoadingView * view = (YourAwesomeLoadingView *)loadingView;
    // ... do something about it, e.g. start animating the activity indicator view
  }
  
  - (void)didHideLoadingView:(UIView *)loadingView
  {
    // cast to your implementation
    YourAwesomeLoadingView * view = (YourAwesomeLoadingView *)loadingView;
    // ... do something about it, e.g. stop animating the activity indicator view
  }
  ```  

### Table Data

A class `MwfTableData` is provided to manage your table backing store.
Instead of using `NSArray`, this class provides all the convenience you need working with table view.

*Creating Table Data*

* `+ (MwfTableData *) createTableData;`
* `+ (MwfTableData *) createTableDataWithSections;`

*Accessing data*

* `- (NSUInteger) numberOfSections;`
* `- (NSUInteger) numberOfRowsInSection:(NSUInteger)section;`
* `- (NSUInteger) numberOfRows;`
* `- (id) objectForSectionAtIndex:(NSUInteger)section;`
* `- (id) objectForRowAtIndexPath:(NSIndexPath *)ip;`
* `- (NSIndexPath *) indexPathForRow:(id)object;`
* `- (NSUInteger) indexForSection:(id)sectionObject;`

*Inserting data*

* `- (NSUInteger)addSection:(id)sectionObject;`
* `- (NSUInteger)insertSection:(id)sectionObject atIndex:(NSUInteger)sectionIndex;`
* `- (NSIndexPath *)addRow:(id)object inSection:(NSUInteger)sectionIndex;`
* `- (NSIndexPath *)insertRow:(id)object atIndexPath:(NSIndexPath *)indexPath;`
* `- (NSIndexPath *)addRow:(id)object;`
* `- (NSIndexPath *)insertRow:(id)object atIndex:(NSUInteger)index;`

*Deleting data*

* `- (NSIndexPath *)removeRowAtIndexPath:(NSIndexPath *)indexPath;`
* `- (NSUInteger)removeSectionAtIndex:(NSUInteger)sectionIndex;`

*Updating data*

* `- (NSUInteger)updateSection:(id)object atIndex:(NSUInteger)section;`
* `- (NSIndexPath *)updateRow:(id)object atIndexPath:(NSIndexPath *)indexPath;`

### Using `MwfTableData` in MwfTableViewController subclasses

*Override `createAndInitTableData`*

In this method, you can create `MwfTableData` instance using one of the creation methods (with or without section) and initialize with some data.

   ```objective-c
   - (MwfTableData *)createAndInitTableData;
   {
     MwfTableData * tableData = [MwfTableData createTableData];
     [tableData addRow:@"Row 1"];
     [tableData addRow:@"Row 2"];
     [tableData addRow:@"Row 3"];
     [tableData addRow:@"Load More"];
     return tableData;
   }
   ```

*Performing bulk updates*

`MwfTableViewController` provides method `performUpdates:(void(^)(MwfTableData *))updatesBlock` which you can call to perform bulk updates to your table view (add,remove,update sections/rows). This method will update the backing store as well as updating the table view (using `UITableViewRowAnimationAutomatic` for row animation). This method frees you from tracking the changed index sets and paths, and lets you focus on the application logic that updates your table.

  ```objective-c
  - (void)loadMoreData {
     
     [self performUpdates:^(MwfTableData * data) {
     
        // ... call the insert/delete/update method of MwfTableData
        
     }];
  }
  ```
  
*Reload table view*

Setting table data via `tableData` property of `MwfTableViewController` will trigger tableView's `reloadData`.

   ```objective-c
   - (void)reloadEntireTable { // a method in your MwfTableViewController subclass
   
      MwfTableData * tableData = [MwfTableData createTableDataWithSections];
      [tableData addSection:@"Section 1"];
      [tableData addRow:@"Row 1" inSection:0];
      [tableData addRow:@"Row 2" inSection:0];
      self.tableData = tableData;
   }
   ```

### Creating and configuring table view cell

This feature aims to simplify the implementation of `tableView:cellForRowAtIndexPath:` method.
If you have implemented table view with mix of multiple table view cell types, you will probably have a fat implementation of the `tableView:cellForRowAtIndexPath:` method.

   ```objective-c
   - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)ip;
   {
      UITableViewCell * cell = nil;
      
      id dataObject = ...; // get data object from backing store
      
      NSString * reuseIdentifier = @"DefaultCell"; // default
      Class      cellClass       = [UITableViewCell class]; // default

      if ([dataObject isKindOf:[DataType1 class]]) {
        reuseIdentifier = @"DataType1Cell";
        cellClass = [DataType1Cell class];
      }
      else if ([dataObject isKindOf:[DataType2 class]]) {
        reuseIdentifier = @"DataType2Cell";
        cellClass = [DataType2Cell class];
      }
      ... // and so on
      
      cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
      if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
      }
      
      // configure cell
      if ([dataObject isKindOf:[DataType1 class]]) {
        DataType1Cell * theCell = (DataType1Cell *)cell;
        // configure using dataObject
      }
      else if ([dataObject isKindOf:[DataType2 class]]) {
        DataType2Cell * theCell = (DataType2Cell *)cell;
        // configure using dataObject
      }
      
      return cell;
   }
   ```

The above example shows how bad it can become when the types of cell to display grow. It can become big nightmare to maintain.

Hence, `MwfTableViewController` implemented a method `tableView:cellForObject:` trying to improve the big-fat-messy `tableView:cellForRowAtIndexPath:` method you may have.
By default, `MwfTableViewController` implements `tableView:cellForRowAtIndexPath:` by calling `MwfTableData` and the method.

   ```objective-c
   - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
   {
     id rowItem = [self.tableData objectForRowAtIndexPath:indexPath];

     UITableViewCell * cell = [self tableView:tableView cellForObject:rowItem];
  
     // to prevent app crashing when returning nil
     if (!cell) {
       cell = [self.tableView dequeueReusableCellWithIdentifier:@"NilCell"];
       if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NilCell"];
     }
     
     return cell;
   }
   ```
   
If you don't like the default implementation (because you are not using `MwfTableData`), you can override the method in your `MwfTableViewController` subclass to suit your need, by still utilizing `tableView:cellForObject:` method.

So, how does `tableView:cellForObject:` work? In short, the design embraces coding-by-convention. It calls creation and configuration methods based on the name of the row data type.
Example: assuming you have your row data type `Tweet` and `Comment`, it will attempt to call the following methods for you:
* `- (UITableViewCell *)tableView:(UITableView *)tableView createCellForTweet:(Tweet *)tweet` // assume it returns TweetCell instance
* `- (UITableViewCell *)tableView:(UITableView *)tableView createCellForComment:(Comment *)tweet` // assume it returns CommentCell instance
* `- (UITableViewCell *)tableView:(UITableView *)tableView configCell:(TweetCell *)cell forTweet:(Tweet *)tweet`
* `- (UITableViewCell *)tableView:(UITableView *)tableView configCell:(CommentCell *)cell forTweet:(Comment *)comment`

If those methods are not implemented, they will be skipped.

Note: if you want to further simplify your code by not writing those methods at all... Read on!

### Table Item

`MwfTableItem` is a super simple class to represent a model for your row cell. It has 3 properties, i.e. `cellClass`, `reuseIdentifier` and `userInfo`.
* `cellClass`, by convention it will return the item class name with suffix `Cell`. e.g. `MwfTableItem` and `MwfTableItemCell`, `Tweet` and `TweetCell`.
* `reuseIdentifier`, by convention it will return the `cellClass` name.
* `userInfo`, default to `nil`. You can literally set anything to it (which you can use to further configure the cell).

Benefits of using this:
* Reusable, you can build a catalog of table items and cells that you can reuse whenever you need it.
* When using with `MwfTableViewController`'s `tableView:cellForObject:` (explained in previous section), you eliminate the need to implement the creation and configuration methods. 
* When using with `MwfTableViewController`'s `tableView:cellForObject:` and `userInfo` is set, you can implement `tableView:config<CellClassName>:forUserInfo:` method to configure the cell using data in `userInfo`.

Example:

   ```objective-c
   // from demo project
   @interface MwfDemoLoadingItem : MwfTableItem
   @property (nonatomic,retain) NSString * loadingText;
   @end

   @interface MwfDemoLoadingItemCell : MwfTableItemCell
   @property (nonatomic,retain) UIActivityIndicatorView * activityIndicatorView;
   @end   
   
   // the implementation
   @implementation MwfDemoLoadingItem
   @synthesize loadingText = _loadingText;
   @end
   
   @implementation MwfDemoLoadingItemCell
   @synthesize activityIndicatorView = _activityIndicatorView;
   - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
   {
     self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
     if (self) {
       _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
       self.accessoryView = _activityIndicatorView;
     }
     return self;
   }
   - (void)setItem:(MwfDemoLoadingItem *)item;
   {
     [super setItem:item];
     if (item.loadingText) self.textLabel.text = item.loadingText;
     else self.textLabel.text = @"Loading...";
     [_activityIndicatorView startAnimating];
   }
   @end
   ```
   
Example when using with `tableView:cellForObject:` and `userInfo` is set.

   ```objective-c
   // from demo project
   // The following method will be automatically invoked if userInfo is set.
   - (void)tableView:(UITableView *)tableView configMwfDemoLoadingItemCell:(MwfDemoLoadingItemCell *)cell forUserInfo:(NSString *)userInfo; // I know the userInfo is always NSString
   {
     cell.detailTextLabel.text = userInfo;
   } 
   
   ```   
      
### Search

Search is a very common function that comes together with table view. For that, `MwfTableViewController` provides some basic functionalities to easily implement search for your table view.

*Enable search for your table view controller*

To enable search, just set `wantSearch` to YES. Additionally, implement `createAndInitSearchResultsTableData` to customize initial data for your search results.

  ```objective-c
  - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
  {
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
       self.wantSearch = YES;
     }
     return self;
  }
  
  - (MwfTableData *)createAndInitSearchResultsTableData {
    MwfTableData * td = ...; // create and perhaps initialize with some rows
    return td;
  }
  ```

*Handle search query*

When user types on the search bar or select search option, `- (MwfTableData *)createSearchResultsTableDataForSearchText:(NSString *)searchText scope:(NSString *)scope;` will be invoked. You should implement this method to populate an instance of `MwfTableData` that contains results of the search. By default, the invocation of this method is delayed by `0.4 second`. You can change this value by setting `searchDelayInSeconds` property.

If you wish you perform search in background, you should return `nil` from this method and dispatch the search to the background. Once search results are available, simply set `searchResultsTableData` to display them.

*Bonus*

Similar to `tableData`, `searchResultsTableData` also comes with equivalence update method `performUpdatesForSearchResults:(void(^)(MwfTableData *))updateBlock`.
      
*Attention*

When `wantSearch` is `YES`. Responding to `UITableViewController` delegate or dataSource callbacks requires special attention. You should not call `tableData` or `searchResultsTableData` directly to avoid mistake in using the incorrect table data. Instead, a method `- (MwfTableData *) tableDataForTableView:(UITableView *)tableView;` is available for you to use to use the correct table data for specified tableView. The implementation of this method is very simple actually:

  ```objective-c
  - (MwfTableData *)tableDataForTableView:(UITableView *)tableView;
  {
    if (tableView == self.tableView) return _tableData;
    return _searchResultsTableData;
  }
  ```
  
  If you remember this, it will save you tons of debugging time that could sometimes really hard to solve.
      
## Licensing

MwfTableViewController is licensed under MIT License
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

