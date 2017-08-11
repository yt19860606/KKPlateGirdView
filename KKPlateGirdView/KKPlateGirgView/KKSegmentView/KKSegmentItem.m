//
//  KKSegmentItem.m
//  KKToydayNews
//
//  Created by lzp on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKSegmentItem.h"
#import "MJExtension.h"

@implementation KKSegmentItem

- (id)initWithSegmentType:(KKSegmentType)type title:(NSString *)title{
    self = [super init];
    if(self){
        self.type = type;
        self.title = title;
    }
    return self ;
}

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [self mj_encode:encoder]; 
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
