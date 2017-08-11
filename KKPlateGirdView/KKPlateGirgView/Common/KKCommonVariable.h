//
//  KKCommonVariable.h
//  KKToydayNews
//
//  Created by lzp on 2017/8/8.
//  Copyright © 2017年 finger. All rights reserved.
//

#ifndef KKCommonVariable_h
#define KKCommonVariable_h

typedef NS_ENUM(NSInteger, KKSegmentOpType){
    KKSegmentOpTypeAddToFavPlate,//添加到用户感兴趣的板块
    KKSegmentOpTypeRemoveFromPlate,//从用户感兴趣的板块中删除
};

typedef NS_ENUM(NSInteger, KKSegmentType) {
    KKSegmentTypeRecommend,//推荐
    KKSegmentTypeInternational,//国际
    KKSegmentTypeVideo,//视频
    KKSegmentTypeHostSpot,//热点
    KKSegmentTypeSociety,//社会
    KKSegmentTypeDigital,//数码
    KKSegmentTypeTechnology,//科技
    KKSegmentTypeDuanZi,//段子
    KKSegmentTypePicture,//图片
    KKSegmentTypeMilitary,//军事
    KKSegmentTypeInterSociety,//国际社会
    KKSegmentTypeCar,//汽车
    KKSegmentTypeHealthy,//健康
    KKSegmentTypeJoke,//笑话
    KKSegmentTypeArticle,//文章
    KKSegmentTypeTourism,//旅游
    KKSegmentTypeGovAffairs,//政务
    KKSegmentTypeTaiWanAffairs,//台湾时事
    KKSegmentTypeFood,//美食
    KKSegmentTypeCulture,//文化
    KKSegmentTypeMovie,//电影
    KKSegmentTypeScience,//科学
    KKSegmentTypeStory,//故事
    KKSegmentTypeChinaPerform,//中国好表演
    KKSegmentTypeWomen,//美女
    KKSegmentTypeRumor,//谣言
    KKSegmentTypeTouTiaoHao,//头条号
    KKSegmentTypeOddPhotos,//趣图
    KKSegmentTypeQandA,//问答
    KKSegmentTypeSport,//体育
    KKSegmentTypeCarefullChosen,//精选
    KKSegmentTypeQuotations,//语录
    KKSegmentTypeNovel,//小说
    KKSegmentTypeEntertainment,//娱乐
    KKSegmentTypeFinance,//财经
    KKSegmentTypeLive,//直播
    KKSegmentTypeTeMai,//特卖
    KKSegmentTypeHouse,//房产
    KKSegmentTypeFashion,//时尚
    KKSegmentTypeHistory,//历史
    KKSegmentTypeParenting,//育儿
    KKSegmentTypeHealthLife,//养生
    KKSegmentTypePhone,//手机
    KKSegmentTypePet,//宠物
    KKSegmentTypeEmotion,//情感
    KKSegmentTypeHomeFurnishing,//家居
    KKSegmentTypeEducation,//教育
    KKSegmentTypeSanNong,//三农
    KKSegmentTypeMotherhood,//孕产
    KKSegmentTypeGame,//游戏
    KKSegmentTypeShares,//股票
    KKSegmentTypeComic,//动漫
    KKSegmentTypeFavorite,//收藏
    KKSegmentTypeConstellation,//星座
    KKSegmentTypeGoodPicture,//美图
    KKSegmentTypeChinaSinger,//中国新唱将
    KKSegmentTypeHuoShanLive,//火山直播
    KKSegmentTypeLottery,//彩票
    KKSegmentTypeHappyBoy,//快乐男声
    KKSegmentTypeGoodPower,//正能量
};

static inline NSArray *kkSegmentTitle() {
    NSArray *values = @[@"推荐",
                        @"国际",
                        @"视频",
                        @"热点",
                        @"社会",
                        @"数码",
                        @"科技",
                        @"段子",
                        @"图片",
                        @"军事",
                        @"国际社会",
                        @"汽车",
                        @"健康",
                        @"笑话",
                        @"文章",
                        @"旅游",
                        @"政务",
                        @"台湾时事",
                        @"美食",
                        @"文化",
                        @"电影",
                        @"科学",
                        @"故事",
                        @"中国好表演",
                        @"美女",
                        @"谣言",
                        @"头条号",
                        @"趣图",
                        @"问答",
                        @"体育",
                        @"精选",
                        @"语录",
                        @"小说",
                        @"娱乐",
                        @"财经",
                        @"直播",
                        @"特卖",
                        @"房产",
                        @"时尚",
                        @"历史",
                        @"育儿",
                        @"养生",
                        @"手机",
                        @"宠物",
                        @"情感",
                        @"家居",
                        @"教育",
                        @"三农",
                        @"孕产",
                        @"游戏",
                        @"股票",
                        @"动漫",
                        @"收藏",
                        @"星座",
                        @"美图",
                        @"中国新唱将",
                        @"火山直播",
                        @"彩票",
                        @"快乐男声",
                        @"正能量"
                        ];
    return values;
}

#define KKUserFavPlateData @"KKUserFavPlateData"

#endif /* KKCommonVariable_h */
