#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "MwfTableViewController.h"
#import "MwfTableItem.h"

@interface Spec : NSObject

@end

@interface Spec2 : NSObject
@property (nonatomic,retain) NSString * val1;
@end

@interface Spec2 ()
@property (nonatomic,retain) NSString * val2;
@end

@interface Spec3 : Spec
@end

@interface SpecTableItem : MwfTableItem
@end


@interface SpecTableItemCell : MwfTableItemCell
@end

@interface SpecTableViewController : MwfTableViewController
@property (nonatomic) NSUInteger createCellForNSObject;
@property (nonatomic) NSUInteger configCellForNSObject;
@property (nonatomic) NSUInteger configCellForSpec;
@property (nonatomic) NSUInteger createCellForSpec;
@property (nonatomic) NSUInteger createCellForSpec2;
@end