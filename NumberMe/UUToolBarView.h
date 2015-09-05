//
//  UUToolBarView.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

#define kNotificationUpdateSelected @"NotificationUpdateSelected"

@interface UUToolBarView : FXBlurView

- (instancetype)initWithWhiteColor;

- (instancetype)initWithBlackColor;

- (void)addPreviewTarget:(id)target action:(SEL)action;

@end
