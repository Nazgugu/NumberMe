//
//  ImagePreviewViewController.m
//  NumberMe
//
//  Created by Liu Zhe on 15/9/27.
//  Copyright © 2015年 Liu Zhe. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "EGOCache.h"

@interface ImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, assign) BOOL isOriginal;

@property (nonatomic, assign) NSInteger gameMode;

@property (nonatomic, strong) UIImage *theImage;

@end

@implementation ImagePreviewViewController

- (instancetype)initWithImage:(UIImage *)image isOriginal:(BOOL)original andGameMode:(NSInteger)gameMode
{
    if (self = [super init])
    {
        self.theImage = image;
        self.isOriginal = original;
        self.gameMode = gameMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundImage setImage:_theImage];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RST", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetBG)];
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    if (_isOriginal)
    {
        rightItem.enabled = NO;
    }
    
//    if (_backgroundImage.image)
//    {
//        NSLog(@"in did load has image");
//    }
//    else
//    {
//        NSLog(@"no image in did load");
//    }
    // Do any additional setup after loading the view from its nib.
}


- (void)resetBG
{
    UIImage *originBG;
    NSString *cacheString;
    switch (_gameMode) {
        case 0:
        {
            originBG = [UIImage imageNamed:@"GBGNORM"];
            cacheString = NORMBG;
        }
            break;
        case 1:
        {
            originBG = [UIImage imageNamed:@"GBGINFI"];
            cacheString = INFIBG;
        }
            break;
        case 2:
        {
            originBG = [UIImage imageNamed:@"GBGLV"];
            cacheString = LEVELBG;
        }
            break;
        default:
            break;
    }
    [UIView transitionWithView:_backgroundImage duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [_backgroundImage setImage:originBG];
    } completion:^(BOOL finished) {
        self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
        [[EGOCache globalCache] removeCacheForKey:cacheString];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
