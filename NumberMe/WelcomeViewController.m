//
//  WelcomeViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//



@import GoogleMobileAds;

#import "WelcomeViewController.h"
#import "GameViewController.h"
#import "RecordViewController.h"
#import "RJBlurAlertView.h"
#import "GameModeSelectionView.h"
#import "CECrossfadeAnimationController.h"
#import "CEBaseInteractionController.h"
#import "SettingViewController.h"
#import "UIImage+ImageEffects.h"
#import "GTScrollNavigationBar.h"
#import "ARTransitionAnimator.h"
//#import "UIView+Shimmer.h"
#import <iAd/iAd.h>
#import "UUPhotoActionSheet.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"


@interface WelcomeViewController () <GameModeSelectionViewDelegate, UIViewControllerTransitioningDelegate, ADBannerViewDelegate, UUPhotoActionSheetDelegate>
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

@end

@implementation WelcomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //setting up button appearance
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self initializaBannerView];
    
    _transitionAnimator = [[ARTransitionAnimator alloc] init];
    _transitionAnimator.transitionDuration = 0.3;
    _transitionAnimator.transitionStyle = ARTransitionStyleMaterial;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _topSpaceToTitle.constant = 60;
    }
    
    _startButton.layer.borderWidth = 1.0f;
    _settingButton.layer.borderWidth = 1.0f;
    _recordButton.layer.borderWidth = 1.0f;
    _startButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _settingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _startButton.layer.cornerRadius = 15.0f;
    _recordButton.layer.cornerRadius = 15.0f;
    _settingButton.layer.cornerRadius = 15.0f;
    _settingButton.layer.masksToBounds = YES;
    _recordButton.layer.masksToBounds = YES;
    _startButton.layer.masksToBounds = YES;
    
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
            [_settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
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
    RecordViewController *record = [[RecordViewController alloc] init];
    record.modalPresentationStyle = UIModalPresentationCustom;
    record.transitioningDelegate = _transitionAnimator;
    //record.transitioningDelegate = self;
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
    
    SettingViewController *setting = [[SettingViewController alloc] initWithImage:[[self convertViewToImage] applyBlurWithRadius:12 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f] saturationDeltaFactor:1.0f maskImage:nil]];
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    [nav setViewControllers:@[setting] animated:NO];
//    nav.transitioningDelegate = self;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.transitioningDelegate = _transitionAnimator;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)openSheet:(NSNotification *)notif
{
    [_sheet showAnimation];
}

- (void)actionSheetDidFinished:(NSArray *)obj{
    
    NSLog(@"已发送 %lu 图片",(unsigned long)obj.count);
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
    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:gameMode];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    CECrossfadeAnimationController *crossFade = [[CECrossfadeAnimationController alloc] init];
    crossFade.duration = 0.3f;
    crossFade.reverse = NO;
    
    return crossFade;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    CECrossfadeAnimationController *crossFade = [[CECrossfadeAnimationController alloc] init];
    crossFade.duration = 0.3f;
    crossFade.reverse = YES;
    
    return crossFade;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
