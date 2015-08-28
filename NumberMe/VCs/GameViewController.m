//
//  GameViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//

#import "GameViewController.h"
#import "JTNumberScrollAnimatedView.h"
#import "YETIFallingLabel.h"
#import <JSKTimerView/JSKTimerView.h>
#import "UIView+Shake.h"
#import <QuartzCore/QuartzCore.h>
#import "RWBlurPopover.h"
#import "RWBlurPopoverView.h"
#import "AlertViewController.h"
#import "CircleProgressBar.h"
#import "MZTimerLabel.h"
//#import <pop/POP.h>

@interface GameViewController ()<JSKTimerViewDelegate>

//0 = gameModenormal, 1 = gameModeInfinity
@property (nonatomic) gameMode theGameMode;

@property (nonatomic, assign) NSInteger currentBoxSet;

@property (nonatomic, assign) NSInteger totalTries;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounImageView;

//number buttons
@property (nonatomic, strong) UIButton *numberZero;
@property (nonatomic, strong) UIButton *numberOne;
@property (nonatomic, strong) UIButton *numberTwo;
@property (nonatomic, strong) UIButton *numberThree;
@property (nonatomic, strong) UIButton *numberFour;
@property (nonatomic, strong) UIButton *numberFive;
@property (nonatomic, strong) UIButton *numberSix;
@property (nonatomic, strong) UIButton *numberSeven;
@property (nonatomic, strong) UIButton *numberEight;
@property (nonatomic, strong) UIButton *numberNine;

@property (nonatomic) CGFloat buttonSize;
@property (nonatomic) CGFloat gapSize;

@property (nonatomic) CGFloat verticalGap;

@property (nonatomic) CGFloat boxWidth;
@property (nonatomic) CGFloat boxHeight;

@property (nonatomic) CGFloat toolButtonHeight;
@property (nonatomic) CGFloat toolButtonWidth;

@property (nonatomic, strong) NSMutableArray *boxArray;

//tool buttons
@property (nonatomic, strong) UIButton *deleteOneButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *hintButton;

//top guide label
@property (nonatomic, strong) YETIFallingLabel *guideLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

//timer(for normal mode)
@property (nonatomic, strong) JSKTimerView *timer;

//timerLabel(for inifinity mode)
@property (nonatomic, strong) MZTimerLabel *timerLabel;

//progress bar
@property (nonatomic, strong) CircleProgressBar *availableTries;

@property (nonatomic) NSInteger theGlowingBox;

//the game
@property (nonatomic, strong) guessGame *game;

@property (nonatomic, strong) NSArray *numberArray;
@property (nonatomic, strong) NSMutableArray *enables;

@property (nonatomic, strong) UIScrollView *boxScrollView;

@end

@implementation GameViewController

- (instancetype)initWithGameMode:(gameMode)mode
{
    self = [super init];
    if (self)
    {
        self.theGameMode = mode;
        self.currentBoxSet = 0;
        if (!_enables)
        {
            _enables = [[NSMutableArray alloc] init];
        }
        if (!_boxArray)
        {
            _boxArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //first init 10 round digit buttons
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.backgrounImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    _verticalGap = 20.0f;
    
    _backButton.contentMode = UIViewContentModeScaleAspectFit;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _gapSize = 28.0f;
        _verticalGap = 10.0f;
        _boxHeight = 60.0f;
        _toolButtonHeight = 25.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10,0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 25)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:14.0f];
        
    }
    else if (IS_IPHONE_5)
    {
        _gapSize = 25.0f;
        _verticalGap = 15.0f;
        _boxHeight = 65.0f;
        _toolButtonHeight = 28.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 50)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    }
    else if (IS_IPHONE_6)
    {
        _gapSize = 30.0f;
        _boxHeight = 80.0f;
        _toolButtonHeight = 33.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 50)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:17.0f];
    }
    else
    {
        _gapSize = 35.0f;
        _boxHeight = 95.0f;
        _toolButtonHeight = 38.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 70)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:19.0f];
    }
    
    _boxWidth = (SCREENWIDTH - 5 * _gapSize) / 4;
    
    //debug puropse
//    _guideLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//    _guideLabel.layer.borderWidth = 1.0f;
//    _guideLabel.layer.masksToBounds = YES;
    
    _guideLabel.numberOfLines = 0;
    _guideLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _guideLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    _guideLabel.textAlignment = NSTextAlignmentCenter;
    
    //initialize a new game
    _game = [[guessGame alloc] initWithGameMode:_theGameMode];
    
    [self.view addSubview:_guideLabel];
    [self initButtons];
    [self createBoxesOfBoxSet:_currentBoxSet];
    [self createLine];
    [self initToolButton];
    
    if (_theGameMode == gameModeNormal)
    {
        _guideLabel.text = NSLocalizedString(@"GUIDE_ONE", nil);
        [self initTimer];
        [_backgrounImageView setImage:[UIImage imageNamed:@"GBGNORM"]];
    }
    else if (_theGameMode == gameModeInfinity)
    {
        _guideLabel.text = NSLocalizedString(@"INFINITI", nil);
        _totalTries = _game.availableTries;
        [self initProgressBar];
        [self initTimerLabel];
        [_backgrounImageView setImage:[UIImage imageNamed:@"GBGINFI"]];
    }
    else if (_theGameMode == gameModeLevelUp)
    {
        _guideLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GAMELEVEL", nil),_game.gameLevel];
        _totalTries = _game.availableTries;
        [self initTimer];
        [self initProgressBar];
        [_backgrounImageView setImage:[UIImage imageNamed:@"GBGLV"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quit) name:@"quit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restart" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)quit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)restart
{
    NSLog(@"restarting game");
    [self disableTouchOnBox];
    _game = [[guessGame alloc] initWithGameMode:_theGameMode];
    _theGlowingBox = 0;
    _currentBoxSet = 0;
    
    if (_theGameMode == gameModeNormal)
    {
        for (int i = 0; i < _enables.count; i++)
        {
            [_enables replaceObjectAtIndex:i withObject:@(1)];
        }
        
        [self revertToWhite];
        [_timer resetTimer];
        [self cancelShake];
        _guideLabel.text = NSLocalizedString(@"GUIDE_ONE", nil);
    }
    else if (_theGameMode == gameModeInfinity)
    {
        //first clear all the digit boxes
        [self moveToBoxToSet:_currentBoxSet];
        if (_currentBoxSet > 0)
        {
            JTNumberScrollAnimatedView *tempDigit;
            NSInteger i = _boxArray.count - 1;
            [_boxScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            for (;i >= 4;i--)
            {
                tempDigit = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:i];
                [tempDigit removeFromSuperview];
                [_boxArray removeObject:tempDigit];
            }
            [_boxScrollView setContentSize:CGSizeMake(SCREENWIDTH, _boxScrollView.frame.size.height)];
        }
        for (JTNumberScrollAnimatedView *box in _boxArray)
        {
            box.value = @"?";
        }
        _totalTries = _game.availableTries;
        [_timerLabel reset];
        [self resetProgressBar];
        [self revertToWhite];
        _guideLabel.text = NSLocalizedString(@"INFINITI", nil);
    }
    [self performSelector:@selector(animateReady) withObject:nil afterDelay:1.2f];
    [self animateDigits];
}
- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"will appear");
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self commitAnimation];
    [self performSelector:@selector(animateReady) withObject:nil afterDelay:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)animateReady{
    _guideLabel.text = NSLocalizedString(@"GUIDE_TWO", nil);
    [self performSelector:@selector(animateGo) withObject:nil afterDelay:1.5f];
}

