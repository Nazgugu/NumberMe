//
//  SettingViewController.m
//  
//
//  Created by Liu Zhe on 15/8/19.
//
//

#define URLEMail @"mailto:zheliu9328@gmail.com?subject=Bug Report and Suggestions&body="

#import "SettingViewController.h"
#import "EGOCache.h"
#import "RJBlurAlertView.h"
//#import "UIView+Shimmer.h"
#import "GTScrollNavigationBar.h"
#import "DOPScrollableActionSheet.h"
#import "OpenShareHeader.h"
#import <MessageUI/MessageUI.h>

#define Setting_TitileArray @[@[NSLocalizedString(@"MAXNORMAL",nil),NSLocalizedString(@"MAXINFINITY",nil),NSLocalizedString(@"MAXLEVEL",nil),NSLocalizedString(@"CLEARCACHE",nil)],@[NSLocalizedString(@"RATE",nil),NSLocalizedString(@"RECOMMEND",nil),NSLocalizedString(@"CONTACT",nil),NSLocalizedString(@"VERSION",nil)]]

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImage *blurImage;
//@property (nonatomic, strong) UIImage *navImage;
@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@property (nonatomic, strong) NSArray *shareAction;

//@property (nonatomic, strong) NSString *recommandURLString;
//
//@property (nonatomic, strong) NSString *smsURLString;

@end

@implementation SettingViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        _blurImage = image;
        self.title = NSLocalizedString(@"STITLE", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarStyle];
    [self createNavButton];
    // Do any additional setup after loading the view from its nib.
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    _settingTable.backgroundColor = [UIColor clearColor];
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:self.settingTable.frame];
    backGroundImage.contentMode = UIViewContentModeScaleToFill;
    [backGroundImage setImage:_blurImage];
    _settingTable.backgroundView = backGroundImage;
    //_settingTable.opaque = NO;
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    
    
//    NSString* body = @"https%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Ffour4%2Fid1030279451%3Fl%3Dzh%26ls%3D1%26mt%3D8";
//    
//    _recommandURLString = @"mailto:?subject=";
//    _recommandURLString = [_recommandURLString stringByAppendingString:NSLocalizedString(@"GGAME", nil)];
//    _recommandURLString = [_recommandURLString stringByAppendingString:@"&body="];
//    _recommandURLString = [_recommandURLString stringByAppendingString:NSLocalizedString(@"SHARENOURL", nil)];
//    _recommandURLString = [_recommandURLString stringByAppendingString:body];
    
//    NSLog(@"%@",URLEMail);
//    NSLog(@"%@",_recommandURLString);
    
//    _smsURLString = NSLocalizedString(@"SHAREMSG", nil);
//    NSString *url = @"https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
//    _smsURLString = [_smsURLString stringByAppendingFormat:@"\n%@",url];
    
    [self initShareAction];
    [self.settingTable reloadData];
}

- (void)dealloc
{
    //[self stopShimmer];
}

//- (void)stopShimmer
//{
//    UITableViewCell *cell1 = [_settingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UITableViewCell *cell2 = [_settingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    [cell1 stopShimmering];
//    [cell2 stopShimmering];
//}

- (void)initShareAction
{
    //share
    DOPAction *shareWechatFriend = [[DOPAction alloc] initWithName:NSLocalizedString(@"FRIEND", nil) iconName:@"friend" handler:^{
        [self shareViaWeChatFriend];
    }];
    
    DOPAction *shareWechatCircle = [[DOPAction alloc] initWithName:NSLocalizedString(@"CIRCLE", nil) iconName:@"circle" handler:^{
        [self shareViaWeChatCircle];
    }];
    
    DOPAction *shareWeibo = [[DOPAction alloc] initWithName:NSLocalizedString(@"WEIBO", nil) iconName:@"weibo" handler:^{
        [self shareViaWeibo];
    }];
    
    DOPAction *shareMSG = [[DOPAction alloc] initWithName:NSLocalizedString(@"MSG", nil) iconName:@"msg" handler:^{
        [self shareViaSMS];
    }];
    
    DOPAction *shareEmail = [[DOPAction alloc] initWithName:NSLocalizedString(@"EMAIL", nil) iconName:@"email" handler:^{
        [self shareViaEmail];
    }];
    
    if ([OpenShare isWeiboInstalled] && [OpenShare isWeixinInstalled])
    {
        _shareAction = @[@"",@[shareWechatFriend, shareWechatCircle, shareWeibo, shareMSG, shareEmail]];
    }
    else if ([OpenShare isWeixinInstalled] && ![OpenShare isWeiboInstalled])
    {
        _shareAction = @[@"",@[shareWechatFriend, shareWechatCircle, shareMSG, shareEmail]];
    }
    else if (![OpenShare isWeixinInstalled] && [OpenShare isWeiboInstalled])
    {
        _shareAction = @[@"",@[shareWeibo, shareMSG, shareEmail]];
    }
    else if (![OpenShare isWeiboInstalled] && ![OpenShare isWeixinInstalled])
    {
        _shareAction = @[@"",@[shareMSG, shareEmail]];
    }
}

