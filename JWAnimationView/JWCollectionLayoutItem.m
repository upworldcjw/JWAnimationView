//
//  CollectionLayoutDataItem.m
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/15.
//  Copyright © 2017年 UL. All rights reserved.
//

#import "JWCollectionLayoutItem.h"

@implementation JWCollectionLayoutItem

- (instancetype)init{
  if (self = [super init]) {
    
  }
  return self;
}

- (CGFloat)properWidth{
  return [JWCollectionLayoutItem totoalWidthForItem:self];
}

+ (CGFloat)totoalWidthForItem:(JWCollectionLayoutItem *)item{
  __block CGFloat width = item.leftMargin + item.rightMargin;
  
  [item.itemWidths enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    width += obj.integerValue + item.itemSapce;
  }];
  if (item.itemWidths.count > 0) {
    width -= item.itemSapce;
  }
  return width;
}

@end