- (void)animateGo{
    _guideLabel.text = NSLocalizedString(@"GUIDE_THREE", nil);
    
    if (_theGameMode == gameModeNormal)
    {
        [_timer startTimer];
        [self performSelector:@selector(shakeTimer) withObject:nil afterDelay:20];
    }
    else if (_theGameMode == gameModeInfinity)
    {
        NSLog(@"calling go");
        [_timerLabel start];
    }
    else if (_theGameMode == gameModeLevelUp)
    {
        [_timer startTimer];
        [self performSelector:@selector(shakeTimer) withObject:nil afterDelay:_game.gameLevelTime - 10];
    }
    _deleteOneButton.enabled = YES;
    _clearButton.enabled = YES;
    _restartButton.enabled = YES;
    _hintButton.enabled = YES;
    [self performSelector:@selector(enableTouchOnBox) withObject:nil afterDelay:0.3f];
    
    //debug
    //[self answerWrongAndShakeBoxes];
    //[self showSuccess];
}

- (void)enableTouchOnBox
{
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        for (JTNumberScrollAnimatedView *digitBox in _boxArray)
        {
            digitBox.userInteractionEnabled = YES;
        }
    }
    
    _deleteOneButton.enabled = YES;
    _clearButton.enabled = YES;
    _restartButton.enabled = YES;
    _hintButton.enabled = YES;
    
    _numberZero.userInteractionEnabled = YES;
    _numberOne.userInteractionEnabled = YES;
    _numberTwo.userInteractionEnabled = YES;
    _numberThree.userInteractionEnabled = YES;
    _numberFour.userInteractionEnabled = YES;
    _numberFive.userInteractionEnabled = YES;
    _numberSix.userInteractionEnabled = YES;
    _numberSeven.userInteractionEnabled = YES;
    _numberEight.userInteractionEnabled = YES;
    _numberNine.userInteractionEnabled = YES;
    [self glowBoxAtIndex:_currentBoxSet * 4 + 1];
}

- (void)disableTouchOnBox
{
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        for (JTNumberScrollAnimatedView *digitBox in _boxArray)
        {
            digitBox.userInteractionEnabled = NO;
        }
    }
    
    _deleteOneButton.enabled = NO;
    _clearButton.enabled = NO;
    _restartButton.enabled = NO;
    _hintButton.enabled = NO;
    
    _numberZero.userInteractionEnabled = NO;
    _numberOne.userInteractionEnabled = NO;
    _numberTwo.userInteractionEnabled = NO;
    _numberThree.userInteractionEnabled = NO;
    _numberFour.userInteractionEnabled = NO;
    _numberFive.userInteractionEnabled = NO;
    _numberSix.userInteractionEnabled = NO;
    _numberSeven.userInteractionEnabled = NO;
    _numberEight.userInteractionEnabled = NO;
    _numberNine.userInteractionEnabled = NO;
}

- (void)createLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_gapSize - 18, SCREEN_HEIGHT - _verticalGap * 5 - 4 * _buttonSize, SCREENWIDTH - 2 * (_gapSize - 18), 1)];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    [self.view addSubview:line];
}

