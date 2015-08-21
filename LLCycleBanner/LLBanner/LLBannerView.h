//
//  LLBannerView.h
//  Demo
//
//  Created by LiXingLe on 15/8/20.
//  Copyright (c) 2015年 com.wildcat. All rights reserved.
//  循环滚动广告栏

#import <UIKit/UIKit.h>

@protocol LLBannerDataSource;
@protocol LLBannerDelegate;

@interface LLBannerView : UIView

/// 滚动视图
@property (nonatomic,strong,readonly) UIScrollView *scrollView;
///数据源
@property (nonatomic,weak) id <LLBannerDataSource> dataSource;
///delegate
@property (nonatomic,weak) id <LLBannerDelegate> delegate;
///计时器
@property (nonatomic,strong) NSTimer *timer;

///创建计时器
-(void)createTimer;
///销毁计时器
- (void)removeTimer;

@end

@protocol LLBannerDataSource <NSObject>
@required
/*
*    子视图的个数
*/
-(NSInteger)numberOfSubViewsInBannerView:(LLBannerView *)bannerView;
/*
 *    视图的内容
 */
-(UIView *)bannerView:(LLBannerView *)bannerView viewForIndex:(NSInteger)index;
@end

@protocol LLBannerDelegate <NSObject>
@optional
/*
点击了某个子视图
*/
-(void)bannerView:(LLBannerView *)bannerView didClickSubViewForIndex:(NSInteger)index;

@end
