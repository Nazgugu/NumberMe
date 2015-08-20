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

#define Setting_TitileArray @[@[NSLocalizedString(@"MAXNORMAL",nil),NSLocalizedString(@"MAXINFINITY",nil),NSLocalizedString(@"CLEARCACHE",nil)],@[NSLocalizedString(@"RATE",nil),NSLocalizedString(@"RECOMMEND",nil),NSLocalizedString(@"CONTACT",nil),NSLocalizedString(@"VERSION",nil)]]

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImage *blurImage;
//@property (nonatomic, strong) UIImage *navImage;
@property (weak, nonatomic) IBOutlet UITableView *settingTable;



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
    [self.settingTable reloadData];
}

- (void)createNavButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[self makeThumbnailOfSize:CGSizeMake(15, 15) andImage:[UIImage imageNamed:@"close"]] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    barButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)setNavigationBarStyle
{
    [[UINavigationBar appearance] setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.055f green:0.196f blue:0.341f alpha:0.3f]];
    //[self.navigationController.navigationBar setBackgroundImage:[self imageFromRect:CGRectMake(0, 0, SCREENWIDTH, self.navigationController.navigationBar.frame.size.height) andImage:_blurImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UIColor whiteColor] colorWithAlphaComponent:0.9f], NSForegroundColorAttributeName, [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f], NSFontAttributeName,nil]];
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
        return 3;
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
    NSLog(@"cell text = %@",Setting_TitileArray[indexPath.section][indexPath.row]);
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
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"rate"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 1:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"recommend"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 2:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"contact"]];
                [cell.imageView setImage:icon];
            }
                break;
            case 3:
            {
                UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"gear"]];
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.imageView setImage:icon];
                cell.detailTextLabel.text = @"V 1.1";
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
                    [[EGOCache globalCache] clearCache];
                    [self.settingTable reloadData];
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
                
            }
                break;
            case 2:
            {
                NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
