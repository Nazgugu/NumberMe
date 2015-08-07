//
//  GameViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//

#import "GameViewController.h"
#import "JTNumberScrollAnimatedView.h"
//#import <pop/POP.h>

@interface GameViewController ()

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

@property (nonatomic, strong) JTNumberScrollAnimatedView *firstDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *secondDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *thirdDigit;
@property (nonatomic, strong) JTNumberScrollAnimatedView *forthDigit;

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
    }
    else if (IS_IPHONE_5)
    {
        _gapSize = 25.0f;
        _boxHeight = 65.0f;
    }
    else if (IS_IPHONE_6)
    {
        _gapSize = 30.0f;
        _boxHeight = 80.0f;
    }
    else
    {
        _gapSize = 35.0f;
        _boxHeight = 95.0f;
    }
    [self initButtons];
    [self createBoxes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self commitAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    _numberZero.layer.borderWidth = 1.0f;
    _numberZero.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberZero.layer.cornerRadius = _buttonSize / 2;
    _numberZero.layer.masksToBounds = YES;
    [_numberZero setTitle:@"0" forState:UIControlStateNormal];
    [_numberZero setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberZero.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberZero];
    //number one
    if (!_numberOne)
    {
        _numberOne = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberOne.layer.borderWidth = 1.0f;
    _numberOne.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberOne.layer.cornerRadius = _buttonSize / 2;
    _numberOne.layer.masksToBounds = YES;
    [_numberOne setTitle:@"1" forState:UIControlStateNormal];
    [_numberOne setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberOne.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
//    _numberOne.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:_numberOne];
    //number two
    if (!_numberTwo)
    {
        _numberTwo = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberTwo.layer.borderWidth = 1.0f;
    _numberTwo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberTwo.layer.cornerRadius = _buttonSize / 2;
    _numberTwo.layer.masksToBounds = YES;
    [_numberTwo setTitle:@"2" forState:UIControlStateNormal];
    [_numberTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberTwo.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberTwo];
    //number three
    if (!_numberThree)
    {
        _numberThree = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberThree.layer.borderWidth = 1.0f;
    _numberThree.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberThree.layer.cornerRadius = _buttonSize / 2;
    _numberThree.layer.masksToBounds = YES;
    [_numberThree setTitle:@"3" forState:UIControlStateNormal];
    [_numberThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberThree.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberThree];
    //number four
    if (!_numberFour)
    {
        _numberFour = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberFour.layer.borderWidth = 1.0f;
    _numberFour.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberFour.layer.cornerRadius = _buttonSize / 2;
    _numberFour.layer.masksToBounds = YES;
    [_numberFour setTitle:@"4" forState:UIControlStateNormal];
    [_numberFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberFour.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberFour];
    //number five
    if (!_numberFive)
    {
        _numberFive = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberFive.layer.borderWidth = 1.0f;
    _numberFive.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberFive.layer.cornerRadius = _buttonSize / 2;
    _numberFive.layer.masksToBounds = YES;
    [_numberFive setTitle:@"5" forState:UIControlStateNormal];
    [_numberFive setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberFive.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberFive];
    //number six
    if (!_numberSix)
    {
        _numberSix = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberSix.layer.borderWidth = 1.0f;
    _numberSix.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberSix.layer.cornerRadius = _buttonSize / 2;
    _numberSix.layer.masksToBounds = YES;
    [_numberSix setTitle:@"6" forState:UIControlStateNormal];
    [_numberSix setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberSix.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberSix];
    //number seven
    if (!_numberSeven)
    {
        _numberSeven = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberSeven.layer.borderWidth = 1.0f;
    _numberSeven.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberSeven.layer.cornerRadius = _buttonSize / 2;
    _numberSeven.layer.masksToBounds = YES;
    [_numberSeven setTitle:@"7" forState:UIControlStateNormal];
    [_numberSeven setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberSeven.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberSeven];
    //number eight
    if (!_numberEight)
    {
        _numberEight = [[UIButton alloc] initWithFrame:CGRectMake(_buttonSize + 2 * _gapSize, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberEight.layer.borderWidth = 1.0f;
    _numberEight.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberEight.layer.cornerRadius = _buttonSize / 2;
    _numberEight.layer.masksToBounds = YES;
    [_numberEight setTitle:@"8" forState:UIControlStateNormal];
    [_numberEight setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberEight.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberEight];
    //number nine
    if (!_numberNine)
    {
        _numberNine = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize * 3 + _buttonSize * 2, SCREENHEIGHT, _buttonSize, _buttonSize)];
    }
    _numberNine.layer.borderWidth = 1.0f;
    _numberNine.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
    _numberNine.layer.cornerRadius = _buttonSize / 2;
    _numberNine.layer.masksToBounds = YES;
    [_numberNine setTitle:@"9" forState:UIControlStateNormal];
    [_numberNine setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    _numberNine.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:27.0f];
    [self.view addSubview:_numberNine];

}

- (void)commitAnimation
{
    [self animatButtonOne];
    [self performSelector:@selector(animateButtonTwo) withObject:nil afterDelay:0.2f];
    [self performSelector:@selector(animateButtonThree) withObject:nil afterDelay:0.3f];
    [self animateDigits];
}

- (void)animateDigits
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
