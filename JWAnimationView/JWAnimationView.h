//
//  AnimationView.h
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/15.
//  Copyright © 2017年 UL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCollectionLayoutItem.h"

@interface JWAnimationView : UIView

//对应于collecitonView布局layout
@property (nonatomic, strong) JWCollectionLayoutItem *item;

//设置选中的index（tab）
@property (nonatomic, assign) NSInteger selectedIndex;

//下划线的宽度
@property (nonatomic, assign) NSInteger itemWidth;

//markAngelIndex < 0 表示没有三角
@property (nonatomic, assign) NSInteger markAngelIndex;//三角所在区域

//三角形的角度
@property (nonatomic, assign) CGFloat   angle;

- (instancetype)initWithLayoutItem:(JWCollectionLayoutItem *)item;

//所有属性赋值之后，需要重新刷新布局
- (void)prepareAnimation;

/**
 从一个index 移动到另一个index移动的百分比

 @param index fromIndex
 @param toIndex toIndex
 @param progress（0-1）
 */
- (void)fromIndex:(NSInteger)index toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

/**
 从一个index 移动到另一个toIndex 需要多久时间duration。
 由于动画运动需要一定时间duration，从一个tab移动到另一个tab期间，
 如果修改了selectedIndex，或者调用了fromIndex:toIndex:progress:。动画立即终止

 @param index fromIndex
 @param toIndex toIndex
 @param duration 持续时间
 */
- (void)fromIndex:(NSInteger)index toIndex:(NSInteger)toIndex duration:(CGFloat)duration;

/**
 选择selectedIndex（tab）是否（animation）要显示动画移动过程

 @param selectedIndex 选择的selectedIndex
 @param animation 是否显示（动画）过度效果
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation;

//由于fromIndex:toIndex:duration: 内部通过timer定时器实现，所以在动画执行的过程不会被释放。动画执行完才开始释放
//调用clear 可以强制释放
- (void)clear;
@end
