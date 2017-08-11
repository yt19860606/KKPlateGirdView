//
//  KKSegmentCollectionCell.h
//  KKToydayNews
//
//  Created by finger on 2017/8/7.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKSegmentItem.h"

@interface KKSegmentCollectionCell : UICollectionViewCell

@property(nonatomic)KKSegmentItem *item ;
@property(nonatomic)BOOL isSelected;//是否选择

+ (CGSize)titleSize:(NSString *)title;

@end
