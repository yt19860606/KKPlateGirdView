//
//  KKPlateDisplayView.m
//  KKToydayNews
//
//  Created by finger on 2017/8/9.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKPlateDisplayView.h"
#import "KKUserCenter.h"
#import "KKSegmentItem.h"

@interface KKPlateDisplayView ()

@property(nonatomic,assign)BOOL isFavorite ;

@property(nonatomic,assign)NSInteger oneLineNum;//一行按钮数目
@property(nonatomic,assign)NSInteger btnWidth;//按钮宽度
@property(nonatomic,assign)NSInteger btnHeight;//按钮高度
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,weak)UIButton *curtSelBtn ;

@property(nonatomic,assign)CGPoint longPressPt;//记录长按拖拽时的坐标
@property(nonatomic,weak)UIButton *longPressBtn;//长按手势选中的按钮
@property(nonatomic,assign)BOOL hasFindTargetPos ;//拖拽时是否已经找到对应的插入位置
@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGesture;

@end

@implementation KKPlateDisplayView

- (id)initWithFavorite:(BOOL)favorite{
    self = [super init];
    if(self){
        self.oneLineNum = 4 ;
        self.btnHeight = 40 ;
        self.btnWidth = 80 ;
        if(iPhone6){
            self.btnWidth = 78;
        }else if(iPhonePlus){
            self.btnWidth = 85 ;
        }else if(iPhone5){
            self.btnWidth = 65 ;
        }
        self.btnHeight = self.btnWidth / 2 ;
        self.isFavorite = favorite;
        [self layoutUI];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}

#pragma mark -- 设置UI

- (void)layoutUI{
    
    NSArray *array = nil ;
    if(self.isFavorite){
        array = [KKUserCenter shareInstance].userFavPlateArray;
    }else{
        array = [KKUserCenter shareInstance].userNotFavPlateArray;
    }
    
    for(KKSegmentItem *item in array){
        UIButton *btn = [self crateBtnWithItem:item isFavorite:self.isFavorite];
        [self.btnArray addObject:btn];
        [self addSubview:btn];
    }
    
    [self adjustView];
}

#pragma mark -- 调整视图

- (void)adjustView{
    NSInteger space = MAX(0,(UIDeviceScreenWidth - self.oneLineNum * self.btnWidth ) / (self.oneLineNum + 1) );
    NSInteger index = 0 ;
    for(UIButton *btn in self.btnArray){
        NSInteger startX = (index % self.oneLineNum ) * (self.btnWidth + space) + space;
        NSInteger startY = (index / self.oneLineNum) * (self.btnHeight + space) + space ;
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(startX);
            make.top.mas_equalTo(self).mas_equalTo(startY);
            make.size.mas_equalTo(CGSizeMake(self.btnWidth, self.btnHeight));
        }];
        
        UIButton *badge = [btn viewWithTag:1000];
        [badge mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn).mas_offset(-8);
            make.right.mas_equalTo(btn).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        index ++ ;
    }
}

#pragma mark -- 删除/添加某个位置的板块

