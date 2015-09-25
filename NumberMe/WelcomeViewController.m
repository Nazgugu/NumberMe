//
//  WelcomeViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//



//@import GoogleMobileAds;

#import "WelcomeViewController.h"
#import "GameViewController.h"
#import "RecordViewController.h"
#import "RJBlurAlertView.h"
#import "GameModeSelectionView.h"
//#import "CECrossfadeAnimationController.h"
//#import "CEBaseInteractionController.h"
#import "SettingViewController.h"
#import "UIImage+ImageEffects.h"
#import "GTScrollNavigationBar.h"
#import "ARTransitionAnimator.h"
//#import "UIView+Shimmer.h"
#import <iAd/iAd.h>
#import "UUPhotoActionSheet.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"

#import "EGOCache.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"

#import "ZFModalTransitionAnimator.h"

#import "GameCenterManager.h"

#import "MLKMenuPopover.h"

@interface WelcomeViewController () <GameModeSelectionViewDelegate, ADBannerViewDelegate, UUPhotoActionSheetDelegate, UUPhotoBrowserDelegate, RZTransitionInteractionControllerDelegate, GameCenterManagerDelegate, MLKMenuPopoverDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewSpaceConstraint;
//@property (weak, nonatomic) IBOutlet GADBannerView *admobBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (nonatomic, strong) ARTransitionAnimator *transitionAnimator;
@property (nonatomic, strong) UUPhotoActionSheet *sheet;
@property(nonatomic,strong) MLKMenuPopover *menuPopover;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSpace;

@property (weak, nonatomic) IBOutlet UIButton *gameCenterButton;

@property (nonatomic, assign) NSInteger gameMode;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@property (nonatomic, strong) UIImage *capturedImage;

@property (nonatomic, assign) BOOL wantToLogin;

@property (nonatomic, strong) NSMutableArray *highestScores;

@end

@implementation WelcomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _wantToLogin = NO;
    // Do any additional setup after loading the view from its nib.
    //setting up button appearance
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self initializaBannerView];
    
    if ([[GameCenterManager sharedManager] isInternetAvailable])
    {
        if (![[GameCenterManager sharedManager] isGameCenterAvailable])
        {
            _gameCenterButton.hidden = YES;
        }
        else
        {
            _gameCenterButton.hidden = NO;
            [[GameCenterManager sharedManager] syncGameCenter];
        }
    }
    else
    {
        _gameCenterButton.hidden = YES;
    }
    
    _gameCenterButton.layer.cornerRadius = _gameCenterButton.frame.size.height / 2;
    _gameCenterButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _gameCenterButton.layer.masksToBounds = YES;
    
    _transitionAnimator = [[ARTransitionAnimator alloc] init];
    _transitionAnimator.transitionDuration = 0.3;
    _transitionAnimator.transitionStyle = ARTransitionStyleMaterial;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _topSpaceToTitle.constant = 60;
    }
    
