//
//  KKSelectPlateView.m
//  KKToydayNews
//
//  Created by finger on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKSelectPlateView.h"
#import "KKSectionHeaderView.h"
#import "KKPlateDisplayView.h"
#import "KKUserCenter.h"

@interface KKSelectPlateView()<KKPlateDisplayViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *bgView ;
@property(nonatomic,strong)UIView *contentView ;//包含关闭按钮和板块部分视图
@property(nonatomic,strong)UIButton *closeBtn ;
@property(nonatomic,strong)UIView *splitView ;
@property(nonatomic,strong)UIScrollView *plateContentView ;//板块部分视图
@property(nonatomic,strong)KKSectionHeaderView *headerView1;//已选择的板块头部
@property(nonatomic,strong)KKSectionHeaderView *headerView2;//推荐的板块头部
@property(nonatomic,strong)KKPlateDisplayView *favPlateView ;
@property(nonatomic,strong)KKPlateDisplayView *notFavPlateView ;

@property(nonatomic,assign)CGFloat statusBarHeight ;
@property(nonatomic,assign)CGSize screenSzie ;
@property(nonatomic,strong)UIPanGestureRecognizer *panRecognizer;//拖动选择板块视图的手势

@end

@implementation KKSelectPlateView

- (id)init{
    self = [super init];
    if(self){
        [self setupUI];
        [self bandingEvent];
    }
    return self ;
}

#pragma mark -- 初始化UI

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.splitView];
    [self.contentView insertSubview:self.plateContentView belowSubview:self.splitView];
    [self.plateContentView addSubview:self.headerView1];
    [self.plateContentView addSubview:self.favPlateView];
    [self.plateContentView addSubview:self.headerView2];
    [self.plateContentView addSubview:self.notFavPlateView];
    
    self.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.screenSzie = [[UIScreen mainScreen]bounds].size;
    self.contentView.frame = CGRectMake(0, self.screenSzie.height, self.screenSzie.width, self.screenSzie.height);
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(10);
        make.left.mas_equalTo(self.contentView).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.splitView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeBtn.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.screenSzie.width, 0.6));
    }];
    
    [self.plateContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.splitView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView).mas_offset(-self.statusBarHeight);
    }];
    
    [self.headerView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.plateContentView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.plateContentView);
    }];
    
    NSInteger height = [self.favPlateView calculateViewHeight];
    [self.favPlateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView1.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.plateContentView);
        make.width.mas_equalTo(self.plateContentView.mas_width);
        make.height.mas_equalTo(height);
    }];
    
    [self.headerView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favPlateView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.plateContentView);
    }];
    
    height = [self.notFavPlateView calculateViewHeight];
    [self.notFavPlateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView2.mas_bottom).mas_offset(5).priority(998);
        make.left.mas_equalTo(self.plateContentView);
        make.width.mas_equalTo(self.plateContentView.mas_width);
        make.height.mas_equalTo(height);
    }];
}

#pragma mark -- 显示与隐藏动画

- (void)startShowAnimate{
    self.bgView.alpha = 0 ;
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.85
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.bgView.alpha = 1.0 ;
                         self.contentView.top = self.statusBarHeight;
                     }completion:^(BOOL finished) {
                         [self addGestureRecognizer:self.panRecognizer];
                         self.plateContentView.contentSize = CGSizeMake(self.screenSzie.width, self.notFavPlateView.bottom + 80);
                     }];
}

- (void)startHideAnimate{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.0 ;
        self.contentView.top = self.screenSzie.height;
    } completion:^(BOOL finished) {
        [self removeGestureRecognizer:self.panRecognizer];
        if(self.closeHandler){
            self.closeHandler();
        }
    }];
}

#pragma mark -- 事件绑定

- (void)bandingEvent{
    [self.closeBtn addTarget:self action:@selector(startHideAnimate) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);
    [self.headerView1 setEnditBtnClickHandler:^(BOOL isEdit){
        @strongify(self);
        self.favPlateView.isEditState = isEdit;
    }];
}

#pragma mark -- 拖动板块选择视图的手势

