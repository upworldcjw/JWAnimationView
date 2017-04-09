//
//  ViewController.m
//  TestAanimationView
//
//  Created by JianweiChenJianwei on 2017/3/14.
//  Copyright © 2017年 UL. All rights reserved.
//

#import "ViewController.h"
#import "ScrollTabBarCell.h"
#import "JWAnimationView.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) NSMutableArray *itemTitles;

@property (nonatomic, strong) JWCollectionLayoutItem *item;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JWAnimationView *animationView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) JWAnimationView *animationView2;
@property (nonatomic, strong) NSTimer *timer2;

@property (nonatomic, strong) UICollectionView *collectionView3;
@property (nonatomic, strong) JWAnimationView *animationView3;
@property (nonatomic, strong) NSTimer *timer3;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.item = [[JWCollectionLayoutItem alloc] init];
  self.item.itemWidths = [@[@"40",@"50",@"60",@"70",@"60",@"50",@"40",@"60",@"70"] mutableCopy];;
  self.item.leftMargin = 20;
  self.item.rightMargin = 20;
  self.item.itemSapce = 10;
  self.itemTitles = [@[@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine"] mutableCopy];
  
  [self test1];
  [self test2];
  [self test3];
}

- (void)test1{
  UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
  [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  
  _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
  _collectionView.dataSource = self;
  _collectionView.delegate = self;
  _collectionView.backgroundColor = [UIColor redColor];
  _collectionView.scrollsToTop = NO;
  _collectionView.showsVerticalScrollIndicator = NO;
  _collectionView.showsHorizontalScrollIndicator = NO;
  _collectionView.clipsToBounds = NO;
  [_collectionView registerClass:[ScrollTabBarCell class] forCellWithReuseIdentifier:@"IKScrollTabBarCell"];
  [_collectionView setFrame:CGRectMake(0, 44, self.view.frame.size.width, 80)];
  
  [self.view addSubview:_collectionView];
  
  JWAnimationView *view = [[JWAnimationView alloc] initWithLayoutItem:self.item];
  view.backgroundColor = [UIColor blueColor];
  [view setFrame:CGRectMake(0, 60, [self totoalWidth], 20)];
  [view prepareAnimation];
  self.animationView = view;
  
  [_collectionView addSubview:view];
  [_collectionView reloadData];
  [self testWhole];
}

- (void)test2{
  UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
  [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  
  _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
  _collectionView2.dataSource = self;
  _collectionView2.delegate = self;
  _collectionView2.backgroundColor = [UIColor redColor];
  _collectionView2.scrollsToTop = NO;
  _collectionView2.showsVerticalScrollIndicator = NO;
  _collectionView2.showsHorizontalScrollIndicator = NO;
  _collectionView2.clipsToBounds = NO;
  [_collectionView2 registerClass:[ScrollTabBarCell class] forCellWithReuseIdentifier:@"IKScrollTabBarCell"];
  [_collectionView2 setFrame:CGRectMake(0, 44+100, self.view.frame.size.width, 80)];
  
  [self.view addSubview:_collectionView2];
  
  JWAnimationView *view = [[JWAnimationView alloc] initWithLayoutItem:self.item];
  view.backgroundColor = [UIColor blueColor];
  [view setFrame:CGRectMake(0, 60, [self totoalWidth], 20)];
  [view prepareAnimation];
  self.animationView2 = view;
  
  [_collectionView2 addSubview:view];
  [_collectionView2 reloadData];
  [self testFromTabToTab];
}

- (void)test3{
  UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
  [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  
  _collectionView3 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
  _collectionView3.dataSource = self;
  _collectionView3.delegate = self;
  _collectionView3.backgroundColor = [UIColor redColor];
  _collectionView3.scrollsToTop = NO;
  _collectionView3.showsVerticalScrollIndicator = NO;
  _collectionView3.showsHorizontalScrollIndicator = NO;
  _collectionView3.clipsToBounds = NO;
  [_collectionView3 registerClass:[ScrollTabBarCell class] forCellWithReuseIdentifier:@"IKScrollTabBarCell"];
  [_collectionView3 setFrame:CGRectMake(0, 44+200, self.view.frame.size.width, 80)];
  
  [self.view addSubview:_collectionView3];
  
  JWAnimationView *view = [[JWAnimationView alloc] initWithLayoutItem:self.item];
  view.backgroundColor = [UIColor blueColor];
  [view setFrame:CGRectMake(0, 60, [self totoalWidth], 20)];
  [view prepareAnimation];
  self.animationView3 = view;
  
  [_collectionView3 addSubview:view];
  [_collectionView3 reloadData];
  [self testFromTabToTabAnimationDuration];
}


- (void)testWhole{
  __block CGFloat progress = 0.01;
  self.animationView.markAngelIndex = 3;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    if (progress > 1 ) {
      progress = 0;
    }
    [self.animationView setProgress:progress ];
    progress += 0.01;
  }];
}

- (void)testFromTabToTab{
  NSInteger fromTab = 2;
  self.animationView2.markAngelIndex = 3;
  NSInteger toTab = 3;
  __block CGFloat progress = 0.01;
  self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    if (progress > 1 ) {
      progress = 0;
    }
    [self.animationView2 fromIndex:fromTab toIndex:toTab progress:progress];
    progress += 0.01;
  }];
}


- (void)testFromTabToTabAnimationDuration{
  NSInteger fromTab = 2;
  self.animationView3.markAngelIndex = 3;
  NSInteger toTab = 3;
  CGFloat duration = 1;
  [self.animationView3 fromIndex:fromTab toIndex:toTab duration:duration];
}


- (CGFloat)totoalWidth{
  return [self.item properWidth];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
  return UIEdgeInsetsMake(0, self.item.leftMargin, 0, self.item.rightMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  return self.item.itemSapce;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = [self.item.itemWidths[indexPath.row] floatValue];
  return CGSizeMake(width,44);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.itemTitles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScrollTabBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IKScrollTabBarCell" forIndexPath:indexPath];
  cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:indexPath.row * 0.1+0.1];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  self.animationView3.selectedIndex = indexPath.row;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
