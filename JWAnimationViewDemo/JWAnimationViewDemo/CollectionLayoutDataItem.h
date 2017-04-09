//
//  CollectionLayoutDataItem.h
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/15.
//  Copyright © 2017年 UL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;
@interface CollectionLayoutDataItem : NSObject

@property (nonatomic, strong) NSMutableArray *itemWidths; //每个对象的实际宽度
@property (nonatomic, assign) CGFloat leftMargin;         //左间距
@property (nonatomic, assign) CGFloat rightMargin;       //由间距
@property (nonatomic, assign) CGFloat itemSapce;          //每个对象之间的间距

- (CGFloat)properWidth;

@end
