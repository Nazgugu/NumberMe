//
//  GameViewController.h
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, gameMode) {
    gameModeNormal = 0,
    gameModeInfinity = 1
};

@interface GameViewController : UIViewController

- (instancetype)initWithGameMode:(gameMode)mode;

@end