- (void)initToolButton
{
    _toolButtonWidth = (SCREENWIDTH - 5 * (_gapSize - 18)) / 4;
    
    if (!_deleteOneButton)
    {
        _deleteOneButton = [[UIButton alloc] initWithFrame:CGRectMake(-_toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    }
    _deleteOneButton.layer.borderWidth = 1.0f;
    _deleteOneButton.layer.borderColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f].CGColor;
    _deleteOneButton.layer.cornerRadius = _toolButtonHeight/2;
    _deleteOneButton.layer.masksToBounds = YES;
    [_deleteOneButton setTitleColor:[UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f] forState:UIControlStateNormal];
    [_deleteOneButton setTitleColor:[UIColor colorWithRed:0.941f green:0.608f blue:0.173f alpha:1.00f] forState:UIControlStateHighlighted];
    [_deleteOneButton setTitle:NSLocalizedString(@"DELETE", nil) forState:UIControlStateNormal];
    _deleteOneButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _deleteOneButton.titleLabel.minimumScaleFactor = 0.5f;
    _deleteOneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _deleteOneButton.tintColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f];
    _deleteOneButton.alpha = 0;
    _deleteOneButton.tag = -1;
    [_deleteOneButton addTarget:self action:@selector(toolButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_deleteOneButton addTarget:self action:@selector(toolButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteOneButton];
    
    if (!_clearButton)
    {
        _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(-_toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    }
    _clearButton.layer.borderWidth = 1.0f;
    _clearButton.layer.borderColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f].CGColor;
    _clearButton.layer.cornerRadius = _toolButtonHeight/2;
    _clearButton.layer.masksToBounds = YES;
    [_clearButton setTitleColor:[UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f] forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor colorWithRed:0.812f green:0.333f blue:0.098f alpha:1.00f] forState:UIControlStateHighlighted];
    [_clearButton setTitle:NSLocalizedString(@"CLEAR", nil) forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _clearButton.titleLabel.minimumScaleFactor = 0.5f;
    _clearButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _clearButton.tintColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f];
    _clearButton.alpha = 0;
    _clearButton.tag = -2;
    [_clearButton addTarget:self action:@selector(toolButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_clearButton addTarget:self action:@selector(toolButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearButton];
    
    if (!_restartButton)
    {
        _restartButton = [[UIButton alloc] initWithFrame:CGRectMake(-_toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    }
    _restartButton.layer.borderWidth = 1.0f;
    _restartButton.layer.borderColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f].CGColor;
    _restartButton.layer.cornerRadius = _toolButtonHeight/2;
    _restartButton.layer.masksToBounds = YES;
    [_restartButton setTitleColor:[UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f] forState:UIControlStateNormal];
    [_restartButton setTitleColor:[UIColor colorWithRed:0.737f green:0.231f blue:0.188f alpha:1.00f] forState:UIControlStateHighlighted];
    [_restartButton setTitle:NSLocalizedString(@"RESTART", nil) forState:UIControlStateNormal];
    _restartButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _restartButton.titleLabel.minimumScaleFactor = 0.5f;
    _restartButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _restartButton.tintColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f];
    _restartButton.alpha = 0;
    _restartButton.tag = -3;
    [_restartButton addTarget:self action:@selector(toolButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_restartButton addTarget:self action:@selector(toolButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restartButton];
    
    if (!_hintButton)
    {
        _hintButton = [[UIButton alloc] initWithFrame:CGRectMake(-_toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    }
    _hintButton.layer.borderWidth = 1.0f;
    _hintButton.layer.borderColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
    _hintButton.layer.cornerRadius = _toolButtonHeight/2;
    _hintButton.layer.masksToBounds = YES;
    [_hintButton setTitleColor:[UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f] forState:UIControlStateNormal];
    [_hintButton setTitleColor:[UIColor colorWithRed:0.224f green:0.675f blue:0.388f alpha:1.00f] forState:UIControlStateHighlighted];
    [_hintButton setTitle:NSLocalizedString(@"HINT", nil) forState:UIControlStateNormal];
    _hintButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _hintButton.titleLabel.minimumScaleFactor = 0.5f;
    _hintButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _hintButton.tintColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
    _hintButton.alpha = 0;
    _hintButton.tag = -4;
    [_hintButton addTarget:self action:@selector(toolButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_hintButton addTarget:self action:@selector(toolButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hintButton];
    
    //first set them to be disabled
    _deleteOneButton.enabled = NO;
    _clearButton.enabled = NO;
    _restartButton.enabled = NO;
    _hintButton.enabled = NO;

}

//start from 0
- (void)createBoxesOfBoxSet:(NSInteger)index
{
    if (!_boxScrollView)
    {
        _boxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight, SCREENWIDTH, _boxHeight)];
        //NSLog(@"scrollview frame, x = %lf, y = %lf, width = %lf, height = %lf",_boxScrollView.frame.origin.x,_boxScrollView.frame.origin.y,_boxScrollView.frame.size.width,_boxScrollView.frame.size.height);
//        _boxScrollView.backgroundColor = [UIColor blackColor];
//        _boxScrollView.layer.borderWidth = 1.0f;
//        _boxScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _boxScrollView.layer.masksToBounds = YES;
        [self.view addSubview:_boxScrollView];
        _boxScrollView.showsHorizontalScrollIndicator = NO;
        _boxScrollView.showsVerticalScrollIndicator = NO;
        _boxScrollView.alwaysBounceHorizontal = NO;
        _boxScrollView.alwaysBounceVertical = NO;
    }
    _boxScrollView.contentSize = CGSizeMake((index + 1) * SCREENWIDTH, _boxScrollView.frame.size.height);
    for (int i = 0; i < 4; i++)
    {
        JTNumberScrollAnimatedView *digitBox = [[JTNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(_gapSize * 5 * index + _boxWidth * 4 * index + (i + 1) * _gapSize + i * _boxWidth, 0, _boxWidth, _boxHeight)];
        digitBox.layer.borderWidth = 1.5f;
        digitBox.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
        digitBox.layer.cornerRadius = 8.0f;
        digitBox.layer.masksToBounds = YES;
        digitBox.textColor = [UIColor whiteColor];
        digitBox.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
        digitBox.minLength = 1;
        digitBox.tag = index * 4 + i + 1;
        if (index > 0)
        {
            digitBox.value = @"?";
        }
        if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBox:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [digitBox addGestureRecognizer:tap];
            [_enables addObject:@(1)];
        }
        [_boxArray addObject:digitBox];
        [_boxScrollView addSubview:digitBox];
    }
    _theGlowingBox = 4 * index;
    if (_currentBoxSet == 0)
    {
        [self disableTouchOnBox];
    }
}

- (void)moveToBoxToSet:(NSInteger)set
{
    [_boxScrollView setContentOffset:CGPointMake(SCREENWIDTH * set, 0) animated:YES];
}

- (void)initTimer
{
    if (!_timer)
    {
        _timer = [[JSKTimerView alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _timer.delegate = self;
    _timer.labelTextColor = [UIColor whiteColor];
    if (_theGameMode == gameModeNormal)
    {
        [_timer setTimerWithDuration:30];
    }
    else if (_theGameMode == gameModeLevelUp)
    {
        [_timer setTimerWithDuration:_game.gameLevelTime];
    }
    [self.view addSubview:_timer];
}

- (void)initTimerLabel
{
    if (!_timerLabel)
    {
        _timerLabel = [[MZTimerLabel alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2 - 10, SCREENHEIGHT - (_buttonSize - 40)/2 - _verticalGap - (_buttonSize - 40), _buttonSize + 20, _buttonSize - 40)];
    }
    
    //debug purpose
//    _timerLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//    _timerLabel.layer.borderWidth = 1.0f;
//    _timerLabel.layer.masksToBounds = YES;
    
    _timerLabel.timerType = MZTimerLabelTypeStopWatch;
    _timerLabel.backgroundColor = [UIColor clearColor];
    _timerLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:25.0f];
    _timerLabel.adjustsFontSizeToFitWidth = YES;
    _timerLabel.minimumScaleFactor = 0.6f;
    _timerLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.alpha = 0.0f;
    [self.view addSubview:_timerLabel];
}

- (void)initProgressBar
{
    if (!_availableTries)
    {
        if (_theGameMode == gameModeInfinity)
        {
            _availableTries = [[CircleProgressBar alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
        }
        else if (_theGameMode == gameModeLevelUp)
        {
            _availableTries = [[CircleProgressBar alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
        }
    }
    _availableTries.backgroundColor = [UIColor clearColor];
    _availableTries.progressBarWidth = 4.0f;
    _availableTries.progressBarTrackColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
    _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
    _availableTries.hintHidden = NO;
    _availableTries.hintViewSpacing = 5.0f;
    _availableTries.hintViewBackgroundColor = [UIColor clearColor];
    _availableTries.hintTextFont = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:18.0f];
    _availableTries.hintTextColor = [UIColor whiteColor];
    [_availableTries setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%d",(int)(progress * _totalTries)];
    }];
    [_availableTries setProgress:1.0f animated:YES];
    
    [self.view addSubview:_availableTries];
}

- (void)resetProgressBar
{
    _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
    [_availableTries setProgress:1.0f animated:YES];
}

- (void)initButtons
{
    _buttonSize = (SCREENWIDTH - 4 * _gapSize) / 3;
    
    //debug
    //NSLog(@"_gap size = %lf, button size = %lf",_gapSize, _buttonSize);
    
    //number zero
    if (!_numberZero)
    {
        _numberZero = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - _buttonSize)/2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberZero.tag = 0;
    _numberZero.layer.borderWidth = 1.0f;
    _numberZero.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberZero.layer.cornerRadius = _buttonSize / 2;
    _numberZero.layer.masksToBounds = YES;
    _numberZero.clipsToBounds = YES;
    [_numberZero setTitle:@"0" forState:UIControlStateNormal];
    [_numberZero setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberZero addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberZero addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    [_numberZero setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberZero.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberZero];
    
    //number one
    if (!_numberOne)
    {
        _numberOne = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberOne.tag = 1;
    _numberOne.layer.borderWidth = 1.0f;
    _numberOne.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberOne.layer.cornerRadius = _buttonSize / 2;
    _numberOne.layer.masksToBounds = YES;
    [_numberOne setTitle:@"1" forState:UIControlStateNormal];
    [_numberOne setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberOne setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberOne addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberOne addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberOne.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
//    _numberOne.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:_numberOne];
    
    //number two
    if (!_numberTwo)
    {
        _numberTwo = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberTwo.tag = 2;
    _numberTwo.layer.borderWidth = 1.0f;
    _numberTwo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberTwo.layer.cornerRadius = _buttonSize / 2;
    _numberTwo.layer.masksToBounds = YES;
    [_numberTwo setTitle:@"2" forState:UIControlStateNormal];
    [_numberTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberTwo setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberTwo addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberTwo addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberTwo.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberTwo];
    
    //number three
    if (!_numberThree)
    {
        _numberThree = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberThree.tag = 3;
    _numberThree.layer.borderWidth = 1.0f;
    _numberThree.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberThree.layer.cornerRadius = _buttonSize / 2;
    _numberThree.layer.masksToBounds = YES;
    [_numberThree setTitle:@"3" forState:UIControlStateNormal];
    [_numberThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberThree setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberThree addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberThree addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberThree.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberThree];
    
    //number four
    if (!_numberFour)
    {
        _numberFour = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberFour.tag = 4;
    _numberFour.layer.borderWidth = 1.0f;
    _numberFour.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberFour.layer.cornerRadius = _buttonSize / 2;
    _numberFour.layer.masksToBounds = YES;
    [_numberFour setTitle:@"4" forState:UIControlStateNormal];
    [_numberFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberFour setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberFour addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberFour addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberFour.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberFour];
    
    //number five
    if (!_numberFive)
    {
        _numberFive = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberFive.tag = 5;
    _numberFive.layer.borderWidth = 1.0f;
    _numberFive.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberFive.layer.cornerRadius = _buttonSize / 2;
    _numberFive.layer.masksToBounds = YES;
    [_numberFive setTitle:@"5" forState:UIControlStateNormal];
    [_numberFive setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberFive setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberFive addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberFive addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberFive.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberFive];
    
    //number six
    if (!_numberSix)
    {
        _numberSix = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberSix.tag = 6;
    _numberSix.layer.borderWidth = 1.0f;
    _numberSix.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberSix.layer.cornerRadius = _buttonSize / 2;
    _numberSix.layer.masksToBounds = YES;
    [_numberSix setTitle:@"6" forState:UIControlStateNormal];
    [_numberSix setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberSix setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberSix addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberSix addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberSix.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberSix];
    
    //number seven
    if (!_numberSeven)
    {
        _numberSeven = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberSeven.tag = 7;
    _numberSeven.layer.borderWidth = 1.0f;
    _numberSeven.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberSeven.layer.cornerRadius = _buttonSize / 2;
    _numberSeven.layer.masksToBounds = YES;
    [_numberSeven setTitle:@"7" forState:UIControlStateNormal];
    [_numberSeven setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberSeven setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberSeven addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberSeven addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberSeven.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberSeven];
    
    //number eight
    if (!_numberEight)
    {
        _numberEight = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberEight.tag = 8;
    _numberEight.layer.borderWidth = 1.0f;
    _numberEight.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberEight.layer.cornerRadius = _buttonSize / 2;
    _numberEight.layer.masksToBounds = YES;
    [_numberEight setTitle:@"8" forState:UIControlStateNormal];
    [_numberEight setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberEight setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberEight addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberEight addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberEight.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberEight];
    
    //number nine
    if (!_numberNine)
    {
        _numberNine = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberNine.tag = 9;
    _numberNine.layer.borderWidth = 1.0f;
    _numberNine.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberNine.layer.cornerRadius = _buttonSize / 2;
    _numberNine.layer.masksToBounds = YES;
    [_numberNine setTitle:@"9" forState:UIControlStateNormal];
    [_numberNine setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    [_numberNine setTitleColor:[UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f] forState:UIControlStateHighlighted];
    [_numberNine addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_numberNine addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    _numberNine.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
    [self.view addSubview:_numberNine];
    
    _numberArray = [[NSArray alloc] initWithObjects:_numberZero, _numberOne, _numberTwo, _numberThree, _numberFour, _numberFive, _numberSix, _numberSeven, _numberEight, _numberNine, nil];

}

- (void)commitAnimation
{
    [self animateDigits];
    [self animatButtonOne];
    [self performSelector:@selector(animateButtonTwo) withObject:nil afterDelay:0.2f];
    [self performSelector:@selector(animateButtonThree) withObject:nil afterDelay:0.3f];
    [self animateToolButton];
}

- (void)animateDigits
{
    [self performSelector:@selector(animateDigitFour) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(animateDigitThree) withObject:nil afterDelay:0.2f];
    [self performSelector:@selector(animateDigitTwo) withObject:nil afterDelay:0.1f];
    JTNumberScrollAnimatedView *firstDigit = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:0];
    [firstDigit setValue:@"?"];
    [firstDigit startAnimation];
}

- (void)animateToolButton
{
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_deleteOneButton setFrame:CGRectMake(_gapSize - 18, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
        _deleteOneButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.5f delay:0.2f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_clearButton setFrame:CGRectMake((_gapSize - 18) * 2 + _toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
        _clearButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.6f delay:0.3f usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_restartButton setFrame:CGRectMake((_gapSize - 18) * 3 + _toolButtonWidth * 2, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
        _restartButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.7f delay:0.4f usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_hintButton setFrame:CGRectMake((_gapSize - 18) * 4 + _toolButtonWidth * 3, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
        _hintButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animateDigitTwo
{
    JTNumberScrollAnimatedView *secondDigit = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:1];
    [secondDigit setValue:@"?"];
    [secondDigit startAnimation];
}

- (void)animateDigitThree
{
    JTNumberScrollAnimatedView *thirdDigit = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:2];
    [thirdDigit setValue:@"?"];
    [thirdDigit startAnimation];
}

- (void)animateDigitFour
{
    JTNumberScrollAnimatedView *forthDigit = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:3];
    [forthDigit setValue:@"?"];
    [forthDigit startAnimation];
}

- (void)animatButtonOne
{
    CGFloat centerX = _gapSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 4 - _buttonSize * 3 - _buttonSize/2;
    
    //debug
//    NSLog(@"center x = %lf, center y = %lf",centerX, centerY);
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberOne setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonFour];
    }];
}

- (void)animateButtonTwo
{
    CGFloat centerX = _gapSize * 2 + _buttonSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 4 - _buttonSize * 3 - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberTwo setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonFive];
    }];
}

- (void)animateButtonThree
{
    CGFloat centerX = _gapSize * 3 + _buttonSize * 2 + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 4 - _buttonSize * 3 - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberThree setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonSix];
    }];
}

- (void)animateButtonFour
{
    CGFloat centerX = _gapSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 3 - _buttonSize * 2 - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberFour setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonSeven];
    }];
}

- (void)animateButtonFive
{
    CGFloat centerX = _gapSize * 2 + _buttonSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 3 - _buttonSize * 2 - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberFive setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonEight];
    }];
}

- (void)animateButtonSix
{
    CGFloat centerX = _gapSize * 3 + _buttonSize * 2 + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 3 - _buttonSize * 2 - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberSix setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateButtonNine];
    }];
}

- (void)animateButtonSeven
{
    CGFloat centerX = _gapSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 2 - _buttonSize - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberSeven setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
        [self animateTimer];
        if (_theGameMode == gameModeInfinity || _theGameMode ==  gameModeLevelUp)
        {
            [self animateProgressBar];
        }
        [self animateButtonZero];
    }];
}

- (void)animateButtonEight
{
    CGFloat centerX = _gapSize * 2 + _buttonSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 2 - _buttonSize - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberEight setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
    }];
}

- (void)animateButtonNine
{
    CGFloat centerX = _gapSize * 3 + _buttonSize * 2 + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap * 2 - _buttonSize - _buttonSize/2;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberNine setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
    }];
}

- (void)animateButtonZero
{
    CGFloat centerX = _gapSize * 2 + _buttonSize + _buttonSize/2;
    CGFloat centerY = SCREENHEIGHT - _verticalGap - _buttonSize/2;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_numberZero setCenter:CGPointMake(centerX, centerY)];
    }completion:^(BOOL finished) {
    }];
}