- (KKSegmentType)removeItemAtIndex:(NSInteger)index animate:(BOOL)animate{
    UIButton *btn = [self.btnArray objectAtIndex:index];
    [btn removeFromSuperview];
    [self.btnArray removeObjectAtIndex:index];
    
    //同步用户数据
    if(self.isFavorite){
        KKSegmentItem *item = [[KKUserCenter shareInstance].userFavPlateArray objectAtIndex:index];
        [[KKUserCenter shareInstance].userFavPlateArray removeObjectAtIndex:index];
        [[KKUserCenter shareInstance].userNotFavPlateArray insertObject:item atIndex:0];
        [[KKUserCenter shareInstance]saveUserFavPlate];
    }else{
        KKSegmentItem *item = [[KKUserCenter shareInstance].userNotFavPlateArray objectAtIndex:index];
        [[KKUserCenter shareInstance].userNotFavPlateArray removeObjectAtIndex:index];
        
        NSInteger index = [KKUserCenter shareInstance].userFavPlateArray.count;
        [[KKUserCenter shareInstance].userFavPlateArray insertObject:item atIndex:index];
        [[KKUserCenter shareInstance]saveUserFavPlate];
    }
    
    [self adjustView];
    
    if(animate){
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
    
    return (KKSegmentType)btn.tag ;
}

/**
 用户感兴趣的板块和不感兴趣的板块之间的按钮添加，实现了两个板块之间的移动效果

 @param index 位置索引
 @param item 插入的板块
 @param rect 初始坐标信息 用于两个板块之间按钮的移动效果
 @param animate 是否需要动画
 */
- (void)addItemAtIndex:(NSInteger)index item:(KKSegmentItem *)item initRect:(CGRect)rect animate:(BOOL)animate{
    if(index == -1){//添加到末尾
        index = self.btnArray.count;
    }
    
    UIButton *btn = [self crateBtnWithItem:item isFavorite:self.isFavorite];
    if(self.isFavorite && self.isEditState){
        UIButton *closeBtn = [btn viewWithTag:1000];
        closeBtn.hidden = NO ;
    }
    
    [self.btnArray insertObject:btn atIndex:index];
    [self addSubview:btn];
    
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(rect.origin.x);
        make.top.mas_equalTo(self).mas_equalTo(rect.origin.y);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, rect.size.height));
    }];
    [self layoutIfNeeded];
    
    [self adjustView];
    
    if(animate){
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark -- 计算视图的高度

- (NSInteger)calculateViewHeight{
    NSInteger count = self.btnArray.count;
    NSInteger space = MAX(0,(UIDeviceScreenWidth - self.oneLineNum * self.btnWidth ) / (self.oneLineNum + 1) );
    
    NSInteger numLine = 0;
    if(count <= self.oneLineNum){
        numLine = 1 ;
    }else{
        if(count % self.oneLineNum == 0){
            numLine = count / self.oneLineNum;
        }else{
            numLine = (count / self.oneLineNum) + 1 ;
        }
    }
    
    return self.btnHeight * numLine + (numLine + 1) * space;
}

#pragma mark -- 长按手势

- (void)longPressView:(UILongPressGestureRecognizer *)gesture{
    if(!self.isFavorite){
        return ;
    }
    CGPoint point = [gesture locationInView:self];
    if(gesture.state == UIGestureRecognizerStateBegan){
        self.longPressPt = point ;
        for(UIButton *btn in self.btnArray){
            if(CGRectContainsPoint(btn.frame, point)){
                if(btn.tag == KKSegmentTypeRecommend){
                    break ;
                }
                self.isEditState = YES ;
                self.longPressBtn = btn ;
                [self bringSubviewToFront:self.longPressBtn];
                [UIView animateWithDuration:0.3 animations:^{
                    self.longPressBtn.transform = CGAffineTransformScale(self.longPressBtn.transform, 1.2, 1.2);
                }];
                if(self.delegate && [self.delegate respondsToSelector:@selector(longPressArise)]){
                    [self.delegate longPressArise];
                }
                break ;
            }
        }
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        [self adjustView];
        [UIView animateWithDuration:0.3 animations:^{
            self.longPressBtn.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.hasFindTargetPos = NO ;
            self.longPressBtn = nil ;
        }];
    }else if(gesture.state == UIGestureRecognizerStateChanged){
        CGFloat offsetX = point.x - self.longPressPt.x;
        CGFloat offsetY = point.y - self.longPressPt.y;
        CGPoint pt = CGPointMake(self.longPressBtn.centerX + offsetX, self.longPressBtn.centerY + offsetY);
        self.longPressPt = point ;
        if(!self.longPressBtn){
            return ;
        }
        [self.longPressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(pt.x - self.btnWidth / 2.0);//必须除以浮点的2.0,如果是整数的2，则会有偏差
            make.top.mas_equalTo(self).mas_offset(pt.y - self.btnHeight / 2.0);
        }];
        if(!self.hasFindTargetPos){
            for(UIButton *btn in self.btnArray){
                if(self.longPressBtn.tag == btn.tag){
                    continue ;
                }
                if(CGRectContainsPoint(btn.frame, point)){
                    if(btn.tag == KKSegmentTypeRecommend){
                        break ;
                    }
                    self.hasFindTargetPos = YES ;
                    NSInteger longPressBtnIndex = [self.btnArray indexOfObject:self.longPressBtn];
                    NSInteger targetBtnIndex = [self.btnArray indexOfObject:btn];
                    [self.btnArray removeObjectAtIndex:longPressBtnIndex];
                    [self.btnArray insertObject:self.longPressBtn atIndex:targetBtnIndex];
                    
                    //更新用户数据
                    KKSegmentItem *item = [[KKUserCenter shareInstance].userFavPlateArray objectAtIndex:longPressBtnIndex];
                    [[KKUserCenter shareInstance].userFavPlateArray removeObjectAtIndex:longPressBtnIndex];
                    [[KKUserCenter shareInstance].userFavPlateArray insertObject:item atIndex:targetBtnIndex];
                    
                    [self layoutWithLongPress];
                    [UIView animateWithDuration:0.3 animations:^{
                        [self layoutIfNeeded];
                    }completion:^(BOOL finished) {
                        if(self.delegate && [self.delegate respondsToSelector:@selector(userPlateHasChanged)]){
                            [self.delegate userPlateHasChanged];
                        }
                        self.hasFindTargetPos = NO ;
                    }];
                    break ;
                }
            }
        }
    }
}

