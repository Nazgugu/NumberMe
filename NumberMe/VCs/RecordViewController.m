//
//  RecordViewController.m
//  
//
//  Created by Liu Zhe on 15/8/11.
//
//

#import "RecordViewController.h"
#import "RWBarChartView.h"
#import "EGOCache.h"
#import "guessGame.h"
#import "YETIMotionLabel.h"
#import "NUDialChart.h"
#import "OpenShareHeader.h"

@interface RecordViewController ()<UIScrollViewDelegate, RWBarChartViewDataSource, NUDialChartDataSource, NUDialChartDelegate>
@property (weak, nonatomic) IBOutlet RWBarChartView *gameResultChart;

@property (nonatomic, strong) NSMutableArray *gameResultNormal;
@property (nonatomic, strong) NSMutableArray *gameResultInfinity;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;


@property (nonatomic, strong) NSMutableArray *dataSourceNormal;
@property (nonatomic, strong) NSMutableArray *dataSourceInfinity;

@property (nonatomic) NSInteger maxNormal;
@property (nonatomic) NSInteger maxInfinity;

@property (nonatomic) NSInteger maxInifityCorrectNO;
@property (nonatomic) NSInteger maxInfinityDuration;

@property (nonatomic) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraintLeft;

@property (weak, nonatomic) IBOutlet YETIMotionLabel *dateLabel;

@property (nonatomic, strong) YETIMotionLabel *correctnessLabel;
@property (nonatomic, strong) YETIMotionLabel *durationLabel;
@property (nonatomic, strong) YETIMotionLabel *scoreLabel;

@property (strong, nonatomic) NUDialChart *dataChart;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleChartHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleLabelWidthConstraint;

@property (nonatomic, strong) guessGame *game;
@property (weak, nonatomic) IBOutlet UIButton *shareWechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareWeiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookBtn;