- (void)panRecognizer:(UIPanGestureRecognizer *)panRecognizer{
    UIGestureRecognizerState state = panRecognizer.state;
    CGPoint point = [panRecognizer translationInView:self];
    if(state == UIGestureRecognizerStateChanged){
        CGFloat top = self.contentView.top;
        if(top + point.y < self.statusBarHeight){
            self.contentView.top = 20 ;
            return ;
        }
        
        self.plateContentView.scrollEnabled = NO ;
        
        self.contentView.centerY = self.contentView.centerY + point.y;
        
        CGFloat alpha = (1.0 - top / self.screenSzie.height) ;
        self.bgView.alpha = MAX(alpha,0);
        
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
        
    }else if(state == UIGestureRecognizerStateEnded ||
             state == UIGestureRecognizerStateFailed ||
             state == UIGestureRecognizerStateCancelled){
        CGFloat top = self.contentView.top;
        if(top >= self.screenSzie.height / 3){
            [UIView animateWithDuration:0.1 animations:^{
                self.bgView.alpha = 0 ;
                self.contentView.top = self.screenSzie.height;
            } completion:^(BOOL finished) {
                [self removeGestureRecognizer:self.panRecognizer];
                [self removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:2.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.bgView.alpha = 1.0 ;
                                 self.contentView.top = self.statusBarHeight;
                             }completion:^(BOOL finished) {
                                 
                             }];
        }
        
        self.plateContentView.scrollEnabled = YES ;
    }
}

#pragma mark -- KKPlateDisplayViewDelegate

- (void)longPressArise{
    self.headerView1.isEdit = YES ;
}

- (void)addOrRemoveItemWithType:(KKSegmentType)type itemOrgRect:(CGRect)rect opType:(KKSegmentOpType)opType{
    
    NSString *title = [kkSegmentTitle() objectAtIndex:type];
    KKSegmentItem *item = [[KKSegmentItem alloc]initWithSegmentType:type title:title];
    if(opType == KKSegmentOpTypeAddToFavPlate){
        CGRect frame = [self.notFavPlateView convertRect:rect toView:self.favPlateView];
        [self.favPlateView addItemAtIndex:-1 item:item initRect:frame animate:YES];
    }else if(opType == KKSegmentOpTypeRemoveFromPlate){
        CGRect frame = [self.favPlateView convertRect:rect toView:self.notFavPlateView];
        [self.notFavPlateView addItemAtIndex:0 item:item initRect:frame animate:YES];
    }
    
    if(self.userPlateHasChangeedHandler){
        self.userPlateHasChangeedHandler();
    }
    
    NSInteger height = [self.favPlateView calculateViewHeight];
    [self.favPlateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    [self.headerView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favPlateView.mas_bottom).mas_offset(5);
    }];
    
    height = [self.notFavPlateView calculateViewHeight];
    [self.notFavPlateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.plateContentView.contentSize = CGSizeMake(self.screenSzie.width, self.notFavPlateView.bottom + 80);
    }];
}

- (void)needJumpToPlateByType:(KKSegmentType)type{
    if(self.jumpToViewCtrlByTypeHandler){
        self.jumpToViewCtrlByTypeHandler(type);
    }
}

- (void)userPlateHasChanged{
    if(self.userPlateHasChangeedHandler){
        self.userPlateHasChangeedHandler();
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    self.splitView.alpha = offset.y > 0 ? 1.0 :0.0 ;
    
    if(offset.y < 0 ){
        offset.y = 0 ;
        scrollView.contentOffset = offset ;
    }
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)otherGestureRecognizer.view;
        if(view.contentOffset.y > 0.0){
            return NO ;
        }
        return YES;
    }

    return NO;
}

#pragma mark -- @property

- (void)setCurtSelType:(KKSegmentType)curtSelType{
    _curtSelType = curtSelType ;
    self.favPlateView.curtSelType = curtSelType ;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = ({
            UIView *view = [[UIView alloc]init];
            view.clipsToBounds = YES ;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 10.0 ;
            view ;
        });
    }
    return _contentView;
}

- (UIScrollView *)plateContentView{
    if(!_plateContentView){
        _plateContentView = ({
            UIScrollView *view = [[UIScrollView alloc]init];
            view.scrollEnabled = YES ;
            view.delegate = self ;
            view.showsVerticalScrollIndicator = NO ;
            view.showsHorizontalScrollIndicator = NO ;
            view ;
        });
    }
    return _plateContentView;
}

- (UIView *)bgView{
    if(!_bgView){
        _bgView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            view ;
        });
    }
    return _bgView;
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
            view ;
        });
    }
    return _closeBtn ;
}

- (UIView *)splitView{
    if(!_splitView){
        _splitView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
            view.alpha = 0.0 ;
            view ;
        });
    }
    return _splitView;
}

- (KKSectionHeaderView *)headerView1{
    if(!_headerView1){
        _headerView1 = ({
            KKSectionHeaderView *view = [[KKSectionHeaderView alloc]init];
            view.titleText = @"我的频道";
            view.detailText = @"点击进入频道";
            view.hiddenEditBtn = NO ;
            view ;
        });
    }
    return _headerView1 ;
}

- (KKSectionHeaderView *)headerView2{
    if(!_headerView2){
        _headerView2 = ({
            KKSectionHeaderView *view = [[KKSectionHeaderView alloc]init];
            view.titleText = @"频道推荐";
            view.detailText = @"点击添加频道";
            view.hiddenEditBtn = YES ;
            view ;
        });
    }
    return _headerView2 ;
}

- (UIPanGestureRecognizer *)panRecognizer{
    if(!_panRecognizer){
        _panRecognizer = ({
            UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
            recognizer.delegate = self ;
            recognizer;
        });
    }
    return _panRecognizer;
}

- (KKPlateDisplayView *)favPlateView{
    if(!_favPlateView){
        _favPlateView = [[KKPlateDisplayView alloc]initWithFavorite:YES];
        _favPlateView.delegate = self ;
    }
    return _favPlateView;
}

- (KKPlateDisplayView *)notFavPlateView{
    if(!_notFavPlateView){
        _notFavPlateView = [[KKPlateDisplayView alloc]initWithFavorite:NO];
        _notFavPlateView.delegate = self ;
    }
    return _notFavPlateView;
}

@end