- (void)animateTimer
{
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        CGFloat centerX = _gapSize + _buttonSize/2;
        CGFloat centerY = SCREENHEIGHT - _verticalGap - _buttonSize/2;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_timer setCenter:CGPointMake(centerX, centerY)];
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (_theGameMode == gameModeInfinity)
    {
        [UIView animateWithDuration:0.3f animations:^{
            _timerLabel.alpha = 1.0f;
        }];
    }
}

- (void)animateProgressBar
{
    CGFloat centerX;
    CGFloat centerY;
    if (_theGameMode == gameModeInfinity)
    {
        centerX = _gapSize + _buttonSize/2;
        centerY = SCREENHEIGHT - _verticalGap - _buttonSize/2;
    }
    else if (_theGameMode == gameModeLevelUp)
    {
        centerX = _gapSize * 3 + _buttonSize * 2 + _buttonSize/2;
        centerY = SCREENHEIGHT - _verticalGap - _buttonSize/2;
    }
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_availableTries setCenter:CGPointMake(centerX, centerY)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)shakeBoxAtIndex:(NSInteger)index
{
    //NSLog(@"shake");
    JTNumberScrollAnimatedView *temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:index];
    temp.layer.borderColor = [[UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f] colorWithAlphaComponent:0.5f].CGColor;
    temp.layer.shadowColor = [UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f].CGColor;
    temp.layer.shadowRadius = 5.0f;
    temp.layer.shadowOpacity = 0.8f;
    
    [temp shakeWithOptions:SCShakeOptionsDirectionHorizontal force:0.1f duration:0.3 iterationDuration:0.05 completionHandler:nil];
    
