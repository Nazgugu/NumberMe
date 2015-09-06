//
//  UUToolBarView.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

//#define kNotificationUpdateSelected @"NotificationUpdateSelected"

@protocol UUToolBarViewDelegate <NSObject>

@required
- (void)sliderValueDidChange:(CGFloat)value;

- (void)hasChoseImage;

- (void)dismiss;

@end

@interface UUToolBarView : FXBlurView

@property (nonatomic, assign) id<UUToolBarViewDelegate> delegate;

@property (nonatomic) BOOL isFromRoot;

- (instancetype)initWithWhiteColor;

- (instancetype)initWithBlackColor;

//- (void)addPreviewTarget:(id)target action:(SEL)action;

- (void)resetSlider;

@end
