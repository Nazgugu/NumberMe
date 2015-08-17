//
//  GameModeSelectionView.h
//  
//
//  Created by Liu Zhe on 15/8/16.
//
//

#import <UIKit/UIKit.h>

@protocol GameModeSelectionViewDelegate <NSObject>

@required
- (void)didSelectGameMode:(NSInteger)gameMode;

@end

@interface GameModeSelectionView : UIView

@property (nonatomic, assign) id<GameModeSelectionViewDelegate> delegete;

- (void)show;

- (void)dismiss;

@end
