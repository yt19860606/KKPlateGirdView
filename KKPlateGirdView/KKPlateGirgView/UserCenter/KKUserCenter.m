//
//  KKUserCenter.m
//  KKToydayNews
//
//  Created by lzp on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKUserCenter.h"
#import "KKSegmentItem.h"

@implementation KKUserCenter

@synthesize userFavPlateArray = _userFavPlateArray;
@synthesize userNotFavPlateArray = _userNotFavPlateArray;

+ (instancetype)shareInstance{
    static KKUserCenter *share = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[KKUserCenter alloc]init];
    });
    return share ;
}

#pragma mark -- 保存用户感兴趣的模块到本地

- (void)saveUserFavPlate{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userFavPlateArray];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:KKUserFavPlateData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark -- @property

//用户感兴趣的板块
- (NSMutableArray *)userFavPlateArray{
    if(!_userFavPlateArray){
        _userFavPlateArray = [[NSMutableArray alloc]init];
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:KKUserFavPlateData];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(!array.count){
            for(KKSegmentType i = KKSegmentTypeRecommend ; i < KKSegmentTypeGovAffairs ; i++ ){
                NSString *title = [kkSegmentTitle() objectAtIndex:i];
                KKSegmentItem *item = [[KKSegmentItem alloc]initWithSegmentType:i title:title];
                [_userFavPlateArray addObject:item];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userFavPlateArray];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:KKUserFavPlateData];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [_userFavPlateArray addObjectsFromArray:array];
        }
    }
    return _userFavPlateArray;
}

- (void)setUserFavPlateArray:(NSMutableArray *)userFavPlateArray{
    _userFavPlateArray = userFavPlateArray ;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userFavPlateArray];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:KKUserFavPlateData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//用户不感兴趣的板块
- (NSMutableArray *)userNotFavPlateArray{
    if(!_userNotFavPlateArray){
        _userNotFavPlateArray = [[NSMutableArray alloc]init];
        for(KKSegmentType i = KKSegmentTypeRecommend ; i < KKSegmentTypeGoodPower ; i++){
            __block BOOL exist = NO ;
            [self.userFavPlateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KKSegmentItem *item = (KKSegmentItem *)obj;
                if(item.type == i){
                    exist = YES ;
                    *stop = YES ;
                }
            }];
            if(!exist){
                NSString *title = [kkSegmentTitle() objectAtIndex:i];
                KKSegmentItem *item = [[KKSegmentItem alloc]initWithSegmentType:i title:title];
                [_userNotFavPlateArray addObject:item];
            }
        }
    }
    return _userNotFavPlateArray;
}

- (void)setUserNotFavPlateArray:(NSMutableArray *)userNotFavPlateArray{
    _userNotFavPlateArray = userNotFavPlateArray;
}

@end
