//
//  KKSelectPlateView.h
//  KKToydayNews
//
//  Created by finger on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSelectPlateView : UIView

@property(nonatomic,copy)void(^closeHandler)();
@property(nonatomic,copy)void(^jumpToViewCtrlByTypeHandler)(KKSegmentType);
@property(nonatomic,copy)void(^userPlateHasChangeedHandler)();

@property(nonatomic,assign)KKSegmentType curtSelType;

#pragma mark -- 显示与隐藏动画

- (void)startShowAnimate;
- (void)startHideAnimate;

@end
