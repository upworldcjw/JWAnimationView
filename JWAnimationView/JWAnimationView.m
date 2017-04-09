//
//  AnimationView.m
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/15.
//  Copyright © 2017年 UL. All rights reserved.
//

#import "JWAnimationView.h"

@interface AnimationProgressItem : NSObject

@property (nonatomic, assign) NSInteger index;//从0开始，对应indexPath
@property (nonatomic, assign) CGFloat   beginPointX;//开始坐标
@property (nonatomic, assign) CGFloat   progress;//全部区域为（0-1）

@end

@implementation AnimationProgressItem

@end

//存储动画执行的一些参数
typedef struct TimerRefreshAnimationItem{
    CGFloat duration;       //动画持续时间
    CGFloat fromPogress;    //动画开始值
    CGFloat toProgress;     //动画结束值
    CGFloat deltProgress;   //动画，开始和结束的差值
    CGFloat begintTimming;  //动画开始的timing
    BOOL    moveToRight;    //动画是向左还是向右移动
}IKTimerRefreshAnimationItem;

@interface JWAnimationView ()

@property(nonatomic, readwrite) CGLineCap cap;  //kCGLineCapRound
@property(nonatomic, readwrite) CGLineJoin join;//kCGLineJoinRound
@property(nonatomic, strong)    NSMutableArray<AnimationProgressItem *> *indexItems;
@property (nonatomic, assign)   CGFloat totalValiadWidth;//可以滑动的区域
@property (nonatomic, assign)   CGFloat curToProgress;//目前可见视图，移动的可见界面x起始坐标

@property(nonatomic, assign) IKTimerRefreshAnimationItem refreshItem;//存储动画的一些参数
//定时器
@property(nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation JWAnimationView

- (instancetype)initWithLayoutItem:(JWCollectionLayoutItem *)item{
    if (self = [super init]) {
        _cap = kCGLineCapRound;   //圆角
        _join = kCGLineJoinRound; //相交圆角
        _selectedIndex = 0; //选择的是第几个tab
        _curToProgress = 0; //停留位置
        _itemWidth = 20;    //横线及三角的宽度
        _markAngelIndex = 0;//第几个位置是热门
        _angle = M_PI/4.0;    //45度角 三角形的角度值
        _indexItems = [NSMutableArray array];
        _item = item;
    }
    return self;
}

//调用clear 可以强制释放
- (void)clear{
    [self animationDisable];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animation:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation{
    if (_selectedIndex < 0 || _selectedIndex > [self.indexItems count]) {
        return;
    }
    if (_selectedIndex != selectedIndex) {
        if (animation) {
            if (ABS(self.curToProgress - self.indexItems[selectedIndex].progress) < 0.01) {
                if (selectedIndex == self.markAngelIndex) {//防止尖角过度不自然
                    AnimationProgressItem *progressItem = self.indexItems[selectedIndex];
                    self.curToProgress = progressItem.progress;
                    [self setNeedsDisplay];
                }
            }else{
                [self fromIndex:_selectedIndex toIndex:selectedIndex duration:0.3];
            }
        }else{
            AnimationProgressItem *progressItem = self.indexItems[selectedIndex];
            self.curToProgress = progressItem.progress;
            [self setNeedsDisplay];
        }
        _selectedIndex = selectedIndex;
    }
}

//暂时不考虑只有一个元素的情况
- (void)prepareAnimation{
    [self.indexItems removeAllObjects];
    
    CGFloat properWidth = [self.item properWidth];
    CGFloat totolWidth = properWidth - self.item.leftMargin - self.item.rightMargin ;
    NSInteger count = self.item.itemWidths.count;
    if (self.item.itemWidths.count >= 2) {
        CGFloat firstItemMarginLeftWidth = ([self.item.itemWidths[0] floatValue] - self.itemWidth) / 2.0;
        CGFloat lastItemMarignRightWidth = ([self.item.itemWidths[count - 1] floatValue] - self.itemWidth) / 2.0 + self.itemWidth;
        self.totalValiadWidth = totolWidth - firstItemMarginLeftWidth - lastItemMarignRightWidth;
    }
    
    CGFloat curLeftX = self.item.leftMargin; //当前tab，x坐标
    CGFloat curItemWidth = [self.item.itemWidths[0] floatValue];//当前tab的宽度
    //第一个tab 直线的x开始坐标
    CGFloat const beginPointX = curLeftX + (curItemWidth - self.itemWidth) / 2.0;
    AnimationProgressItem *progressItem = [AnimationProgressItem new];
    progressItem.beginPointX = beginPointX;
    progressItem.progress = 0;
    progressItem.index = 0;
    [self.indexItems addObject:progressItem];
    
    for (NSInteger index = 1; index < count; index ++) {
        //修改leftX
        curLeftX += curItemWidth; //上一个tab 宽度
        curLeftX += self.item.itemSapce;//tab 间隔
        //当前tab 宽度
        curItemWidth = [self.item.itemWidths[index] floatValue];
        
        AnimationProgressItem *progressItem = [AnimationProgressItem new];
        CGFloat curBeginX = curLeftX + (curItemWidth - self.itemWidth) / 2.0;//beginPointx
        progressItem.beginPointX = curBeginX;
        progressItem.progress = (curBeginX - beginPointX)/self.totalValiadWidth;
        progressItem.index = index;
        [self.indexItems addObject:progressItem];
    }
    [self setNeedsDisplay];
}

//从一个index 移动到另一个index移动的百分比
- (void)fromIndex:(NSInteger)index
          toIndex:(NSInteger)toIndex
         progress:(CGFloat)progress{
    [self animationDisable];
    AnimationProgressItem *fromProgressItem = self.indexItems[index];
    AnimationProgressItem *toProgressItem = self.indexItems[toIndex];
    
    CGFloat deltProgress = toProgressItem.progress - fromProgressItem.progress;
    CGFloat realProgress = fromProgressItem.progress +  progress * deltProgress;
    [self setProgress:realProgress];
}

//从一个index 移动到另一个index 需要多久时间
- (void)fromIndex:(NSInteger)index
          toIndex:(NSInteger)toIndex
         duration:(CGFloat)duration{
    [self animationDisable];
//    NSInteger totalFrame = duration * fps;
//    CGFloat framePerProgress = deltProgress/totalFrame;
    
    AnimationProgressItem *fromProgressItem = self.indexItems[index];
    AnimationProgressItem *toProgressItem = self.indexItems[toIndex];
    CGFloat deltProgress = toProgressItem.progress - fromProgressItem.progress;
    BOOL moveToRight = toIndex > index;
    
    IKTimerRefreshAnimationItem refreshItem;
    refreshItem.fromPogress = fromProgressItem.progress;
    refreshItem.toProgress = toProgressItem.progress;
    refreshItem.moveToRight = moveToRight;
    refreshItem.begintTimming =  CACurrentMediaTime();
    refreshItem.deltProgress = deltProgress;
    refreshItem.duration = duration;
    self.refreshItem = refreshItem;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRefresh)];
    // 根据屏幕大小设置
//    NSInteger frameInterval = 1;
//    _displayLink.frameInterval = frameInterval;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkRefresh{
    NSTimeInterval endTimer = CACurrentMediaTime();
    CGFloat progress = self.refreshItem.fromPogress + self.refreshItem.deltProgress * ((endTimer - self.refreshItem.begintTimming)/ self.refreshItem.duration);
    //                            progress += framePerProgress;
    if (self.refreshItem.moveToRight && progress >= self.refreshItem.toProgress){//向右移动
        progress = self.refreshItem.toProgress;
        [self animationDisable];
    }else if (!self.refreshItem.moveToRight && progress <= self.refreshItem.toProgress){//向左移动
        progress = self.refreshItem.toProgress;
        [self animationDisable];
    }
    [self doRefreshProgress:progress];
}

