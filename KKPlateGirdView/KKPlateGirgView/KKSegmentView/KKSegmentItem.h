//
//  KKSegmentItem.h
//  KKToydayNews
//
//  Created by lzp on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKSegmentItem : NSObject<NSCoding>

@property(nonatomic,assign)KKSegmentType type ;
@property(nonatomic,copy)NSString *title ;

- (id)initWithSegmentType:(KKSegmentType)type title:(NSString *)title;

@end