- (void)layoutWithLongPress{
    NSInteger space = MAX(0,(UIDeviceScreenWidth - self.oneLineNum * self.btnWidth ) / (self.oneLineNum + 1) );
    NSInteger index = 0 ;
    for(UIButton *btn in self.btnArray){
        NSInteger startX = (index % self.oneLineNum ) * (self.btnWidth + space) + space;
        NSInteger startY = (index / self.oneLineNum) * (self.btnHeight + space) + space ;
        if(btn.tag == self.longPressBtn.tag){
            index ++ ;
            continue ;
        }
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(startX);
            make.top.mas_equalTo(self).mas_equalTo(startY);
            make.size.mas_equalTo(CGSizeMake(self.btnWidth, self.btnHeight));
        }];
        
        UIButton *badge = [btn viewWithTag:1000];
        [badge mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn).mas_offset(-8);
            make.right.mas_equalTo(btn).mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        index ++ ;
    }
}

#pragma mark -- 快速新建按钮

- (UIButton *)crateBtnWithItem:(KKSegmentItem *)item isFavorite:(BOOL)isFavorite{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:item.title forState:UIControlStateNormal];
    [btn setTag:item.type];
    [btn setBackgroundColor:[[UIColor grayColor]colorWithAlphaComponent:0.1]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn.titleLabel sizeToFit];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn.layer setMasksToBounds:NO];
    [btn.layer setCornerRadius:3];
    [btn addTarget:self action:@selector(segmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(!isFavorite){
        [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
    
    if(isFavorite){
        UIButton *closeBtn = [[UIButton alloc]init];
        [closeBtn setImage:[UIImage imageNamed:@"recommend_cancel"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTag:1000];
        [closeBtn setHidden:YES];
        [closeBtn setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:closeBtn];
    }
    
    return btn ;
}

#pragma mark -- 按钮响应

- (void)segmentBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(self.isFavorite){
        if(!self.isEditState){
            if(self.delegate && [self.delegate respondsToSelector:@selector(needJumpToPlateByType:)]){
                [self.delegate needJumpToPlateByType:btn.tag];
            }
        }
    }else{
        UIButton *btnClicked = (UIButton *)sender ;
        CGRect frame = btnClicked.frame;
        NSInteger index = [self.btnArray indexOfObject:btnClicked];
        KKSegmentType type = [self removeItemAtIndex:index animate:YES];
        if(self.delegate && [self.delegate respondsToSelector:@selector(addOrRemoveItemWithType:itemOrgRect:opType:)]){
            [self.delegate addOrRemoveItemWithType:type itemOrgRect:frame opType:KKSegmentOpTypeAddToFavPlate];
        }
    }
}

- (void)closeBtnClicked:(id)sender{
    UIButton *btnClicked = (UIButton *)sender ;
    UIButton *surperBtn = (UIButton *)[btnClicked superview];
    NSInteger index = [self.btnArray indexOfObject:surperBtn];
    CGRect frame = surperBtn.frame;
    KKSegmentType type = [self removeItemAtIndex:index animate:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addOrRemoveItemWithType:itemOrgRect:opType:)]){
        [self.delegate addOrRemoveItemWithType:type itemOrgRect:frame opType:KKSegmentOpTypeRemoveFromPlate];
    }
}

#pragma mark -- @property

- (NSMutableArray *)btnArray{
    if(!_btnArray){
        _btnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArray;
}

- (UILongPressGestureRecognizer *)longPressGesture{
    if(!_longPressGesture){
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    }
    return _longPressGesture;
}

//设置编辑状态
- (void)setIsEditState:(BOOL)isEditState{
    _isEditState = isEditState;
    if(self.isFavorite){
        for(UIButton *btn in self.btnArray){
            if(btn.tag == KKSegmentTypeRecommend){
                continue ;
            }
            UIButton *closeBtn = [btn viewWithTag:1000];
            closeBtn.hidden = !_isEditState;
        }
        self.curtSelBtn.selected = !_isEditState ;
    }
}

- (void)setCurtSelType:(KKSegmentType)curtSelType{
    _curtSelType = curtSelType ;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tag == _curtSelType){
            self.curtSelBtn = obj ;
            self.curtSelBtn.selected = YES ;
            *stop = YES ;
        }
    }];
}

@end
