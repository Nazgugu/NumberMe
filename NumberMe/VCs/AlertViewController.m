//
//  AlertViewController.m
//  
//
//  Created by Liu Zhe on 15/8/9.
//
//

#import "AlertViewController.h"
#import "RWBlurPopover.h"
#import "EGOCache.h"
#import "OpenShareHeader.h"

@interface AlertViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *symbolImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (nonatomic, strong) guessGame *game;

@property (weak, nonatomic) IBOutlet UIButton *shareCircleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareWeiboCircle;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookCircle;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *correctnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UIImageView *recordSign;

@end

@implementation AlertViewController

- (instancetype)initWithGame:(guessGame *)game
{
    self = [super init];
    if (self)
    {
        _game = game;
        //self.view.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (CGSize)preferredContentSize {
    //NSLog(@"preffer size");
    return CGSizeMake(280, 300);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.backgroundView.layer.borderWidth = 1.0f;
//    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.backgroundView.layer.masksToBounds = YES;
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    self.view.layer.cornerRadius = 15.0f;
    self.view.layer.masksToBounds = YES;
    
    self.shareCircleButton.layer.cornerRadius = 15.0f;
    self.shareCircleButton.layer.masksToBounds = YES;
    self.shareWeiboCircle.layer.cornerRadius = 15.0f;
    self.shareWeiboCircle.layer.masksToBounds = YES;
    self.shareFacebookCircle.layer.cornerRadius = 15.0f;
    self.shareFacebookCircle.layer.masksToBounds = YES;
    
    _dateLabel.text = _game.dateString;
    
    self.shareFacebookCircle.contentMode = UIViewContentModeScaleAspectFit;
    _recordSign.hidden = YES;
    
    [self.playAgainButton setTitle:NSLocalizedString(@"PLAY_AGAIN", nil) forState:UIControlStateNormal];
    [self.quitButton setTitle:NSLocalizedString(@"QUIT", nil) forState:UIControlStateNormal];
    
    [self presentView];
}

- (void)presentView
{
    self.correctnessLabel.adjustsFontSizeToFitWidth = YES;
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
    self.usedTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.recordLabel.adjustsFontSizeToFitWidth = YES;
    self.correctnessLabel.minimumScaleFactor = 0.8f;
    self.scoreLabel.minimumScaleFactor = 0.8f;
    self.usedTimeLabel.minimumScaleFactor =  0.8f;
    self.recordLabel.minimumScaleFactor = 0.8f;
    
    self.playAgainButton.layer.borderWidth = 1.0f;
    self.playAgainButton.layer.borderColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
    self.playAgainButton.layer.cornerRadius = 12.0f;
    self.playAgainButton.layer.masksToBounds = YES;
    
    self.quitButton.layer.borderWidth = 1.0f;
    self.quitButton.layer.borderColor = [UIColor colorWithRed:0.902f green:0.114f blue:0.169f alpha:0.60f].CGColor;
    self.quitButton.layer.cornerRadius = 12.0f;
    self.quitButton.layer.masksToBounds = YES;
    //failed
    if (_game.succeed == 0 || _game.succeed == 1)
    {
//        self.symbolImage.contentMode = UIViewContentModeTop;
        //self.symbolImage.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithRed:0.945f green:0.290f blue:0.298f alpha:1.00f];
        [_symbolImage setImage:[UIImage imageNamed:@"fail"]];
    }
    //succeed
    else if (_game.succeed == 2)
    {
        //self.symbolImage.backgroundColor = [UIColor colorWithRed:0.243f green:0.773f blue:0.420f alpha:0.8f];
        self.view.backgroundColor = [UIColor colorWithRed:0.235f green:0.753f blue:0.514f alpha:1.00f];
        [_symbolImage setImage:[UIImage imageNamed:@"succeed"]];
    }
    else if (_game.succeed == 3)
    {
        self.view.backgroundColor = [UIColor colorWithRed:0.188f green:0.663f blue:0.929f alpha:1.00f];
        [_symbolImage setImage:[UIImage imageNamed:@"achievement"]];
    }
    
    _usedTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DURATION", nil),_game.duration];
    _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SCORE", nil),_game.gameScore];
    
    if (_game.gameMode == gameModeNormal)
    {
        _correctnessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"CORRECTNESS", nil),_game.correctNumber * 25];
        if ([[EGOCache globalCache] hasCacheForKey:@"maxNormalScore"])
        {
            NSInteger oldRecord = [[[EGOCache globalCache] stringForKey:@"maxNormalScore"] integerValue];
            //new record, need to display the record
            if (oldRecord < _game.gameScore)
            {
                _recordSign.hidden = NO;
                [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%ld",_game.gameScore] forKey:@"maxNormalScore"];
            }
            _recordLabel.text = [NSString stringWithFormat:NSLocalizedString(@"RECORD", nil),oldRecord];
        }
        else
        {
            //new record, need to display the record
            _recordSign.hidden = NO;
            [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%ld",_game.gameScore] forKey:@"maxNormalScore"];
            _recordLabel.text = NSLocalizedString(@"NORECORD", nil);
        }
    }
    else if (_game.gameMode == gameModeInfinity)
    {
        _correctnessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"CORRECTNO", nil),_game.correctNumber];
        if ([[EGOCache globalCache] hasCacheForKey:@"maxInfinityScore"])
        {
            NSInteger oldRecord = [[[EGOCache globalCache] stringForKey:@"maxInfinityScore"] integerValue];
            //new record, need to display the record
            if (oldRecord < _game.gameScore)
            {
                _recordSign.hidden = NO;
                [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%ld",_game.gameScore] forKey:@"maxInfinityScore"];
            }
            _recordLabel.text = [NSString stringWithFormat:NSLocalizedString(@"RECORD", nil),oldRecord];
        }
        else
        {
            //new record, need to display the record
            _recordSign.hidden = NO;
            [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%ld",_game.gameScore] forKey:@"maxInfinityScore"];
            _recordLabel.text = NSLocalizedString(@"NORECORD", nil);
        }
    }
    
    if (![OpenShare isWeixinInstalled])
    {
        self.shareCircleButton.hidden = YES;
    }
    if (![OpenShare isWeiboInstalled])
    {
        self.shareWeiboCircle.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"will appear");
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_game.succeed == 2)
    {
        _titleLabel.textColor = [UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:0.7f];
        _titleLabel.text = NSLocalizedString(@"SUCCESS", nil);
    }
    else if (_game.succeed == 0 || _game.succeed == 1)
    {
        _titleLabel.textColor = [UIColor colorWithRed:1.000f green:0.953f blue:0.216f alpha:1.00f];
        _titleLabel.text = NSLocalizedString(@"FAILED", nil);
    }
    else if (_game.succeed == 3)
    {
        _titleLabel.textColor = [UIColor colorWithRed:0.996f green:0.906f blue:0.204f alpha:1.00f];
        _titleLabel.text = NSLocalizedString(@"END", nil);
    }
    //[self.backgroundView addSubview:_titleLabel];
    
    //self.backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
}