//    [temp shake:10 withDelta:6 speed:0.05 shakeDirection:ShakeDirectionHorizontal];
    
    [self performSelector:@selector(glowBlue:) withObject:temp afterDelay:0.3f];
}

- (void)glowBlue:(JTNumberScrollAnimatedView *)view
{
    if (view.isUserInteractionEnabled)
    {
        view.layer.borderColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
        view.layer.shadowColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
        view.layer.shadowRadius = 5.0f;
        view.layer.shadowOpacity = 0.8f;
    }
    return;
}

- (void)revertToWhite
{
//    CABasicAnimation *reverseAnimation = [CABasicAnimation animationWithKeyPath:@"colorAnimation"];
//    reverseAnimation.autoreverses = NO;
//    reverseAnimation.fromValue = (id)[[UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f] colorWithAlphaComponent:0.5f].CGColor;
//    reverseAnimation.toValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
//    reverseAnimation.duration = 0.3f;
//    reverseAnimation.removedOnCompletion = YES;
//    reverseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    //first digitt
//    if (_theGameMode == gameModeNormal)
//    {
        for (JTNumberScrollAnimatedView *digitBox in _boxArray)
        {
            digitBox.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
            digitBox.layer.shadowColor = [UIColor clearColor].CGColor;
            digitBox.layer.shadowRadius = 0;
            digitBox.layer.shadowOpacity = 0;
//            [digitBox.layer addAnimation:reverseAnimation forKey:@"reverse"];
        }
//    }
}