- (void)createNavButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[self makeThumbnailOfSize:CGSizeMake(15, 15) andImage:[UIImage imageNamed:@"close"]] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    barButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)setNavigationBarStyle
{
    if (IOS8_UP)
    {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    else
    {
        self.navigationController.navigationBar.translucent = YES;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor lightTextColor] colorWithAlphaComponent:0.5f]] forBarMetrics:UIBarMetricsDefault];

        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.055f green:0.196f blue:0.341f alpha:0.3f]];
        //[self.navigationController.navigationBar setBackgroundImage:[self imageFromRect:CGRectMake(0, 0, SCREENWIDTH, self.navigationController.navigationBar.frame.size.height) andImage:_blurImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UIColor whiteColor] colorWithAlphaComponent:0.9f], NSForegroundColorAttributeName, [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f], NSFontAttributeName,nil]];
    self.navigationController.scrollNavigationBar.scrollView = _settingTable;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//convenient method
//- (UIImage *)imageFromRect:(CGRect)rect andImage:(UIImage *)image
//{
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return croppedImage;
//}

- (void)shareViaSMS
{
    //NSLog(@"called");
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
//        NSLog(@"can send");
        controller.body = NSLocalizedString(@"SHAREMSG", nil);
        controller.delegate = self;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)shareViaEmail
{
//    NSString *url = [_recommandURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail])
    {
        [controller setSubject:NSLocalizedString(@"GGAME", nil)];
        [controller setMessageBody:NSLocalizedString(@"SHAREMSG", nil) isHTML:YES];
        controller.delegate = self;
        controller.mailComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)shareViaWeChatCircle
{
    OSMessage *message = [[OSMessage alloc] init];
    message.title = @"这个游戏简直停不下来，太有意思了";
    message.link = @"https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    message.image = UIImageJPEGRepresentation([UIImage imageNamed:@"icon"], 0.5f);
    //message.thumbnail = UIImagePNGRepresentation([self getScreenshot]);
    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}

- (void)shareViaWeChatFriend
{
    OSMessage *message = [[OSMessage alloc] init];
    message.title = @"这个游戏简直停不下来，太有意思了";
    message.link = @"https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    message.image = UIImageJPEGRepresentation([UIImage imageNamed:@"icon"], 0.5f);
    //message.thumbnail = UIImagePNGRepresentation([self getScreenshot]);
    [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}

- (void)shareViaWeibo
{
    OSMessage *message = [[OSMessage alloc] init];
    message.title = @"这个游戏简直停不下来，太有意思了,下载:https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    message.image = UIImageJPEGRepresentation([UIImage imageNamed:@"icon"], 0.5f);
    //message.link = @"https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 4;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"SCTITLE1", nil);
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"SCTITLE2", nil);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:13.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    cell.textLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:14.0f];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:14.0f];
    //NSLog(@"cell text = %@",Setting_TitileArray[indexPath.section][indexPath.row]);
    cell.textLabel.text = Setting_TitileArray[indexPath.section][indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"succeed"]];
                [cell.imageView setImage:icon];
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([[EGOCache globalCache] hasCacheForKey:@"maxNormalScore"])
                {
                    cell.detailTextLabel.text = [[EGOCache globalCache] stringForKey:@"maxNormalScore"];
                }
                else
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"NORECORD", nil);
                }
            }
                break;
            case 1:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"achievement"]];
                [cell.imageView setImage:icon];
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([[EGOCache globalCache] hasCacheForKey:@"maxInfinityScore"])
                {
                    cell.detailTextLabel.text = [[EGOCache globalCache] stringForKey:@"maxInfinityScore"];
                }
                else
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"NORECORD", nil);
                }
            }
                break;
            case 2:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"level"]];
                [cell.imageView setImage:icon];
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([[EGOCache globalCache] hasCacheForKey:@"maxLevelScore"])
                {
                    cell.detailTextLabel.text = [[EGOCache globalCache] stringForKey:@"maxLevelScore"];
                }
                else
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"NORECORD", nil);
                }
            }
                break;
            case 3:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"clear"]];
                [cell.imageView setImage:icon];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(23, 23) andImage:[UIImage imageNamed:@"rate"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 1:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(23, 23) andImage:[UIImage imageNamed:@"recommend"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 2:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(23, 23) andImage:[UIImage imageNamed:@"contact"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 3:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(23, 23) andImage:[UIImage imageNamed:@"gear"]];
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.imageView setImage:icon];
                cell.detailTextLabel.text = @"v 1.2.0";
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
            RJBlurAlertView *alert = [[RJBlurAlertView alloc] initWithTitle:NSLocalizedString(@"CAUTION", nil) text:NSLocalizedString(@"WARNING", nil) cancelButton:YES];
            [alert.okButton setTitle:NSLocalizedString(@"SURE", nil) forState:UIControlStateNormal];
            [alert.cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
            alert.animationType = RJBlurAlertViewAnimationTypeDrop;
        alert.okButton.backgroundColor = [UIColor colorWithRed:0.882f green:0.282f blue:0.227f alpha:1.00f];
        alert.cancelButton.backgroundColor = [UIColor colorWithRed:0.012f green:0.635f blue:0.914f alpha:1.00f];
            [alert setCompletionBlock:^(RJBlurAlertView *theAlert, UIButton *button) {
                if (button == theAlert.okButton)
                {
                    UIImage *norm, *infi, *level;
                    if ([[EGOCache globalCache] hasCacheForKey:NORMBG])
                    {
                        norm = [[EGOCache globalCache] imageForKey:NORMBG];
                    }
                    if ([[EGOCache globalCache] hasCacheForKey:INFIBG])
                    {
                        infi = [[EGOCache globalCache] imageForKey:INFIBG];
                    }
                    if ([[EGOCache globalCache] hasCacheForKey:LEVELBG])
                    {
                        level = [[EGOCache globalCache] imageForKey:LEVELBG];
                    }
                    [[EGOCache globalCache] clearCache];
                    [self.settingTable reloadData];
                    NSData *normalGameData = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
                    [[EGOCache globalCache] setData:normalGameData forKey:@"normalGames"];
                    NSData *infinity = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
                    [[EGOCache globalCache] setData:infinity forKey:@"infinityGames"];
                    NSData *levelGames = [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray new]];
                    [[EGOCache globalCache] setData:levelGames forKey:@"levelGames"];
                    if (norm)
                    {
                        [[EGOCache globalCache] setImage:norm forKey:NORMBG];
                    }
                    if (infi)
                    {
                        [[EGOCache globalCache] setImage:infi forKey:INFIBG];
                    }
                    if (level)
                    {
                        [[EGOCache globalCache] setImage:level forKey:LEVELBG];
                    }
                }
            }];
            [alert show];

    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/numberme-chanllenge-your-mind/id1030279451?l=zh&ls=1&mt=8"]];
            }
                break;
            case 1:
            {
                DOPScrollableActionSheet *share = [[DOPScrollableActionSheet alloc] initWithActionArray:_shareAction];
                [share show];
                
            }
                break;
            case 2:
            {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                if ([MFMailComposeViewController canSendMail])
                {
                    [controller setSubject:NSLocalizedString(@"Bug Report and Suggestions", nil)];
//                    [controller setMessageBody:NSLocalizedString(@"SHAREMSG", nil) isHTML:YES];
                    [controller setToRecipients:@[@"zheliu9328@gmail.com"]];
                    controller.delegate = self;
                    controller.mailComposeDelegate = self;
                    [self presentViewController:controller animated:YES completion:nil];
                }

            }
                break;
            default:
                break;
        }
    }
}

- (UIImage *) makeThumbnailOfSize:(CGSize)size andImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    // draw scaled image into thumbnail context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
}

#pragma mark - MessageControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultFailed:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
