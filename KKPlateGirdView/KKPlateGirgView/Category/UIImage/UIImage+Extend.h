//
//  UIImage+Extend.h
//  KKToydayNews
//
//  Created by finger on 2017/8/6.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(UIImage)

#pragma mark -- 图片透明度

- (UIImage *)imageWithAlpha:(float)theAlpha;

#pragma mark -- 图片填充颜色

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