- (void)tappedBox:(UIGestureRecognizer *)tap
{
//    NSLog(@"tapped");
    JTNumberScrollAnimatedView *tappedNumber = (JTNumberScrollAnimatedView *)[tap view];
    if (tappedNumber.tag == _theGlowingBox)
    {
        return;
    }
    else
    {
        [self glowBoxAtIndex:tappedNumber.tag];
    }
}

//glow blue
- (void)glowBoxAtIndex:(NSInteger)index
{
//    NSLog(@"the glowing box = %ld",(long)_theGlowingBox);
    
    JTNumberScrollAnimatedView *temp;
    
    
    if (_theGlowingBox == 0)
    {
        //NSLog(@"zero");
        temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:_theGlowingBox];
    }
    else
    {   //NSLog(@"not zero");
        if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
        {
            temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:_theGlowingBox - 1];
        }
        else if (_theGameMode == gameModeInfinity)
        {
            temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:_theGlowingBox];
        }
    }
    
//    [temp.layer removeAllAnimations];
    
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        //NSLog(@"game mode normal");
        if (temp.isUserInteractionEnabled == YES)
        {
            if (_theGlowingBox != 0)
            {
                if (_theGlowingBox != index)
                {
                    //glow back
                    
                    temp.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
                    temp.layer.shadowColor = [UIColor clearColor].CGColor;
                    temp.layer.shadowRadius = 0;
                    temp.layer.shadowOpacity = 0;
                }
            }
            else
            {
                temp.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
                temp.layer.shadowColor = [UIColor clearColor].CGColor;
                temp.layer.shadowRadius = 0;
                temp.layer.shadowOpacity = 0;
            }
        }
        
        temp = [_boxArray objectAtIndex:index - 1];
        
        if (temp.isUserInteractionEnabled)
        {
            _theGlowingBox = index;
            temp.layer.borderColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
            temp.layer.shadowColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
            temp.layer.shadowRadius = 5.0f;
            temp.layer.shadowOpacity = 0.8f;
            return;
        }
        else
        {
            if (index < 4)
            {
                [self glowBoxAtIndex:index + 1];
                return;
            }
            else
            {
                [self glowBoxAtIndex:1];
                return;
            }
        }
    }
    else if (_theGameMode == gameModeInfinity)
    {
        //NSLog(@"game mode infinity");
        _theGlowingBox = index;
        temp.layer.borderColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
        temp.layer.shadowColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
        temp.layer.shadowRadius = 5.0f;
        temp.layer.shadowOpacity = 0.8f;
    }
    
}

//glow green
- (void)glowGreenAtIndex:(NSInteger)index
{
    //NSLog(@"glow green at index = %ld",index);
    JTNumberScrollAnimatedView *temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:index];
    
    temp.userInteractionEnabled = NO;
    
//    [temp.layer addAnimation:reverseAnimation forKey:@"colorChange"];
    temp.layer.borderColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
    temp.layer.shadowColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
    temp.layer.shadowRadius = 5.0f;
    temp.layer.shadowOpacity = 0.8;
}

- (void)cancelShake
{
    [self stopShake];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(shakeTimer) object:nil];
}

