//
//  ScrollTabBarCell.m
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/15.
//  Copyright © 2017年 UL. All rights reserved.
//

#import "ScrollTabBarCell.h"

@interface ScrollTabBarCell ()

@end

@implementation ScrollTabBarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
  self.lineView = [UIView new];
  self.lineView.frame =CGRectMake(0, 0, 20, 4);
  [self.contentView addSubview:self.lineView];
  self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
  [super layoutSubviews];
  CGPoint center = CGPointMake(self.frame.size.width/2.0, 10);
  self.lineView.center = center;
}

@end