@property (weak, nonatomic) IBOutlet UIView *seperator;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) gameMode displayForGameMode;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _gameResultChart.dataSource = self;
    
    _game = nil;
    
    _displayForGameMode = gameModeNormal;
    
    _closeButton.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat labelGap,labelHeight,seperatorHeight;
    
    seperatorHeight = SCREENHEIGHT - 147 - 270;
    
    NSInteger delta;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _gameResultChart.barWidth = 14.0f;
        _chartHeightConstraint.constant = 200.0f;
        delta = -70;
        labelHeight = 20.0f;
    }
    else if (IS_IPHONE_5)
    {
        _gameResultChart.barWidth = 16.0f;
        _spaceConstraintLeft.constant = 62.0f;
        _spaceConstraintRight.constant = 62.0f;
        _chartHeightConstraint.constant = 270.0f;
        delta = 0;
        labelHeight = 24.0f;
        //labelGap = (151.0f - labelHeight)/4.0f;
    }
    else if (IS_IPHONE_6)
    {
        _chartHeightConstraint.constant = 320.0f;
        _gameResultChart.barWidth = 18.0f;
        _spaceConstraintLeft.constant = 68.0f;
        _spaceConstraintRight.constant = 68.0f;
        delta = 50;
        labelHeight = 30.0f;
        //labelGap = (200.0f - labelHeight)/4.0f;
    }
    else
    {
        _chartHeightConstraint.constant = 350.0f;
        _gameResultChart.barWidth = 20.0f;
        _spaceConstraintLeft.constant = 76.0f;
        _spaceConstraintRight.constant = 76.0f;
        delta = 80;
        labelHeight = 35.0f;
        //labelGap = (239.0f - labelHeight)/4.0f;
    }
    
    labelGap = (seperatorHeight - delta - labelHeight * 3)/4.0f;
    
    if ([[EGOCache globalCache] hasCacheForKey:@"maxNormalScore"])
    {
            _maxNormal = [[[EGOCache globalCache] stringForKey:@"maxNormalScore"] integerValue];
    }
    
    if ([[EGOCache globalCache] hasCacheForKey:@"maxInfinityScore"])
    {
            _maxInfinity = [[[EGOCache globalCache] stringForKey:@"maxInfinityScore"] integerValue];
            _maxInifityCorrectNO = [[[EGOCache globalCache] stringForKey:@"maxInfinityNO"] integerValue];
            _maxInfinityDuration = [[[EGOCache globalCache] stringForKey:@"maxInfinityDuration"] integerValue];
    }
    if (!_dataSourceNormal)
    {
        _dataSourceNormal = [[NSMutableArray alloc] init];
    }
    if (!_dataSourceInfinity)
    {
        _dataSourceInfinity = [[NSMutableArray alloc] init];
    }
    
    _gameResultChart.alwaysBounceHorizontal = YES;
    _gameResultChart.backgroundColor = [UIColor clearColor];
    _gameResultChart.scrollViewDelegate = self;
    [self retrieveGameResult];
    
    _currentIndex = 0;
    
    [_gameModeSegmentedControl setSelectedSegmentIndex:_displayForGameMode];
    
    
    
    [_gameModeSegmentedControl setTitle:NSLocalizedString(@"RECORDTITLENORM", nil) forSegmentAtIndex:0];
    [_gameModeSegmentedControl setTitle:NSLocalizedString(@"RECORDTITLEINFINITY", nil) forSegmentAtIndex:1];
    
    [_gameModeSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"KohinoorDevanagari-Book" size:14.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    //_gameResultChart.backgroundColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, _gameResultChart.frame.origin.y + _chartHeightConstraint.constant - 15, SCREENWIDTH - 20, 1)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25f];
    [self.view addSubview:view];
    
    if (!_dataChart)
    {
        if ((SCREENWIDTH/2 - 20) > _seperator.frame.size.height)
        {
            //NSLog(@"case 1, x = %lf, seperator height = %lf, screen width = %lf, seperator origin y = %lf",(SCREENWIDTH - _seperator.frame.size.height + 20) / 2, _seperator.frame.size.height, SCREENWIDTH, _seperator.frame.origin.y);
            CGFloat width = SCREENHEIGHT - _chartHeightConstraint.constant - 147 - 10;
            _dataChart = [[NUDialChart alloc] initWithFrame:CGRectMake((SCREENWIDTH/2 - width) / 2, _seperator.frame.origin.y + 5 + delta, width, width)];
        }
        else
        {
            //NSLog(@"case 2");
            _dataChart = [[NUDialChart alloc] initWithFrame:CGRectMake(5, delta + _seperator.frame.origin.y + (SCREENHEIGHT - _chartHeightConstraint.constant - 137 - SCREENWIDTH/2)/2, SCREENWIDTH/2 - 10, SCREENWIDTH/2 - 10)];
        }
    }
    
    //_dataChart.backgroundColor = [UIColor lightGrayColor];
    
    _dataChart.chartDataSource = self;
    _dataChart.chartDelegate = self;
    if (IS_IPHONE_4_OR_LESS)
    {
        [_dataChart setupWithCount:3 TotalValue:100 LineWidth:9];
    }
    else if (IS_IPHONE_5)
    {
        [_dataChart setupWithCount:3 TotalValue:100 LineWidth:9];
    }
    else if (IS_IPHONE_6)
    {
        [_dataChart setupWithCount:3 TotalValue:100 LineWidth:11];
    }
    else
    {
        [_dataChart setupWithCount:3 TotalValue:100 LineWidth:12];
    }
    [self.view addSubview:_dataChart];
    [_gameResultChart reloadData];
    
    //add three labels;
    CGFloat labelWidth = SCREENWIDTH/2 - 10;
    
    NSLog(@"seperator height = %lf, gap size = %lf, such seperator height = %lf, screen height = %lf",_seperator.frame.size.height,labelGap,seperatorHeight,SCREENHEIGHT);
    
    //correctness label
    if (!_correctnessLabel)
    {
        _correctnessLabel = [[YETIMotionLabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 + 5, _seperator.frame.origin.y + delta + labelGap, labelWidth, labelHeight)];
    }
    _correctnessLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    _correctnessLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    
    //duration label
    if (!_durationLabel)
    {
        _durationLabel = [[YETIMotionLabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 + 5, _seperator.frame.origin.y + delta + labelGap*2 + labelHeight, labelWidth, labelHeight)];
    }
    _durationLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    _durationLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    
    if (!_scoreLabel)
    {
        _scoreLabel = [[YETIMotionLabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 + 5, _seperator.frame.origin.y + delta + labelGap*3 + labelHeight*2, labelWidth, labelHeight)];
    }
    _scoreLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    _scoreLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    
    [self.view addSubview:_correctnessLabel];
    [self.view addSubview:_durationLabel];
    [self.view addSubview:_scoreLabel];
    
    if (_displayForGameMode == gameModeNormal)
    {
        if (_gameResultNormal.count > 0)
        {
            [_gameResultChart scrollToBarAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
            [self loadDataAtIndex:_currentIndex];
        }
        else
        {
            _dataChart.hidden = YES;
            _dateLabel.text = NSLocalizedString(@"NA", nil);
            _correctnessLabel.text = NSLocalizedString(@"CORRECTNONA", nil);
            _durationLabel.text = NSLocalizedString(@"DURATIONNA", nil);
            _scoreLabel.text = NSLocalizedString(@"SCORENA", nil);
        }
    }
    if (![OpenShare isWeixinInstalled])
    {
        _shareWechatBtn.hidden = YES;
    }
    if (![OpenShare isWeiboInstalled])
    {
        _shareWeiboBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)retrieveGameResult
{
    if ([[EGOCache globalCache] hasCacheForKey:@"normalGames"])
    {
            NSData *gameData = [[EGOCache globalCache] dataForKey:@"normalGames"];
            _gameResultNormal = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
            NSUInteger x = 0;
            NSUInteger y = _gameResultNormal.count - 1;
            if (_gameResultNormal.count > 1)
            {
                while (x < y) {
                    [_gameResultNormal exchangeObjectAtIndex:x withObjectAtIndex:y];
                    x++;
                    y--;
                }
            }
            //process the game data
            for (NSInteger i = 0; i < _gameResultNormal.count; i++)
            {
                guessGame *game = [_gameResultNormal objectAtIndex:i];
                CGFloat ratio = (CGFloat)game.gameScore/(CGFloat)_maxNormal;
                UIColor *color;
                //red
                if (ratio < 0.34)
                {
                    color = [UIColor colorWithRed:0.980f green:0.267f blue:0.275f alpha:0.8f];
                }
                //green
                else if (ratio > 0.67)
                {
                    color = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:0.8f];
                }
                //blue
                else
                {
                    color = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:0.8f];
                }
                RWBarChartItem *singleResult = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
                singleResult.text = [NSString stringWithFormat:@"%ld",i];
                [_dataSourceNormal addObject:singleResult];
            }
    }
    else
    {
            _gameResultNormal = [[NSMutableArray alloc] init];
    }
    if ([[EGOCache globalCache] hasCacheForKey:@"infinityGames"])
    {
            NSData *gameData = [[EGOCache globalCache] dataForKey:@"infinityGames"];
            _gameResultInfinity = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
            NSUInteger x = 0;
            NSUInteger y = _gameResultInfinity.count - 1;
            if (_gameResultInfinity.count > 1)
            {
                while (x < y) {
                    [_gameResultInfinity exchangeObjectAtIndex:x withObjectAtIndex:y];
                    x++;
                    y--;
                }
            }
            //process the game data
            for (NSInteger i = 0; i < _gameResultInfinity.count; i++)
            {
                guessGame *game = [_gameResultInfinity objectAtIndex:i];
                CGFloat ratio = (CGFloat)game.gameScore/(CGFloat)_maxInfinity;
                UIColor *color;
                //red
                if (ratio < 0.34)
                {
                    color = [UIColor colorWithRed:0.980f green:0.267f blue:0.275f alpha:0.8f];
                }
                //green
                else if (ratio > 0.67)
                {
                    color = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:0.8f];
                }
                //blue
                else
                {
                    color = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:0.8f];
                }
                RWBarChartItem *singleResult = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
                singleResult.text = [NSString stringWithFormat:@"%ld",i];
                [_dataSourceInfinity addObject:singleResult];
            }
        }
        else
        {
            _gameResultInfinity = [[NSMutableArray alloc] init];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadDataAtIndex:(NSInteger)index
{
    //NSLog(@"loading data at index:%ld",index);
    _currentIndex = index;
    if (_displayForGameMode == gameModeNormal)
    {
        _game = [_gameResultNormal objectAtIndex:index];
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        _game = [_gameResultInfinity objectAtIndex:index];
    }
    _dateLabel.text = _game.dateString;
    
    if (_displayForGameMode == gameModeNormal)
    {
        //three labels
        _correctnessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"CORRECTNESS", nil), _game.correctNumber * 25];
        _durationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DURATION", nil),_game.duration];
        _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SCORE", nil),_game.gameScore];
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        _correctnessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"CORRECTNO", nil), _game.correctNumber];
        _durationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DURATION", nil),_game.duration];
        _scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SCORE", nil),_game.gameScore];
    }
    
    [_dataChart reloadDialWithAnimation:YES];
}

