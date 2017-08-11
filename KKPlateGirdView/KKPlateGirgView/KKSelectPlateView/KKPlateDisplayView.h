//
//  KKPlateDisplayView.h
//  KKToydayNews
//
//  Created by finger on 2017/8/9.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKSegmentItem.h"

@protocol KKPlateDisplayViewDelegate;
@interface KKPlateDisplayView : UIView

@property(nonatomic,weak)id<KKPlateDisplayViewDelegate>delegate;

@property(nonatomic,assign)KKSegmentType curtSelType;
@property(nonatomic,assign)BOOL isEditState;//编辑状态

- (id)initWithFavorite:(BOOL)favorite;

#pragma mark -- 计算视图的高度

- (NSInteger)calculateViewHeight;

#pragma mark -- 删除/添加某个位置的板块

- (KKSegmentType)removeItemAtIndex:(NSInteger)index animate:(BOOL)animate;

- (void)addItemAtIndex:(NSInteger)index item:(KKSegmentItem *)item initRect:(CGRect)rect animate:(BOOL)animate;

@end

@protocol KKPlateDisplayViewDelegate <NSObject>
- (void)longPressArise;
- (void)addOrRemoveItemWithType:(KKSegmentType)type itemOrgRect:(CGRect)rect opType:(KKSegmentOpType)opType;
- (void)needJumpToPlateByType:(KKSegmentType)type;
- (void)userPlateHasChanged;//用户感兴趣的板块已经发生改变，需要更新主界面
@end
