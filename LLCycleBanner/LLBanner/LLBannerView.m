//
//  LLBannerView.m
//  Demo
//
//  Created by LiXingLe on 15/8/20.
//  Copyright (c) 2015年 com.wildcat. All rights reserved.
//

#import "LLBannerView.h"
#define kSubViewTag 1000

@interface LLBannerView () <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *_viewArray;
    UIPageControl *_pageControl;
    
    NSInteger _currentPage;
    NSInteger _totalCount; //子视图的个数

}

@end

@implementation LLBannerView
@synthesize scrollView=_scrollView;
#pragma mark - init
-(instancetype)init{
    if (self=[super init]) {
        [self buildUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

#pragma mark - setter
#pragma mark 重写set方法
-(void)setDataSource:(id<LLBannerDataSource>)dataSource{
    _dataSource=dataSource;
    [self loadData];
}



#pragma mark - Scroller View Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    [self updateOffset];
    
    int page = _scrollView.contentOffset.x/self.frame.size.width;
    [_pageControl setCurrentPage:page-1];

}




#pragma mark - Action
#pragma mark 点击事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    UIView *view=[sender view];
    NSInteger index=view.tag-kSubViewTag;
    if ([self.delegate respondsToSelector:@selector(bannerView:didClickSubViewForIndex:)]) {
        [self.delegate bannerView:self didClickSubViewForIndex:index];
    }
    

}

#pragma mark  - Timer
-(void)createTimer{
    if (self.timer==nil) {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)removeTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
        
    }
}
#pragma mark - Update UI
-(void)updateUI{
    int page = _scrollView.contentOffset.x/self.frame.size.width;
    
    if (page==_totalCount-2||page==_totalCount-1) { //最后
        [_pageControl setCurrentPage:0];
        NSLog(@"currentScroll:%d --->nextControl: %d",page,0);
    }
//    if (page==0) {
//        [_pageControl setCurrentPage:_totalCount-2];
//        
//    }
    else{
        [_pageControl setCurrentPage:page];
        NSLog(@"currentScroll:%d --->nextControl: %d",page,page);
    }
   

    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentOffset.x+self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    
    [self updateOffset];
    
}
-(void)updateOffset{
    int page=_scrollView.contentOffset.x/self.frame.size.width;
    if (page==_totalCount-1) { //最后
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        
    }else if (page==0) {
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width*(_totalCount-2), 0) animated:NO];
        
    }
}

#pragma mark - UI
-(void)buildUI{
    _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
    
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
    [self addSubview:_pageControl];  //将UIPageControl添加到主界面上。
    
    
}
#pragma mark  加载
-(void)loadData{
    
    
    _totalCount=[_dataSource numberOfSubViewsInBannerView:self]+2;
    CGSize size=self.frame.size;
    
    _scrollView.contentSize=CGSizeMake(size.width*_totalCount, size.height);
    _pageControl.numberOfPages = [_dataSource numberOfSubViewsInBannerView:self];//总的页数
    _pageControl.currentPage = 0; //当前页
    
    
    
    
    _viewArray=[NSMutableArray array];
    //创建subview
    for (int i=0; i<_totalCount; i++) {
        if (i==0) {  //第一个显示第后一个
            [_viewArray addObject:[self getSubviewAndAddGuestureRecognizer:_totalCount-3]];
        }else if ((_totalCount-1)==i){  //最后一个显示第一个
            
            [_viewArray addObject:[self getSubviewAndAddGuestureRecognizer:0]];
        }else{
            [_viewArray addObject:[self getSubviewAndAddGuestureRecognizer:i-1]];
        }
    }
    
    //添加contentview
    for (int i=0;i<_viewArray.count;i++) {
        UIView *view=_viewArray[i];
        view.frame=CGRectMake(size.width*i, 0, size.width, size.height);
        [_scrollView addSubview:view];
    }
    
    //默认展示第一张
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}
#pragma mark 获得子视图
-(UIView *)getSubviewAndAddGuestureRecognizer:(NSInteger)index{
    UIView *subView=[_dataSource bannerView:self viewForIndex:index];
    subView.tag=kSubViewTag+index;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    tapGesture.numberOfTouchesRequired = 1; //手指数
    tapGesture.numberOfTapsRequired = 1; //tap次数
    tapGesture.delegate = self;
    [subView addGestureRecognizer:tapGesture];
    return subView;
}







@end