- (IBAction)toggleView:(id)sender {
    _displayForGameMode = _gameModeSegmentedControl.selectedSegmentIndex;
    _currentIndex = 0;
    [self displayChange];
}

- (void)displayChange
{
    [_gameResultChart reloadData];
    if (_displayForGameMode == gameModeNormal)
    {
        if (_gameResultNormal.count > 0)
        {
            [_gameResultChart scrollToBarAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
            [self loadDataAtIndex:_currentIndex];
            self.dataChart.hidden = NO;
        }
        else
        {
            _dataChart.hidden = YES;
            _dateLabel.text = NSLocalizedString(@"NA", nil);
            _correctnessLabel.text = NSLocalizedString(@"CORRECTNONA", nil);
            _durationLabel.text = NSLocalizedString(@"DURATIONNA", nil);
            _scoreLabel.text = NSLocalizedString(@"SCORENA", nil);
        }
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        if (_gameResultInfinity.count > 0)
        {
            [_gameResultChart scrollToBarAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
            [self loadDataAtIndex:_currentIndex];
            self.dataChart.hidden = NO;
        }
        else
        {
            _dataChart.hidden = YES;
            _dateLabel.text = NSLocalizedString(@"NA", nil);
            _correctnessLabel.text = NSLocalizedString(@"CORRECTNONA", nil);
            _durationLabel.text = NSLocalizedString(@"DURATIONNA", nil);
            _scoreLabel.text = NSLocalizedString(@"SCORENA", nil);
        }
    }
}

#pragma mark - RWBarChartViewDelegate
- (NSInteger)numberOfSectionsInBarChartView:(RWBarChartView *)barChartView
{
    return 1;
}

- (NSInteger)barChartView:(RWBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section
{
    if (_displayForGameMode == gameModeNormal)
    {
        return _gameResultNormal.count;
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        //NSLog(@"infinity number = %ld",_gameResultInfinity.count);
        return _gameResultInfinity.count;
    }
    return 0;
}

- (id<RWBarChartItemProtocol>)barChartView:(RWBarChartView *)barChartView barChartItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexpath.row = %ld",indexPath.row);
    if (_displayForGameMode == gameModeNormal)
    {
        return [_dataSourceNormal objectAtIndex:indexPath.row];
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        return [_dataSourceInfinity objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
    if (_displayForGameMode == gameModeNormal)
    {
        return NSLocalizedString(@"NORMALRECORD", nil);
    }
    else if (_displayForGameMode == gameModeInfinity)
    {
        return NSLocalizedString(@"INFINITYRECORD", nil);
    }
    return nil;
}

- (BOOL)barChartView:(RWBarChartView *)barChartView shouldShowAxisAtRatios:(out NSArray *__autoreleasing *)axisRatios withLabels:(out NSArray *__autoreleasing *)axisLabels
{
    *axisRatios = @[@(0.25),@(0.50),@(0.75),@(1.0)];
    if (_displayForGameMode == gameModeNormal)
    {
        if ([[EGOCache globalCache] hasCacheForKey:@"maxNormalScore"])
        {
            NSInteger first = (NSInteger)(((float)_maxNormal) * 0.25);
            NSInteger second = (NSInteger)(((float)_maxNormal) * 0.50);
            NSInteger third = (NSInteger)(((float)_maxNormal) * 0.75);
            NSString *firstString = [NSString stringWithFormat:@"%ld",first];
            NSString *secondString = [NSString stringWithFormat:@"%ld",second];
            NSString *thirdString = [NSString stringWithFormat:@"%ld",third];
            NSString *forthString = [NSString stringWithFormat:@"%ld",_maxNormal];
            *axisLabels = @[firstString,secondString,thirdString,forthString];
        }
        else
        {
            *axisLabels = @[@"0",@"0",@"0",@"0"];
        }
    }
    if (_displayForGameMode == gameModeInfinity)
    {
        if ([[EGOCache globalCache] hasCacheForKey:@"maxInfinityScore"])
        {
            NSInteger first = (NSInteger)(((float)_maxInfinity) * 0.25);
            NSInteger second = (NSInteger)(((float)_maxInfinity) * 0.50);
            NSInteger third = (NSInteger)(((float)_maxInfinity) * 0.75);
            NSString *firstString = [NSString stringWithFormat:@"%ld",first];
            NSString *secondString = [NSString stringWithFormat:@"%ld",second];
            NSString *thirdString = [NSString stringWithFormat:@"%ld",third];
            NSString *forthString = [NSString stringWithFormat:@"%ld",_maxInfinity];
            *axisLabels = @[firstString,secondString,thirdString,forthString];
        }
        else
        {
            *axisLabels = @[@"0",@"0",@"0",@"0"];
        }
    }
    return YES;
}

- (BOOL)shouldShowItemTextForBarChartView:(RWBarChartView *)barChartView
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"decelerating, highlighted one is: %ld",_gameResultChart.highlightNumber);
    if (_gameResultChart.highlightNumber != _currentIndex)
    {
        [self loadDataAtIndex:_gameResultChart.highlightNumber];
    }
}

#pragma mark - NUDailChartDataSource

- (NSNumber *)dialChart:(NUDialChart *)dialChart valueOfCircleAtIndex:(int)_index
{
    NSNumber *number;
    
    if (_displayForGameMode == gameModeNormal)
    {
        switch (_index) {
                //inner circle: correct number
            case 0:
            {
                number = [NSNumber numberWithInteger:_game.correctNumber * 25];
            }
                break;
                //second circle: use time
            case 1:
            {
                number = [NSNumber numberWithInteger:(_game.duration * 100) / 30];
            }
                break;
                //outter circle: score
            case 2:
            {
                number = [NSNumber numberWithInteger:(_game.gameScore * 100) / _maxNormal];
            }
                break;
            default:
                break;
        }
    }
    if (_displayForGameMode == gameModeInfinity)
    {
        switch (_index) {
                //inner circle: correct number
            case 0:
            {
                number = [NSNumber numberWithInteger:(_game.correctNumber * 100) / _maxInifityCorrectNO];
            }
                break;
                //second circle: use time
            case 1:
            {
                number = [NSNumber numberWithInteger:(_game.duration * 100) / _maxInfinityDuration];
            }
                break;
                //outter circle: score
            case 2:
            {
                number = [NSNumber numberWithInteger:(_game.gameScore * 100) / _maxInfinity];
            }
                break;
            default:
                break;
        }
    }
    return number;
}

- (UIColor *)dialChart:(NUDialChart *)dialChart colorOfCircleAtIndex:(int)_index
{
    UIColor *color;
    
    switch (_index) {
        case 0:
        {
            color = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:0.8f];
        }
            break;
        case 1:
        {
            color = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:0.8f];
        }
            break;
        case 2:
        {
            color = [UIColor colorWithRed:0.980f green:0.267f blue:0.275f alpha:0.8f];
        }
            break;
        default:
            break;
    }
    
    return color;
}

