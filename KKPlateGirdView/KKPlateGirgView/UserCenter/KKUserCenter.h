//
//  KKUserCenter.h
//  KKToydayNews
//
//  Created by lzp on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUserCenter : NSObject

@property(nonatomic,strong)NSMutableArray *userFavPlateArray;//用户感兴趣的板块
@property(nonatomic,strong)NSMutableArray *userNotFavPlateArray;//用户还未添加的板块

+ (instancetype)shareInstance;

#pragma mark -- 保存用户感兴趣的模块到本地

- (void)saveUserFavPlate;

@end
