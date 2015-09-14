//
//  BackgrondTabelViewController.m
//  
//
//  Created by Liu Zhe on 15/9/7.
//
//

#import "BackgrondTabelViewController.h"
#import "EGOCache.h"
#import "JGProgressHUD.h"
#import "CBStoreHouseTransition.h"

#define gameModeTitle @[NSLocalizedString(@"NORMAL",nil), NSLocalizedString(@"CONTINUE",nil), NSLocalizedString(@"LEVEL",nil)]

@interface BackgrondTabelViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITableView *backgroundTableView;

@property (nonatomic, strong) UIImage *blurImage;

@property (nonatomic) CGFloat rowHeight;

@property (nonatomic, strong) JGProgressHUD *reset;

@property (nonatomic, strong) CBStoreHouseTransitionAnimator *animator;
@property (nonatomic, strong) CBStoreHouseTransitionInteractiveTransition *interactiveTransition;

@end

@implementation BackgrondTabelViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        _blurImage = image;
        self.title = NSLocalizedString(@"GBG", nil);
        _rowHeight = 76.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_backgroundTableView];
    
    // Do any additional setup after loading the view from its nib.
    _backgroundTableView.backgroundColor = [UIColor clearColor];
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:self.backgroundTableView.frame];
    _backgroundTableView.contentMode = UIViewContentModeScaleToFill;
    [backGroundImage setImage:_blurImage];
    _backgroundTableView.backgroundView = backGroundImage;
    //_settingTable.opaque = NO;
    _backgroundTableView.delegate = self;
    _backgroundTableView.dataSource = self;
    _backgroundTableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationController.delegate = self;
    
    [self initTransition];
}

- (void)initTransition
{
    self.animator = [[CBStoreHouseTransitionAnimator alloc] init];
    self.interactiveTransition = [[CBStoreHouseTransitionInteractiveTransition alloc] init];
    [self.interactiveTransition attachToViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"backgroundCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"backgroundCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    cell.textLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.text = gameModeTitle[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, 5, 40, _rowHeight - 10)];
    bgImage.tag = -1;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, (_rowHeight - 16) / 2, 40, 16)];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithRed:0.871f green:0.157f blue:0.125f alpha:1.00f].CGColor;
    button.layer.cornerRadius = 7.0f;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor colorWithRed:0.871f green:0.157f blue:0.125f alpha:1.00f] forState:UIControlStateNormal];
     [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:12.0f];
    button.tag = indexPath.row;
    [button setTitle:NSLocalizedString(@"RST", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"RST", nil) forState:UIControlStateDisabled];
    
    [button addTarget:self action:@selector(resetBackground:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (indexPath.row) {
        case 0:
        {
            UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"succeed"]];
            [cell.imageView setImage:icon];
            if ([[EGOCache globalCache] hasCacheForKey:NORMBG])
            {
                [bgImage setImage:[[EGOCache globalCache] imageForKey:NORMBG]];
            }
            else
            {
                button.enabled = NO;
                [bgImage setImage:[UIImage imageNamed:@"GBGNORM"]];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
            break;
        case 1:
        {
            UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"achievement"]];
            [cell.imageView setImage:icon];
            if ([[EGOCache globalCache] hasCacheForKey:INFIBG])
            {
                [bgImage setImage:[[EGOCache globalCache] imageForKey:INFIBG]];
            }
            else
            {
                button.enabled = NO;
                [bgImage setImage:[UIImage imageNamed:@"GBGINFI"]];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
            break;
        case 2:
        {
            UIImage *icon = [self makeThumbnailOfSize:CGSizeMake(25, 25) andImage:[UIImage imageNamed:@"level"]];
            [cell.imageView setImage:icon];
            if ([[EGOCache globalCache] hasCacheForKey:LEVELBG])
            {
                [bgImage setImage:[[EGOCache globalCache] imageForKey:LEVELBG]];
            }
            else
            {
                button.enabled = NO;
                [bgImage setImage:[UIImage imageNamed:@"GBGLV"]];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
            break;
        default:
            break;
    }
    
    [cell.contentView addSubview:button];
    [cell.contentView addSubview:bgImage];
    
    return cell;
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

- (void)resetBackground:(UIButton *)button
{
    if (!_reset)
    {
        _reset = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        _reset.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    }
    
    UITableViewCell *cell = [_backgroundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    switch (button.tag) {
        case 0:
        {
            _reset.textLabel.text = NSLocalizedString(@"RSTNORM", nil);
            [_reset showInView:self.view];
            [_reset dismissAfterDelay:0.5f];
            [[EGOCache globalCache] removeCacheForKey:NORMBG];
            for (UIView *view in cell.contentView.subviews)
            {
                if (view.tag == -1)
                {
                    UIImageView *bgImage = (UIImageView *)view;
                    [UIView transitionWithView:bgImage duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [bgImage setImage:[UIImage imageNamed:@"GBGNORM"]];
                    } completion:^(BOOL finished) {
                        
                    }];
                    break;
                }
            }
        }
            break;
        case 1:
        {
            _reset.textLabel.text = NSLocalizedString(@"RSTINFI", nil);
            [_reset showInView:self.view];
            [_reset dismissAfterDelay:0.5f];
            [[EGOCache globalCache] removeCacheForKey:INFIBG];
            for (UIView *view in cell.contentView.subviews)
            {
                if (view.tag == -1)
                {
                    UIImageView *bgImage = (UIImageView *)view;
                    [UIView transitionWithView:bgImage duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [bgImage setImage:[UIImage imageNamed:@"GBGINFI"]];
                    } completion:^(BOOL finished) {
                        
                    }];
                    break;
                }
            }
        }
            break;
        case 2:
        {
            _reset.textLabel.text = NSLocalizedString(@"RSTLV", nil);
            [_reset showInView:self.view];
            [_reset dismissAfterDelay:0.5f];
            [[EGOCache globalCache] removeCacheForKey:LEVELBG];
            for (UIView *view in cell.contentView.subviews)
            {
                if (view.tag == -1)
                {
                    UIImageView *bgImage = (UIImageView *)view;
                    [UIView transitionWithView:bgImage duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [bgImage setImage:[UIImage imageNamed:@"GBGLV"]];
                    } completion:^(BOOL finished) {
                        
                    }];
                    break;
                }
            }
        }
        default:
            break;
    }
    button.enabled = NO;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            //we don't need interactive transition for push
            self.interactiveTransition = nil;
            self.animator.type = AnimationTypePush;
            return self.animator;
        case UINavigationControllerOperationPop:
            self.interactiveTransition = nil;
            self.animator.type = AnimationTypePop;
            return self.animator;
        default:
            return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
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
