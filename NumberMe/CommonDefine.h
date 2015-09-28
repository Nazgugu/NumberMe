//
//  CommonDefine.h
//  jiechu
//
//  Created by xuxingdu on 14/11/3.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#ifndef jiechu_CommonDefine_h
#define jiechu_CommonDefine_h


#define IOS7_UP                ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ? YES : NO )
#define IOS8_UP                ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 ? YES : NO )
#define IOS9_UP                ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0 ? YES : NO )

#define IOS7                (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) ? YES : NO )
#define IOS7BASE (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 7.1) ? YES : NO )
#define IOS8                (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0) ? YES : NO )

#define IPHONE5             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREENWIDTH         CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT        CGRectGetHeight([UIScreen mainScreen].bounds)

#define screenBounds [[UIScreen mainScreen] bounds]

#define DEFAULT_FONT        @"STHeitiSC-Medium"
#define DEFAULT_FONT_LIGHT  @"STHeitiSC-Light"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_TRUE_6P ([UIScreen mainScreen].scale > 2.9 ? YES : NO)
#define IS_TRUE_6 ([UIScreen mainScreen].scale < 2.1 ? YES : NO)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0 && IS_TRUE_6)
#define IS_IPHONE_6P (IS_IPHONE && IS_TRUE_6P)

#define NORMBG @"normalBG"
#define INFIBG @"infinityBG"
#define LEVELBG @"levelUpBG"

#define TIPMETHOD @"tipMethod"

#define NORMSCORE @"maxNormScore"
#define INFISCORE @"maxInfiScore"
#define LVSCORE @"maxLVScore"

//#define SAFEPARAMETER(parameter)    (parameter) ? [NSString stringWithFormat:@"%@",parameter] : @""
//
//#define AMapKey @"2ad85cea7d4aabc66d779b4dbc3755b2"
//
//#define GoogleAPIKey @"AIzaSyB4BZiadVUvRiYiR-ACuHtkXY4_hCvKAaM"

////微博
//#define weiboAppKey @"4126860015"
//#define weiboSecretKey @"b943837d8d087771b4206e03695adf72"
//#define weiboRedirecURI @"http://shanghui.avosapps.com/oauth?type=weibo"
//
//#pragma mark Notification define
//#define UIActivityCircleNeedRefreshDataNotification @"UIActivityCircleNeedRefreshDataNotification"
//
//#define kUpdateActivityTypeNotificationKey @"UpdateActivityTypeNotificationKey"
//
//#define searchTypes @[@"050000",@"060000",@"070000",@"080000",@"100000",@"110000",@"120000",@"140000",@"170000"]


//#define kShangHuiActivityBackgroundImages \
//@[ \
//@"meal", \
//@"bar", \
//@"movie", \
//@"sport", \
//@"meeting", \
//@"shopping", \
//@"music", \
//@"other", \
//]
//
//#define kShangHuiActivityTypes \
//@[ \
//NSLocalizedString(@"event title dinner", @"聚餐"), \
//NSLocalizedString(@"event title drink", @"喝酒"), \
//NSLocalizedString(@"event title film", @"电影"), \
//NSLocalizedString(@"event title hightea", @"下午茶"), \
//NSLocalizedString(@"event title shopping", @"购物"), \
//NSLocalizedString(@"event title sing", @"唱歌"), \
//NSLocalizedString(@"event title sport", @"运动"), \
//NSLocalizedString(@"event title other", @"其它"), \
//]
//
//#define kShangHuiActivityPayTypes \
//@[ \
//@"2人", \
//@"6人以下", \
//@"20人以下", \
//@"不限", \
//]
//
//#define kShangHuiNewsFeedTypes \
//@[ \
//@"发表了图片", \
//@"发表了状态", \
//@"发表了图片", \
//@"参加了活动", \
//@"分享了活动", \
//]

#endif
