//
//  ImagePreviewViewController.h
//  NumberMe
//
//  Created by Liu Zhe on 15/9/27.
//  Copyright © 2015年 Liu Zhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePreviewControllerDelegate<NSObject>

@required

- (void)didResetBackgroundOfGameMode:(NSInteger)gameMode;

@end

@interface ImagePreviewViewController : UIViewController

@property (nonatomic, assign) id<ImagePreviewControllerDelegate> delegete;

- (instancetype)initWithImage:(UIImage *)image isOriginal:(BOOL)original andGameMode:(NSInteger)gameMode;

@end
