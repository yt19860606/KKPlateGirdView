//
//  KKSegmentView.h
//  KKToydayNews
//
//  Created by finger on 2017/8/7.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKSegmentItem.h"

@protocol KKSegmentViewDelegate;
@interface KKSegmentView : UIView
@property(nonatomic,strong)NSArray *segmentItems;
@property(nonatomic,assign)KKSegmentType curtSelType;
@property(nonatomic,weak)id<KKSegmentViewDelegate>delegate ;
@end

@protocol KKSegmentViewDelegate <NSObject>
- (void)selectedSegmentItem:(KKSegmentItem *)item ;
- (void)addMoreSegmentClicked;
@end
