//
//  GameModeSelectionView.m
//  
//
//  Created by Liu Zhe on 15/8/16.
//
//

#import "GameModeSelectionView.h"
#import "UIImage+ImageEffects.h"

@interface GameModeSelectionView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *bottomToolBox;

@property (nonatomic) NSInteger gameModesCount;

//game mode
@property (nonatomic, strong) NSMutableArray *gameModeImageViewArray;
@property (nonatomic, strong) NSMutableArray *gameModeLabelArray;

//pre initiate
@property (nonatomic, strong) NSMutableArray *gameModeStringArray;
@property (nonatomic, strong) NSMutableArray *gameModeImageArray;

@end

@implementation GameModeSelectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super initWithFrame:screenBounds];
    if (self)
    {
        self.opaque = YES;
        self.alpha = 1;
        self.gameModesCount = 2;
        if (!_gameModeImageViewArray)
        {
            _gameModeImageViewArray = [[NSMutableArray alloc] init];
        }
        if (!_gameModeLabelArray)
        {
            _gameModeLabelArray = [[NSMutableArray alloc] init];
        }
        if (!_gameModeStringArray)
        {
            _gameModeStringArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"NORMAL", nil),NSLocalizedString(@"CONTINUE", nil), nil];
        }
        if (!_gameModeImageArray)
        {
            _gameModeImageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"normalGame"],[UIImage imageNamed:@"continueGame"], nil];
        }
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    _backgroundView = [[UIImageView alloc] initWithFrame:screenBounds];
    _backgroundView.tag = 1;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_backgroundView addGestureRecognizer:tap];
//    UIImage *bluredImage = [[self convertViewToImage] applyBlurWithRadius:12 tintColor:[UIColor colorWithRed:0.741f green:0.765f blue:0.780f alpha:0.10f] saturationDeltaFactor:2.0f maskImage:nil];
    UIImage *bluredImage = [[self convertViewToImage] applyBlurWithRadius:12 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f] saturationDeltaFactor:1.0f maskImage:nil];
    [_backgroundView setImage:bluredImage];
    _backgroundView.alpha = 0.0f;
    [self addSubview:_backgroundView];
    
    [self setUpContainerView];
    
}

- (void)setUpContainerView;
{
    
    CGFloat horizontalGap = 15.0f;
    CGFloat topBottomGap = 10.0f;
    CGFloat gameModeWidth = ((SCREENWIDTH*7)/8 - 5 - 3 * horizontalGap)/2;
    CGFloat gameModeHeight = SCREENHEIGHT/6 - 2 *topBottomGap;
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH, (SCREENHEIGHT * 5)/12, SCREENWIDTH, SCREENHEIGHT/6)];
    _containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    _containerView.alpha = 0.0f;
    _containerView.tag = 2;
    
    _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (_containerView.frame.size.width * 7)/8, _containerView.frame.size.height)];
    [_containerScrollView setContentSize:CGSizeMake(SCREENWIDTH, _containerView.frame.size.height)];
    _containerScrollView.alwaysBounceHorizontal = YES;
    _containerScrollView.backgroundColor = [UIColor clearColor];
    [_containerView addSubview:_containerScrollView];
    
    //initiate cancel button
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_containerScrollView.frame.origin.x + _containerScrollView.frame.size.width + (_containerView.frame.size.width/8 - 14)/2, (_containerView.frame.size.height - 14)/2, 14, 14)];
    _cancelButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_cancelButton setImage:[UIImage imageNamed:@"smallClose"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_cancelButton];
    
    //need to add things to the containerscrollview
    //initialize two game modes
    
    for (int i = 0; i < _gameModesCount; i++)
    {
        UIImageView *gameModeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalGap * (i+1) + gameModeWidth*i, topBottomGap, gameModeWidth, gameModeHeight)];
        
        gameModeImageView.contentMode = UIViewContentModeScaleToFill;
        [gameModeImageView setImage:[_gameModeImageArray objectAtIndex:i]];
        UILabel *gameModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gameModeWidth, gameModeHeight)];
        gameModeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        gameModeLabel.textAlignment = NSTextAlignmentCenter;
        gameModeLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
        gameModeLabel.textColor = [UIColor whiteColor];
        gameModeLabel.adjustsFontSizeToFitWidth = YES;
        gameModeLabel.minimumScaleFactor = 0.7f;
        gameModeImageView.userInteractionEnabled = YES;
        gameModeLabel.userInteractionEnabled = YES;
        gameModeLabel.tag = i;
        UITapGestureRecognizer *selectGameMode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedGameMode:)];
        selectGameMode.numberOfTapsRequired = 1;
        selectGameMode.numberOfTouchesRequired = 1;
        [gameModeLabel addGestureRecognizer:selectGameMode];
        gameModeLabel.text = [_gameModeStringArray objectAtIndex:i];
        [gameModeImageView addSubview:gameModeLabel];
        [_containerScrollView addSubview:gameModeImageView];
        [_gameModeImageViewArray addObject:gameModeImageView];
        [_gameModeLabelArray addObject:gameModeLabel];
    }

    //continue
    [self addSubview:_containerView];
}

- (void)selectedGameMode:(UIGestureRecognizer *)touch
{
    [self dismiss];
    UILabel *label = (UILabel *)[touch view];
    if ([_delegete respondsToSelector:@selector(didSelectGameMode:)])
    {
        [_delegete didSelectGameMode:label.tag];
    }
}

- (void)show
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 1.0f;
        [self.containerView setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2)];
        self.containerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:self];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.containerView setCenter:CGPointMake(-SCREENWIDTH/2, SCREENHEIGHT/2)];
        self.containerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [UIView animateWithDuration:0.2f delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }];
}

-(UIImage *)convertViewToImage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    UIView *theView = [touch view];
//    
//    NSLog(@"view.tag = %ld",theView.tag);
//    
//    return YES;
//}

@end
