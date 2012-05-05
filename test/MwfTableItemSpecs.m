#import "SpecHelper.h"

SpecBegin(MwfTableItem)

it(@"tests MwfTableItem's reuseIdentifier and cellClass", ^{

  MwfTableItem * tableItem = [[MwfTableItem alloc] init];
  expect(tableItem.reuseIdentifier).toEqual(@"MwfTableItemCell");
  expect(tableItem.cellClass).toEqual([MwfTableItemCell class]);
  expect(tableItem.userInfo).toBeNil();

});

it(@"tests MwfTableItem's subclass reuseIdentifier and cellClass", ^{
  
  SpecTableItem * tableItem = [[SpecTableItem alloc] init];
  expect(tableItem.reuseIdentifier).toEqual(@"SpecTableItemCell");
  expect(tableItem.cellClass).toEqual([SpecTableItemCell class]);
  
});

SpecEnd