- (void)stopShake
{
//    NSLog(@"stop shake");
//    for (CALayer *layer in _timer.layer.sublayers)
//    {
//        [layer removeAllAnimations];
//        [layer.presentationLayer removeAllAnimations];
//    }
//    
//    [_timer.layer removeAllAnimations];
//    [_timer.layer.presentationLayer removeAllAnimations];
    
    [_timer endShake];
    
}

- (void)shakeTimer
{
    [_timer shakeWithOptions:SCShakeOptionsDirectionHorizontal force:0.08 duration:10 iterationDuration:0.1 completionHandler:nil];
    
//    [_timer shake:220 withDelta:4.0f speed:0.09 shakeDirection:ShakeDirectionHorizontal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

- (void)buttonHighlighted:(UIButton *)sender
{
    [self disableTouchOnOthersExcept:sender.tag];
    sender.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    sender.layer.borderColor = [UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f].CGColor;
}

- (void)buttonNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    
    CGFloat progress;
    
    if (_game.gameMode == gameModeInfinity)
    {
        if (_boxScrollView.contentOffset.x != SCREENWIDTH*_currentBoxSet)
        {
            [self moveToBoxToSet:_currentBoxSet];
        }
    }
    
    //deal with button press
    JTNumberScrollAnimatedView *temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:_theGlowingBox - 1];
    temp.value = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    /* game logic goes here */
    
    self.guideLabel.text = [_game userAnswersAtBox:(_theGlowingBox - 4 * _currentBoxSet) % 5 andAnswer:sender.tag];
    
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        if (_game.succeed == 2)
        {
            //succeed
            //NSLog(@"showing success");
            //        NSLog(@"remain time = %ld",[_timer remainingDurationInSeconds]);
            [self resumeTouch];
            [_timer pauseTimer];
            [self showSuccess];
            return;
        }
    }
    else if (_theGameMode == gameModeInfinity)
    {
        if (_game.succeed == 3)
        {
            NSLog(@"game ended");
            //do some thing
            [_timerLabel pause];
            [self showSuccess];
            return;
        }
    }
//    else if (_theGameMode == gameModeLevelUp)
//    {
//        if (_game.succeed == 2)
//        {
//            [self resumeTouch];
//            [_timer pauseTimer];
//            [self showSuccess];
//            return;
//        }
//    }
    
    if ([[_game.correctNess objectAtIndex:((_theGlowingBox - 4 * _currentBoxSet) % 5 - 1)] integerValue] == 1)
    {
        [self resumeTouch];
        [self glowGreenAtIndex:_theGlowingBox - 1];
        
        if (_theGameMode == gameModeNormal)
        {
            [_enables replaceObjectAtIndex:_theGlowingBox - 1 withObject:@(0)];
            if (_theGlowingBox < 4)
            {
                [self glowBoxAtIndex:_theGlowingBox + 1];
            }
            else
            {
                [self glowBoxAtIndex:1];
            }
        }
        else if (_theGameMode == gameModeInfinity)
        {
            if (((_theGlowingBox + 1) % 4) == 1)
            {
                NSLog(@"this case");
                _currentBoxSet = (_theGlowingBox) / 4;
                [self createBoxesOfBoxSet:_currentBoxSet];
                [self moveToBoxToSet:_currentBoxSet];
                [_game generateNewAnswer];
            }
            //NSLog(@"availableTries = %ld",_game.availableTries);
            _totalTries = _game.availableTries;
            _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
            [_availableTries setProgress:1.0f animated:YES];
            //NSLog(@"glow blue at box = %ld",_theGlowingBox + 1);
            [self glowBoxAtIndex:_theGlowingBox + 1];
        }
        else if (_theGameMode == gameModeLevelUp)
        {
            [_enables replaceObjectAtIndex:_theGlowingBox - 1 withObject:@(0)];
            if (_theGlowingBox < 4)
            {
                [self glowBoxAtIndex:_theGlowingBox + 1];
            }
            else
            {
                [self glowBoxAtIndex:1];
            }
            progress = (CGFloat)((CGFloat)_game.availableTries/(CGFloat)_totalTries);
            if (progress < 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.965f green:0.784f blue:0.208f alpha:1.00f];
            }
            else if (progress < 0.25f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f];
            }
            else if (progress >= 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
            }
            [_availableTries setProgress:progress animated:YES];
        }
    }
    //wrong
    else
    {
        if (_theGameMode == gameModeInfinity)
        {
            progress = (CGFloat)((CGFloat)_game.availableTries/(CGFloat)_totalTries);
            if (progress < 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.965f green:0.784f blue:0.208f alpha:1.00f];
            }
            else if (progress < 0.25f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f];
            }
            else if (progress >= 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
            }
            [_availableTries setProgress:progress animated:YES];
        }
        else if (_theGameMode == gameModeLevelUp)
        {
            progress = (CGFloat)((CGFloat)_game.availableTries/(CGFloat)_totalTries);
            if (progress < 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.965f green:0.784f blue:0.208f alpha:1.00f];
            }
            else if (progress < 0.25f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.929f green:0.173f blue:0.137f alpha:1.00f];
            }
            else if (progress >= 0.50f)
            {
                _availableTries.progressBarProgressColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
            }
            [_availableTries setProgress:progress animated:YES];
        }
        [self resumeTouch];
        [self shakeBoxAtIndex:_theGlowingBox - 1];
    }
}

- (void)showSuccess
{
    if (_theGameMode == gameModeNormal)
    {
        [self cancelShake];
        [_game endGameWithDuration:[_timer remainingDurationInSeconds]];
    }
    else if (_theGameMode == gameModeInfinity)
    {
        [_game endGameWithDuration:[_timerLabel getTimeCounted]];
    }
    else if (_theGameMode == gameModeLevelUp)
    {
        [_game levelUpWithDuration:[_timer remainingDurationInSeconds]];
    }
    _guideLabel.text = @"";
    [self disableTouchOnBox];
    AlertViewController *success = [[AlertViewController alloc] initWithGame:_game];
    RWBlurPopover *pop = [[RWBlurPopover alloc] initWithContentViewController:success];
    pop.throwingGestureEnabled = NO;
    pop.tapBlurToDismissEnabled = NO;
    [pop showInViewController:self];
}

