//
//  UUThumbnailView.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUThumbnailView : UIView

@property (nonatomic, assign) NSInteger gameMode;

@property (nonatomic, weak) UIViewController *weakSuper;

- (void)reloadView;

@end
