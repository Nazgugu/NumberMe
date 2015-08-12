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

@interface RecordViewController ()<UIScrollViewDelegate, RWBarChartViewDataSource>
@property (weak, nonatomic) IBOutlet RWBarChartView *gameResultChart;
@property (nonatomic, strong) NSMutableArray *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *gameRecordLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) NSInteger max;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _gameResultChart.dataSource = self;
    if (IS_IPHONE_4_OR_LESS)
    {
        _gameResultChart.barWidth = 14.0f;
    }
    else if (IS_IPHONE_5)
    {
        _gameResultChart.barWidth = 16.0f;
    }
    else if (IS_IPHONE_6)
    {
        _gameResultChart.barWidth = 18.0f;
    }
    else
    {
        _gameResultChart.barWidth = 20.0f;
    }
    if ([[EGOCache globalCache] hasCacheForKey:@"maxScore"])
    {
        _max = [[[EGOCache globalCache] stringForKey:@"maxScore"] integerValue];
    }
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    _gameResultChart.alwaysBounceHorizontal = YES;
    _gameResultChart.backgroundColor = [UIColor clearColor];
    _gameResultChart.scrollViewDelegate = self;
    [self retrieveGameResult];
    [_gameResultChart reloadData];
    
    if (_gameResult.count > 0)
    {
        [_gameResultChart scrollToBarAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
    }
    
    _gameRecordLabel.text = @"Game Record";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, _gameResultChart.frame.origin.y + _gameResultChart.frame.size.height - 10, SCREENWIDTH - 20, 1)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25f];
    [self.view addSubview:view];
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
    if ([[EGOCache globalCache] hasCacheForKey:@"games"])
    {
        NSData *gameData = [[EGOCache globalCache] dataForKey:@"games"];
        _gameResult = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
        //process the game data
        for (int i = 0; i < _gameResult.count; i++)
        {
            guessGame *game = [_gameResult objectAtIndex:i];
            CGFloat ratio = (CGFloat)game.gameScore/(CGFloat)_max;
            UIColor *color;
            if (ratio < 0.34)
            {
                color = [UIColor colorWithRed:0.835f green:0.141f blue:0.137f alpha:1.00f];
            }
            else if (ratio > 0.67)
            {
                color = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f];
            }
            else
            {
                color = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
            }
            RWBarChartItem *singleResult = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
            singleResult.text = [NSString stringWithFormat:@"%d",i];
            [_dataSource addObject:singleResult];
        }
    }
    else
    {
        _gameResult = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RWBarChartViewDelegate
- (NSInteger)numberOfSectionsInBarChartView:(RWBarChartView *)barChartView
{
    return 1;
}

- (NSInteger)barChartView:(RWBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section
{
    return _gameResult.count;
}

- (id<RWBarChartItemProtocol>)barChartView:(RWBarChartView *)barChartView barChartItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource objectAtIndex:indexPath.row];
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
    return @"Score Record";
}

- (BOOL)barChartView:(RWBarChartView *)barChartView shouldShowAxisAtRatios:(out NSArray *__autoreleasing *)axisRatios withLabels:(out NSArray *__autoreleasing *)axisLabels
{
    *axisRatios = @[@(0.25),@(0.50),@(0.75),@(1.0)];
    if ([[EGOCache globalCache] hasCacheForKey:@"maxScore"])
    {
        NSInteger first = (NSInteger)(((float)_max) * 0.25);
        NSInteger second = (NSInteger)(((float)_max) * 0.50);
        NSInteger third = (NSInteger)(((float)_max) * 0.75);
        NSString *firstString = [NSString stringWithFormat:@"%ld",first];
        NSString *secondString = [NSString stringWithFormat:@"%ld",second];
        NSString *thirdString = [NSString stringWithFormat:@"%ld",third];
        NSString *forthString = [NSString stringWithFormat:@"%ld",_max];
        *axisLabels = @[firstString,secondString,thirdString,forthString];
    }
    else
    {
        *axisLabels = @[@"0",@"0",@"0",@"0"];
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
    NSLog(@"decelerating, highlighted one is: %ld",_gameResultChart.highlightNumber);
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