//    _startButton.layer.borderWidth = 1.0f;
//    _settingButton.layer.borderWidth = 1.0f;
//    _recordButton.layer.borderWidth = 1.0f;
//    _startButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    _recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    _settingButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    _startButton.layer.cornerRadius = 15.0f;
//    _recordButton.layer.cornerRadius = 15.0f;
//    _settingButton.layer.cornerRadius = 15.0f;
//    _settingButton.layer.masksToBounds = YES;
//    _recordButton.layer.masksToBounds = YES;
//    _startButton.layer.masksToBounds = YES;
    
    _startButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    _recordButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    _settingButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _firstSpace.constant = 20;
        _secondSpace.constant = 20;
        _startButtonHeight.constant = 40;
        _recordButtonHeight.constant = 40;
        _settingButtonHeight.constant = 40;
    }
    else if (IS_IPHONE_5)
    {
        _firstSpace.constant = 24;
        _secondSpace.constant = 24;
        _startButtonHeight.constant = 42;
        _recordButtonHeight.constant = 42;
        _settingButtonHeight.constant = 42;
    }
    else if (IS_IPHONE_6)
    {
        _firstSpace.constant = 28;
        _secondSpace.constant = 28;
        _startButtonHeight.constant = 48;
        _recordButtonHeight.constant = 48;
        _settingButtonHeight.constant = 48;
    }
    else if (IS_IPHONE_6P)
    {
        _firstSpace.constant = 30;
        _secondSpace.constant = 30;
        _startButtonHeight.constant = 55;
        _recordButtonHeight.constant = 55;
        _settingButtonHeight.constant = 55;
    }
    
    NSArray *langArr = [NSLocale  preferredLanguages];
    NSString *firstLang = [langArr firstObject];
    
    
    [_startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateNormal];
    [_startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateHighlighted];
    
    [_recordButton setTitle:NSLocalizedString(@"RD", nil) forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"stat"] forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"stat"] forState:UIControlStateHighlighted];
    
    [_settingButton setTitle:NSLocalizedString(@"ST", nil) forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateHighlighted];
    
    if ([firstLang isEqualToString:@"zh-Hans"])
    {
            [_startButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
            [_recordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
            [_settingButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];

            [_startButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
            [_recordButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
            [_settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 0)];
    }
    else
    {
            [_startButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            [_recordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
            [_settingButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
            
            [_startButton setImageEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
            [_recordButton setImageEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
            [_settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 0)];
    }
    
    UIImageView *hammerView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 5, 11, 11)];
    hammerView.layer.cornerRadius = hammerView.frame.size.height / 2;
    hammerView.layer.masksToBounds = YES;
    hammerView.alpha = 0.6f;
    hammerView.contentMode = UIViewContentModeScaleToFill;
    hammerView.backgroundColor = [UIColor clearColor];
    [hammerView setImage:[UIImage imageNamed:@"craft"]];
    
    [_creditLabel addSubview:hammerView];
    
    _adBannerView.delegate = self;
    _adBannerView.alpha = 0;
    
    _sheet = [[UUPhotoActionSheet alloc] initWithMaxSelected:1
                                                   weakSuper:self];
    
    _sheet.delegate = self;
    
    [self.view addSubview:_sheet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSheet:) name:@"openSheet" object:nil];
    
    id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZZoomAlphaAnimationController alloc] init];
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
    
    [[GameCenterManager sharedManager] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

//- (void)initializaBannerView
//{
//    self.admobBanner.adUnitID = @"ca-app-pub-8377978722117647/8470579418";
//    self.admobBanner.rootViewController = self;
//    
//    self.admobBanner.adSize = kGADAdSizeSmartBannerPortrait;
//    
//    GADRequest *request = [GADRequest request];
//    
//    
//    [self.admobBanner loadRequest:request];
//}

- (IBAction)startGame:(id)sender {
    GameModeSelectionView *gameModeSelection = [[GameModeSelectionView alloc] init];
    gameModeSelection.delegete = self;
    [gameModeSelection show];
}

- (IBAction)showRecord:(id)sender {
    //NSLog(@"tapping record");
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    RecordViewController *record = [[RecordViewController alloc] init];
    [record setTransitioningDelegate:[RZTransitionsManager shared]];    //record.transitioningDelegate = self;
    [self presentViewController:record animated:YES completion:nil];
}

- (IBAction)settingTap:(id)sender {
    
    //NSLog(@"tapping");
//    RJBlurAlertView *alert = [[RJBlurAlertView alloc] initWithTitle:NSLocalizedString(@"STITLE", nil) text:NSLocalizedString(@"SBODY", nil) cancelButton:YES];
//    [alert.okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
//    [alert.cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
//    alert.animationType = RJBlurAlertViewAnimationTypeDrop;
//    [alert setCompletionBlock:^(RJBlurAlertView *theAlert, UIButton *button) {
//        if (button == theAlert.okButton)
//        {
//            NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            [theAlert dismiss];
//        }
//        else
//        {
//            [theAlert dismiss];
//        }
//    }];
//    [alert show];
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    SettingViewController *setting = [[SettingViewController alloc] initWithImage:[[self convertViewToImage] applyBlurWithRadius:12 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f] saturationDeltaFactor:1.0f maskImage:nil]];
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    [nav setViewControllers:@[setting] animated:NO];
    [nav setTransitioningDelegate:[RZTransitionsManager shared]];
//    nav.transitioningDelegate = self;
//    nav.modalPresentationStyle = UIModalPresentationCustom;
//    nav.transitioningDelegate = _transitionAnimator;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)gameCenterLogin:(id)sender {
    _wantToLogin = YES;
//    if (![[GameCenterManager sharedManager] localPlayerData])
//    {
//        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
//            if (viewController != nil)
//            {
//                [self presentViewController:viewController animated:YES completion:nil];
//            }
//            else if (!error)
//            {
//                NSLog(@"succeed");
//                [self initUserInfo];
//            }
//        };
//    }
    if ([[GameCenterManager sharedManager] isGameCenterAvailable])
    {
        if ([[GameCenterManager sharedManager] localPlayerData])
        {
//            [self retrieveScores];
//            [self showPopOver];
            [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
        }
    }
}

- (void)showPopOver
{
   if (_menuPopover)
   {
       [self.menuPopover dismissMenuPopover];
   }
    _menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(SCREENWIDTH - 11 - 30 - 100, 65, 140, 90) menuItems:_highestScores];
    self.menuPopover.menuPopoverDelegate = self;
    [self.menuPopover showInView:self.view];
}

- (void)openSheet:(NSNotification *)notif
{
    _sheet.gameMode = [[[notif userInfo] objectForKey:@"gameMode"] integerValue];
    [_sheet showAnimation];
}

- (void)actionSheetDidFinished:(NSArray *)obj andGameMode:(NSInteger)gameMode{
    
    _capturedImage = [obj firstObject];
    UUPhotoBrowserViewController *controller;
    controller = [[UUPhotoBrowserViewController alloc] init];
    controller.gameMode = gameMode;
    controller.delegate = self;
    controller.isFromRoot = YES;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Custom Deledate

- (UIImage *)displayImageWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser{
    
    //    if (_isPreview) return [[UUAssetManager sharedInstance] getImagePreviewAtIndex:index type:2];
    
    return _capturedImage;
}

- (NSInteger)numberOfPhotosFromPhotoBrowser:(UUPhotoBrowserViewController *)browser{
    
    //    if (_isPreview) return [UUAssetManager sharedInstance].selectdPhotos.count;
    
    return 1;
}

//- (BOOL)isSelectedPhotosWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser{
//
//    if (_isPreview) return [[UUAssetManager sharedInstance] isSelectdPreviewWithIndex:index];
//
//    return [[UUAssetManager sharedInstance] isSelectdPhotosWithIndex:index];
//}

- (NSInteger)jumpIndexFromPhotoBrowser:(UUPhotoBrowserViewController *)browser{
    
    return 0;
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

#pragma mark - GameModeSelectionViewDelegate
- (void)didSelectGameMode:(NSInteger)gameMode
{
    _gameMode = gameMode;
    
    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:_gameMode];
    gameVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:gameVC];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    
    gameVC.transitioningDelegate = self.animator;
    
    [self presentViewController:gameVC animated:YES completion:nil];
    
//    [self performSelector:@selector(beginGameOfMode) withObject:nil afterDelay:0.2f];
}

//- (void)beginGameOfMode
//{
//    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:_gameMode];
//    gameVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    
//    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:gameVC];
//    self.animator.dragable = YES;
//    self.animator.bounces = NO;
//    self.animator.behindViewAlpha = 0.5f;
//    self.animator.behindViewScale = 0.5f;
//    self.animator.transitionDuration = 0.7f;
//    self.animator.direction = ZFModalTransitonDirectionBottom;
//    
//    gameVC.transitioningDelegate = self.animator;
//    
//    [self presentViewController:gameVC animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    CECrossfadeAnimationController *crossFade = [[CECrossfadeAnimationController alloc] init];
//    crossFade.duration = 0.3f;
//    crossFade.reverse = NO;
//    
//    return crossFade;
//}

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    CECrossfadeAnimationController *crossFade = [[CECrossfadeAnimationController alloc] init];
//    crossFade.duration = 0.3f;
//    crossFade.reverse = YES;
//    
//    return crossFade;
//}

#pragma mark - iAdBanner Delegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error in Loading Banner!");
    self.bannerViewSpaceConstraint.constant = -50;
    self.bottomSpaceConstraint.constant = 20;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //NSLog(@"iAd banner Loaded Successfully!");
    [UIView animateWithDuration:1.0f animations:^{
        _adBannerView.alpha = 1.0f;
    }];
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd Banner will load!");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"iAd Banner did finish");
    
}

#pragma mark - GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    if (_wantToLogin)
    {
        [self presentViewController:gameCenterLoginController animated:YES completion:^{
            NSLog(@"Finished Presenting Authentication Controller");
        }];
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
//    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        [self.navigationController.navigationBar setValue:@"GameCenter Available" forKeyPath:@"prompt"];
    } else {
        [self.navigationController.navigationBar setValue:@"GameCenter Unavailable" forKeyPath:@"prompt"];
    }
    
    GKLocalPlayer *player = [[GameCenterManager sharedManager] localPlayerData];
    if (player) {
        if ([player isUnderage] == NO) {
//            [self retrieveScores];
            NSLog(@"not under age");
                [[GameCenterManager sharedManager] localPlayerPhoto:^(UIImage *playerPhoto) {
                    _gameCenterButton.hidden = NO;
                    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [_gameCenterButton setImage:playerPhoto forState:UIControlStateNormal];
                    } completion:nil];
                }];
            
            
        } else {
            NSLog(@"player under age");
        }
    }
    else {
    }
}

