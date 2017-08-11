//
//  ViewController.m
//  KKPlateGirdView
//
//  Created by finger on 2017/8/11.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "ViewController.h"
#import "KKSegmentView.h"
#import "KKUserCenter.h"
#import "KKSelectPlateView.h"

@interface ViewController ()<KKSegmentViewDelegate>
@property(nonatomic,strong)KKSegmentView *segmentView;
@property(nonatomic,strong)KKSelectPlateView *selPlateView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 设置UI

- (void)setupUI{
    self.navigationItem.title = @"主页";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark -- 加载数据

- (void)loadData{
    self.segmentView.segmentItems = [KKUserCenter shareInstance].userFavPlateArray ;
}

#pragma mark -- KKSegmentViewDelegate

- (void)selectedSegmentItem:(KKSegmentItem *)item{
    
}

- (void)addMoreSegmentClicked{
    self.selPlateView = [[KKSelectPlateView alloc]init];
    @weakify(self);
    [self.selPlateView setCloseHandler:^{
        @strongify(self);
        [self.selPlateView removeFromSuperview];
        self.selPlateView = nil ;
    }];
    [self.selPlateView setJumpToViewCtrlByTypeHandler:^(KKSegmentType type) {
        @strongify(self);
        [self.selPlateView startHideAnimate];
        [self.segmentView setCurtSelType:type];
    }];
    [self.selPlateView setUserPlateHasChangeedHandler:^{
        @strongify(self);
        self.segmentView.segmentItems = [KKUserCenter shareInstance].userFavPlateArray;
    }];
    self.selPlateView.curtSelType = self.segmentView.curtSelType;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selPlateView];
    [self.selPlateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(UIDeviceScreenWidth, UIDeviceScreenHeight));
    }];
    [self.selPlateView startShowAnimate];
}


#pragma mark -- @property

- (KKSegmentView *)segmentView{
    if(!_segmentView) {
        _segmentView = ({
            KKSegmentView *view = [[KKSegmentView alloc]init];
            view.delegate = self ;
            view ;
        });
    }
    return _segmentView;
}


@end
