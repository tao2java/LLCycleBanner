//
//  ViewController.m
//  LLCycleBanner
//
//  Created by LiXingLe on 15/8/21.
//  Copyright (c) 2015年 com.wildcat. All rights reserved.
//

#import "ViewController.h"
#import "LLBannerView.h"

@interface ViewController() <LLBannerDataSource,LLBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LLBannerView *bannerView=[[LLBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    bannerView.dataSource=self;
    bannerView.delegate=self;
    [bannerView createTimer];
    [self.view addSubview:bannerView];
    
    
}

#pragma mark - LLBannerDataSource
-(NSInteger)numberOfSubViewsInBannerView:(LLBannerView *)bannerView{
    return 3;
}
-(UIView *)bannerView:(LLBannerView *)bannerView viewForIndex:(NSInteger)index{
    UIView *view=[[UIView alloc] init];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:20];
    label.text=[NSString stringWithFormat:@"%ld",(long)index];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    
    [view addSubview:imageView];
    
    if (index==0) {
        [imageView setImage:[UIImage imageNamed:@"111.jpg"]];
        view.backgroundColor=[UIColor redColor];
    }else if (1==index){
        view.backgroundColor=[UIColor purpleColor];
        [imageView setImage:[UIImage imageNamed:@"222.jpg"]];
    }else if (2==index){
        view.backgroundColor=[UIColor blueColor];
        [imageView setImage:[UIImage imageNamed:@"333.jpg"]];
    }
    return view;
}
#pragma mark - LLBannerDelegate

-(void)bannerView:(LLBannerView *)bannerView didClickSubViewForIndex:(NSInteger)index{
    NSLog(@"被点击：%ld",index);
}



@end