- (void)retrieveScores
{
    if (!_highestScores)
    {
        _highestScores = [[NSMutableArray alloc] init];
    }
    NSString *normScore, *infiScore, *lvScore;
    
    NSLog(@"high norm = %d",[[GameCenterManager sharedManager] highScoreForLeaderboard:NORMSCORE]);
    
    if ([[GameCenterManager sharedManager] highScoreForLeaderboard:NORMSCORE])
    {
        normScore = [NSString stringWithFormat:NSLocalizedString(@"MAXNORMALI", nil), [[GameCenterManager sharedManager] highScoreForLeaderboard:NORMSCORE]];
    }
    else
    {
        normScore = NSLocalizedString(@"MAXNORMALN", nil);
    }
    
    if ([[GameCenterManager sharedManager] highScoreForLeaderboard:INFISCORE])
    {
        infiScore = [NSString stringWithFormat:NSLocalizedString(@"MAXINFINITYI", nil), [[GameCenterManager sharedManager] highScoreForLeaderboard:INFISCORE]];
    }
    else
    {
        infiScore = NSLocalizedString(@"MAXINFINITYN", nil);
    }
    
    if ([[GameCenterManager sharedManager] highScoreForLeaderboard:LVSCORE])
    {
        lvScore = [NSString stringWithFormat:NSLocalizedString(@"MAXLEVELI", nil), [[GameCenterManager sharedManager] highScoreForLeaderboard:LVSCORE]];
    }
    else
    {
        lvScore = NSLocalizedString(@"MAXLEVELN", nil);
    }
    
    [_highestScores removeAllObjects];
    
    [_highestScores addObject:normScore];
    [_highestScores addObject:infiScore];
    [_highestScores addObject:lvScore];
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