- (void)toolButtonHighlighted:(UIButton *)sender
{
    [self disableTouchOnOthersExcept:sender.tag];
    switch (sender.tag) {
        //delete button
        case -1:
        {
            sender.backgroundColor = [[UIColor colorWithRed:0.941f green:0.608f blue:0.173f alpha:1.00f] colorWithAlphaComponent:0.1f];
            sender.layer.borderColor = [UIColor colorWithRed:0.941f green:0.608f blue:0.173f alpha:1.00f].CGColor;
        }
            break;
        //clear button
        case -2:
        {
            sender.backgroundColor = [[UIColor colorWithRed:0.812f green:0.333f blue:0.098f alpha:1.00f] colorWithAlphaComponent:0.1f];
            sender.layer.borderColor = [UIColor colorWithRed:0.812f green:0.333f blue:0.098f alpha:1.00f].CGColor;
        }
            break;
        //restart button
        case -3:
        {
            sender.backgroundColor = [[UIColor colorWithRed:0.737f green:0.231f blue:0.188f alpha:1.00f] colorWithAlphaComponent:0.1f];
            sender.layer.borderColor = [UIColor colorWithRed:0.737f green:0.231f blue:0.188f alpha:1.00f].CGColor;
        }
            break;
        //hint button
        case -4:
        {
            sender.backgroundColor = [[UIColor colorWithRed:0.224f green:0.675f blue:0.388f alpha:1.00f] colorWithAlphaComponent:0.1f];
            sender.layer.borderColor = [UIColor colorWithRed:0.224f green:0.675f blue:0.388f alpha:1.00f].CGColor;
        }
            break;
            
        default:
            break;
    }
}

- (void)toolButtonNormal:(UIButton *)sender
{
    [self resumeTouch];
    sender.backgroundColor = [UIColor clearColor];
    switch (sender.tag) {
            //delete button
        case -1:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f].CGColor;
            if (_theGlowingBox == 0)
            {
                return;
            }
            else
            {
                JTNumberScrollAnimatedView *temp = (JTNumberScrollAnimatedView *)[_boxArray objectAtIndex:_theGlowingBox - 1];
                if (temp.isUserInteractionEnabled)
                {
                    temp.value = @"?";
                }
            }
        }
            break;
            //clear button
        case -2:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f].CGColor;
            if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
            {
                for (JTNumberScrollAnimatedView *temp in _boxArray)
                {
                    if (temp.isUserInteractionEnabled)
                    {
                        temp.value = @"?";
                    }
                }
            }
        }
            break;
            //restart button
        case -3:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f].CGColor;
            [self restart];
        }
            break;
            //hint button
        case -4:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
            [_game generateHintOfDigit:(_theGlowingBox - 4 * _currentBoxSet)%5];
            self.guideLabel.text = _game.hintMessage;
        }
            break;
            
        default:
            break;
    }
}

- (void)remindTime
{
    _guideLabel.text = [NSString stringWithFormat:@"There is only %ld seconds remaining",(long)[_timer remainingDurationInSeconds]];
}

- (void)resumeTouch
{
    for (UIButton *number in  _numberArray)
    {
        number.userInteractionEnabled = YES;
    }
    _deleteOneButton.userInteractionEnabled = YES;
    _clearButton.userInteractionEnabled = YES;
    _restartButton.userInteractionEnabled = YES;
    _hintButton.userInteractionEnabled = YES;
    
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        for (int i = 0; i < _boxArray.count; i++)
        {
            JTNumberScrollAnimatedView *temp = [_boxArray objectAtIndex:i];
            if ([[_enables objectAtIndex:i] integerValue] != 0)
            {
                temp.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)disableTouchOnOthersExcept:(NSInteger)index
{
    
    if (index >= 0)
    {
        for (UIButton *number in _numberArray)
        {
            if (number.tag != index)
            {
                number.userInteractionEnabled = NO;
            }
        }
        _deleteOneButton.userInteractionEnabled = NO;
        _clearButton.userInteractionEnabled = NO;
        _restartButton.userInteractionEnabled = NO;
        _hintButton.userInteractionEnabled = NO;
    }
    else
    {
        for (UIButton *number in _numberArray)
        {
            number.userInteractionEnabled = NO;
        }
        switch (index) {
            case -1:
            {
                _clearButton.userInteractionEnabled = NO;
                _restartButton.userInteractionEnabled = NO;
                _hintButton.userInteractionEnabled = NO;
            }
                break;
            case -2:
            {
                _deleteOneButton.userInteractionEnabled = NO;
                _restartButton.userInteractionEnabled = NO;
                _hintButton.userInteractionEnabled = NO;
            }
                break;
            case -3:
            {
                _deleteOneButton.userInteractionEnabled = NO;
                _clearButton.userInteractionEnabled = NO;
                _hintButton.userInteractionEnabled = NO;
            }
                break;
            case -4:
            {
                _deleteOneButton.userInteractionEnabled = NO;
                _clearButton.userInteractionEnabled = NO;
                _restartButton.userInteractionEnabled = NO;
            }
                break;
            case -5:
            {
                _deleteOneButton.userInteractionEnabled = NO;
                _clearButton.userInteractionEnabled = NO;
                _restartButton.userInteractionEnabled = NO;
                _hintButton.userInteractionEnabled = NO;
            }
            default:
                break;
        }
    }
    if (_theGameMode == gameModeNormal || _theGameMode == gameModeLevelUp)
    {
        for (JTNumberScrollAnimatedView *view in _boxArray)
        {
            view.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - JSKTimerDelegate
- (void)timerDidFinish:(JSKTimerView *)timerView
{
    //NSLog(@"shaking");
    [self showSuccess];
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