- (IBAction)quitButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"quit" object:nil];
    }];
}

- (IBAction)restartingGame:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"restart" object:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getScreenshot
{
    CGRect screenRect = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIGraphicsBeginImageContextWithOptions(screenRect.size,self.parentViewController.view.opaque,0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [[self.parentViewController.view layer] renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)shareWechatAction:(id)sender {
    OSMessage *message = [[OSMessage alloc] init];
    message.title = [NSString stringWithFormat:@"看，我猜一个四位数只用了%ld秒，得分%ld。你也来试试",_game.duration,_game.gameScore];
    message.link = @"https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    if (IS_IPHONE_4_OR_LESS)
    {
        message.image = UIImageJPEGRepresentation([self scaleImage:[self getScreenshot] toSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT)], 0.1f);
    }
    else if (IS_IPHONE_5)
    {
        message.image = UIImageJPEGRepresentation([self scaleImage:[self getScreenshot] toSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT)], 0.1f);
    }
    else if (IS_IPHONE_6)
    {
        message.image = UIImageJPEGRepresentation([self scaleImage:[self getScreenshot] toSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT)], 0.1f);
    }
    else
    {
        
        message.image = UIImageJPEGRepresentation([self scaleImage:[self getScreenshot] toSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT)], 0.1f);
    }
    //NSLog(@"file size = %ld",message.image.length);
    //message.thumbnail = UIImagePNGRepresentation([self getScreenshot]);
    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}

- (IBAction)shareWeiboAction:(id)sender {
    OSMessage *message = [[OSMessage alloc] init];
    message.title = [NSString stringWithFormat:@"看，我猜一个四位数只用了%ld秒，得分%ld。你也来试试~下载:https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8",_game.duration,_game.gameScore];
    message.image = UIImagePNGRepresentation([self getScreenshot]);
    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}

- (IBAction)shareFacebookAction:(id)sender {
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