- (void)animationDisable{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

//显示进度（0-1）
- (void)setProgress:(CGFloat)progress{
    [self animationDisable];
    [self doRefreshProgress:progress];
}

- (void)doRefreshProgress:(CGFloat)progress{
    if (_curToProgress != progress) {
        _curToProgress = progress;
        [self setNeedsDisplay];
    }
}

//如果item则需要重新计算
- (void)setItem:(JWCollectionLayoutItem *)item{
    _item = item;
    [self animationDisable];
    [self prepareAnimation];
}

//根据progress 选择对应的tag
- (AnimationProgressItem *)progressItemForProgress:(CGFloat)progress{
    AnimationProgressItem *item = nil;
    for (AnimationProgressItem *item in self.indexItems) {
        if(item.progress <= progress){
            break;
        }
    }
    return item;
}

//这个进度是总进度，从0到1，是可见视图的起点的进度
- (void)refreshForProgress:(CGFloat)progress
                   context:(CGContextRef)context{
    if (progress < 0) {
        progress = 0;
    }else if(progress > 1){
        progress = 1;
    }
    
    // Preserve the current drawing state
    CGContextSaveGState(context);
    
    CGFloat pointY = 5;
    CGFloat lineWidth = 3;
    
    CGFloat const itemWidthRatio = self.itemWidth/self.totalValiadWidth;
    
    if (self.markAngelIndex > 0 && self.markAngelIndex < [self.indexItems count]) {
        AnimationProgressItem *progressItem = self.indexItems[self.markAngelIndex];
        //考虑三角形绘制的两个临界值
        CGFloat thresholdBegin = progressItem.progress - itemWidthRatio;
        CGFloat thresholdEnd = progressItem.progress + itemWidthRatio;
        //  CGFloat thresholdLeftHalf = progressItem.progress - 1/2.0 * (self.itemWidth/self.totalValiadWidth);
        //  CGFloat thresholdHalf = progressItem.progress + 1/2.0 * (self.itemWidth/self.totalValiadWidth);
        if (progress >= thresholdBegin && progress <= thresholdEnd) {//如果在临界值区域
            if (progress <= progressItem.progress) {//画左半部分 => "-" => "-\" => "-\/" => "\/"
                AnimationProgressItem *item = self.indexItems[0];
                //先考虑横线
                CGFloat pointX = item.beginPointX + self.totalValiadWidth * progress;
                CGFloat expectHorizon = (progress - thresholdBegin) * self.totalValiadWidth;//非横线的宽度
                CGFloat widthHorizon = self.itemWidth - expectHorizon; //横线的宽度
                if (widthHorizon < 0.000001) {//如果太短，忽略横线
                    widthHorizon = 0;
                    expectHorizon = self.itemWidth;
                }
                CGFloat deltY = tan(self.angle) * expectHorizon;//向下偏移
                CGContextMoveToPoint(context, pointX, pointY);
                CGContextAddLineToPoint(context, pointX + widthHorizon, pointY);
                if(expectHorizon > 1/2.0 * self.itemWidth){// => "-\/"
                    deltY = 1/2.0 * self.itemWidth * tan(self.angle);
                    // => "完整\"
                    CGContextAddLineToPoint(context, pointX + widthHorizon + 1/2.0 * self.itemWidth, pointY + deltY);
                    CGFloat rightDeltY = deltY - (expectHorizon - 1/2.0 * self.itemWidth)*tan(self.angle);
                    CGContextAddLineToPoint(context, pointX + self.itemWidth, pointY + rightDeltY);
                    CGContextSetLineJoin(context, self.join);
                    CGContextSetLineWidth(context, lineWidth);
                    CGContextSetLineCap(context, self.cap);
                }else{// => "-\"
                    CGContextAddLineToPoint(context, pointX+self.itemWidth, pointY + deltY);
                    CGContextSetLineJoin(context, self.join);
                    CGContextSetLineWidth(context, lineWidth);
                    CGContextSetLineCap(context, self.cap);
                }
            }else{// 画 \/- => /- => -
                AnimationProgressItem *item = self.indexItems[0];
                CGFloat pointX = item.beginPointX + self.totalValiadWidth * progress;
                CGFloat horizon = (progress - progressItem.progress) * self.totalValiadWidth;
                CGFloat const maxDeltY = 1/2.0 * self.itemWidth * tan(self.angle);
                CGFloat exHorzon = self.itemWidth - horizon; //除去直线之外的宽度
                if(exHorzon > 1/2.0 * self.itemWidth){//
                    CGFloat leftWidth = exHorzon - 1/2.0 * self.itemWidth;
                    
                    CGFloat deltY = maxDeltY - leftWidth * tan(self.angle);
                    CGContextMoveToPoint(context, pointX, pointY + deltY);
                    //        CGFloat rightDeltY = deltY - (expectHorizon - 1/2.0 * self.itemWidth)*tan(self.angle);
                    // => "\"
                    CGContextAddLineToPoint(context, progressItem.beginPointX + 1/2.0 * self.itemWidth, pointY + maxDeltY);
                    // => "/"
                    CGContextAddLineToPoint(context, progressItem.beginPointX + self.itemWidth, pointY);
                    // => "-"
                    CGContextAddLineToPoint(context, progressItem.beginPointX + self.itemWidth + horizon, pointY);
                    CGContextSetLineJoin(context, self.join);
                    CGContextSetLineWidth(context, lineWidth);
                    CGContextSetLineCap(context, self.cap);
                }else{// => "/-"
                    CGFloat exHorozonDeltY = exHorzon * tan(self.angle);
                    //        CGFloat deltY = maxDeltY - exHorozonDeltY;
                    CGContextMoveToPoint(context, pointX, pointY + exHorozonDeltY);
                    // => "/"
                    CGFloat rightHalf = progressItem.beginPointX + self.itemWidth;
                    CGContextAddLineToPoint(context, rightHalf, pointY);
                    // => "-"
                    CGContextAddLineToPoint(context, rightHalf + horizon, pointY);
                    CGContextSetLineJoin(context, self.join);
                    CGContextSetLineWidth(context, lineWidth);
                    CGContextSetLineCap(context, self.cap);
                }
            }
        }else{
            // Setup the horizontal line to demostrate caps
            AnimationProgressItem *item = self.indexItems[0];
            CGFloat pointX = item.beginPointX + self.totalValiadWidth * progress;
            CGContextMoveToPoint(context, pointX, pointY);
            CGContextAddLineToPoint(context, pointX + self.itemWidth, pointY);
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetLineCap(context, self.cap);
        }
    }else{//不用考虑三角
        // Setup the horizontal line to demostrate caps
        AnimationProgressItem *item = self.indexItems[0];
        CGFloat pointX = item.beginPointX + self.totalValiadWidth * progress;
        CGContextMoveToPoint(context, pointX, pointY);
        CGContextAddLineToPoint(context, pointX + self.itemWidth, pointY);
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetLineCap(context, self.cap);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

#pragma mark -draw
//绘制圆角
-(void)drawInContext:(CGContextRef)context
{
    // Drawing lines with a white stroke color
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    [self refreshForProgress:self.curToProgress context:context];
}

- (void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

@end