- (NSString *)dialChart:(NUDialChart *)dialChart textOfCircleAtIndex:(int)_index
{
    NSString *info;
    if (_displayForGameMode == gameModeNormal)
    {
        switch (_index) {
            case 0:
            {
                info = NSLocalizedString(@"INFOC", nil);
            }
                break;
            case 1:
            {
                info = NSLocalizedString(@"INFOT", nil);
            }
                break;
            case 2:
            {
                info = NSLocalizedString(@"INFOS", nil);
            }
                break;
            default:
                break;
        }
    }
    if (_displayForGameMode == gameModeInfinity)
    {
        switch (_index) {
            case 0:
            {
                info = NSLocalizedString(@"INFON", nil);
            }
                break;
            case 1:
            {
                info = NSLocalizedString(@"INFOT", nil);
            }
                break;
            case 2:
            {
                info = NSLocalizedString(@"INFOS", nil);
            }
                break;
            default:
                break;
        }
    }
    return info;
}

- (UIColor *)dialChart:(NUDialChart *)dialChart textColorOfCircleAtIndex:(int)_index
{
    //return [UIColor yellowColor];
    return [UIColor whiteColor];
}

- (BOOL)isShowCenterLabelInDial:(NUDialChart *)dialChart
{
    return YES;
}

- (BOOL)dialChart:(NUDialChart *)dialChart defaultCircleAtIndex:(int)_index
{
    return NO;
}

- (UIColor *)centerTextColorInDialChart:(NUDialChart *)dialChart
{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    //return [UIColor yellowColor];
}

- (UIColor *)centerBackgroundColorInDialChart:(NUDialChart *)dialChart
{
    return [UIColor clearColor];
}

- (int)nuscoreInDialChart:(NUDialChart *)dialChart
{
    //NSLog(@"game score = %ld",_game.gameScore);
    return (int)_game.gameScore;
}

- (UIImage *)getScreenshot
{
    CGRect screenRect = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    UIGraphicsBeginImageContextWithOptions(screenRect.size,self.parentViewController.view.opaque,0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [[self.view layer] renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)weixinShare:(id)sender {
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

- (IBAction)weiboShare:(id)sender {
    OSMessage *message = [[OSMessage alloc] init];
    message.title = @"我猜数字又创新纪录了。你也来试试~下载:https://itunes.apple.com/us/app/four4/id1030279451?l=zh&ls=1&mt=8";
    message.image = UIImagePNGRepresentation([self getScreenshot]);
    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}
#pragma mark - NUDailChartDelegate

- (void)touchNuDialChart:(NUDialChart *)chart
{
    
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
