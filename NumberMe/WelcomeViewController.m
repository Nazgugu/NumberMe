//
//  WelcomeViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//

#define URLEMail @"mailto:zheliu9328@gmail.com?subject=Bug Report and Suggestions&body="

@import GoogleMobileAds;

#import "WelcomeViewController.h"
#import "GameViewController.h"
#import "RecordViewController.h"
#import "RJBlurAlertView.h"
#import "GameModeSelectionView.h"
#import "CECrossfadeAnimationController.h"
#import "CEBaseInteractionController.h"
//#import <iAd/iAd.h>

@interface WelcomeViewController () <GameModeSelectionViewDelegate, UIViewControllerTransitioningDelegate> /*<ADBannerViewDelegate>*/
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
//@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewSpaceConstraint;
@property (weak, nonatomic) IBOutlet GADBannerView *admobBanner;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //setting up button appearance
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initializaBannerView];
    
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
    
    [_startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateNormal];
    [_recordButton setTitle:NSLocalizedString(@"RD", nil) forState:UIControlStateNormal];
    [_settingButton setTitle:NSLocalizedString(@"ST", nil) forState:UIControlStateNormal];
    
    
    
//    _adBannerView.delegate = self;
//    _adBannerView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


- (void)initializaBannerView
{
    self.admobBanner.adUnitID = @"ca-app-pub-8377978722117647/8470579418";
    self.admobBanner.rootViewController = self;
    
    self.admobBanner.adSize = kGADAdSizeSmartBannerPortrait;
    
    GADRequest *request = [GADRequest request];
    
    
    [self.admobBanner loadRequest:request];
}

- (IBAction)startGame:(id)sender {
    GameModeSelectionView *gameModeSelection = [[GameModeSelectionView alloc] init];
    gameModeSelection.delegete = self;
    [gameModeSelection show];
}

- (IBAction)showRecord:(id)sender {
    //NSLog(@"tapping record");
    RecordViewController *record = [[RecordViewController alloc] init];
    record.transitioningDelegate = self;
    [self presentViewController:record animated:YES completion:nil];
}

- (IBAction)settingTap:(id)sender {
    
    //NSLog(@"tapping");
    RJBlurAlertView *alert = [[RJBlurAlertView alloc] initWithTitle:NSLocalizedString(@"STITLE", nil) text:NSLocalizedString(@"SBODY", nil) cancelButton:YES];
    [alert.okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [alert.cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
    alert.animationType = RJBlurAlertViewAnimationTypeDrop;
    [alert setCompletionBlock:^(RJBlurAlertView *theAlert, UIButton *button) {
        if (button == theAlert.okButton)
        {
            NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [theAlert dismiss];
        }
        else
        {
            [theAlert dismiss];
        }
    }];
    [alert show];
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

//#pragma mark - iAdBanner Delegates
//
//-(void)bannerView:(ADBannerView *)banner
//didFailToReceiveAdWithError:(NSError *)error{
//    //NSLog(@"Error in Loading Banner!");
//    self.bannerViewSpaceConstraint.constant = -50;
//    self.bottomSpaceConstraint.constant = 20;
//}
//
//-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    //NSLog(@"iAd banner Loaded Successfully!");
//    [UIView animateWithDuration:1.0f animations:^{
//        _adBannerView.alpha = 1.0f;
//    }];
//}
//-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
//    //NSLog(@"iAd Banner will load!");
//}
//-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
//    //NSLog(@"iAd Banner did finish");
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
