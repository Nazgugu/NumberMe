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
//#import <pop/POP.h>

@interface GameViewController ()

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

//digit boxes
@property (nonatomic, strong) JTNumberScrollAnimatedView *firstDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *secondDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *thirdDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *forthDigit;

//tool buttons
@property (nonatomic, strong) UIButton *deleteOneButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *hintButton;

//top guide label
@property (nonatomic, strong) YETIFallingLabel *guideLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //first init 10 round digit buttons
    
    _verticalGap = 20.0f;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _gapSize = 28.0f;
        _verticalGap = 10.0f;
        _boxHeight = 60.0f;
        _toolButtonHeight = 25.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10,0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 10)];
    }
    else if (IS_IPHONE_5)
    {
        _gapSize = 25.0f;
        _verticalGap = 15.0f;
        _boxHeight = 65.0f;
        _toolButtonHeight = 28.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 20)];
    }
    else if (IS_IPHONE_6)
    {
        _gapSize = 30.0f;
        _boxHeight = 80.0f;
        _toolButtonHeight = 33.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 20)];
    }
    else
    {
        _gapSize = 35.0f;
        _boxHeight = 95.0f;
        _toolButtonHeight = 38.0f;
        _guideLabel = [[YETIFallingLabel alloc] initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 10, 0, SCREENWIDTH - 2 * (_backButton.frame.origin.x + _backButton.frame.size.width + 10), _backButton.frame.size.height + 20)];
    }
    
    _guideLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    _guideLabel.textAlignment = NSTextAlignmentCenter;
    _guideLabel.text = @"Guess A Four Digit Number";
    
    [self.view addSubview:_guideLabel];
    [self initButtons];
    [self createBoxes];
    [self createLine];
    [self initToolButton];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    _guideLabel.text = @"Ready?";
    [self performSelector:@selector(animateGo) withObject:nil afterDelay:1.5f];
}

- (void)animateGo{
    _guideLabel.text = @"GO!";
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
    [_deleteOneButton setTitle:@"Delete" forState:UIControlStateNormal];
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
    [_clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _clearButton.titleLabel.minimumScaleFactor = 0.5f;
    _clearButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _clearButton.tintColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f];
    _clearButton.alpha = 0;
    _clearButton.tag = -1;
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
    [_restartButton setTitle:@"Restart" forState:UIControlStateNormal];
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
    [_hintButton setTitle:@"Hint" forState:UIControlStateNormal];
    _hintButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _hintButton.titleLabel.minimumScaleFactor = 0.5f;
    _hintButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _hintButton.tintColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
    _hintButton.alpha = 0;
    _hintButton.tag = -4;
    [_hintButton addTarget:self action:@selector(toolButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_hintButton addTarget:self action:@selector(toolButtonNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hintButton];

}

//create four boxes
- (void)createBoxes
{
    _boxWidth = (SCREENWIDTH - 5 * _gapSize) / 4;
    
    //first digit
    _firstDigit = [[JTNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(_gapSize, SCREEN_HEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight, _boxWidth, _boxHeight)];
    _firstDigit.layer.borderWidth = 2.0f;
    _firstDigit.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _firstDigit.layer.cornerRadius = 8.0f;
    _firstDigit.layer.masksToBounds = YES;
    _firstDigit.textColor = [UIColor whiteColor];
    _firstDigit.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
    _firstDigit.minLength = 1;
    [self.view addSubview:_firstDigit];
    
    //second digit
    _secondDigit = [[JTNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(_gapSize * 2 + _boxWidth, SCREEN_HEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight, _boxWidth, _boxHeight)];
    _secondDigit.layer.borderWidth = 2.0f;
    _secondDigit.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _secondDigit.layer.cornerRadius = 8.0f;
    _secondDigit.layer.masksToBounds = YES;
    _secondDigit.textColor = [UIColor whiteColor];
    _secondDigit.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
    _secondDigit.minLength = 1;
    [self.view addSubview:_secondDigit];
    
    //third digit
    _thirdDigit = [[JTNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(_gapSize * 3 + _boxWidth * 2, SCREEN_HEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight, _boxWidth, _boxHeight)];
    _thirdDigit.layer.borderWidth = 2.0f;
    _thirdDigit.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _thirdDigit.layer.cornerRadius = 8.0f;
    _thirdDigit.layer.masksToBounds = YES;
    _thirdDigit.textColor = [UIColor whiteColor];
    _thirdDigit.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
    _thirdDigit.minLength = 1;
    [self.view addSubview:_thirdDigit];
    
    //forth digit
    _forthDigit = [[JTNumberScrollAnimatedView alloc] initWithFrame:CGRectMake(_gapSize * 4 + _boxWidth * 3, SCREEN_HEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight, _boxWidth, _boxHeight)];
    _forthDigit.layer.borderWidth = 2.0f;
    _forthDigit.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _forthDigit.layer.cornerRadius = 8.0f;
    _forthDigit.layer.masksToBounds = YES;
    _forthDigit.textColor = [UIColor whiteColor];
    _forthDigit.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
    _forthDigit.minLength = 1;
    [self.view addSubview:_forthDigit];
}

- (void)initButtons
{
    _buttonSize = (SCREENWIDTH - 4 * _gapSize) / 3;
    
    //debug
    NSLog(@"_gap size = %lf, button size = %lf",_gapSize, _buttonSize);
    
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
    [_firstDigit setValue:@"?"];
    [_firstDigit startAnimation];
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
    [_secondDigit setValue:@"?"];
    [_secondDigit startAnimation];
}

- (void)animateDigitThree
{
    [_thirdDigit setValue:@"?"];
    [_thirdDigit startAnimation];
}

- (void)animateDigitFour
{
    [_forthDigit setValue:@"?"];
    [_forthDigit startAnimation];
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
    sender.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    sender.layer.borderColor = [UIColor colorWithRed:0.780f green:0.937f blue:0.965f alpha:1.00f].CGColor;
}

- (void)buttonNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
}

- (void)toolButtonHighlighted:(UIButton *)sender
{
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
    sender.backgroundColor = [UIColor clearColor];
    switch (sender.tag) {
            //delete button
        case -1:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f].CGColor;
        }
            break;
            //clear button
        case -2:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f].CGColor;
        }
            break;
            //restart button
        case -3:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f].CGColor;
        }
            break;
            //hint button
        case -4:
        {
            sender.layer.borderColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
        }
            break;
            
        default:
            break;
    }
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
