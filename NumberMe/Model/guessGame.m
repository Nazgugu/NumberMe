//
//  guessGame.m
//  
//
//  Created by Liu Zhe on 15/8/8.
//
//

#import "guessGame.h"

@implementation guessGame

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _succeed = 0;
        _userFirstDigit = -1;
        _userSecondDigit = -1;
        _userThirdDigit = -1;
        _userForthDigit = -1;
        _gameScore = 0;
        _gameAnswer = arc4random() % 10000;
        _availabelHints = 4;
        
        _correctNess = [[NSMutableArray alloc] initWithObjects:@(0),@(0),@(0),@(0), nil];
        
        [self calculateDigits];
        
    }
    return self;
}

- (void)calculateDigits
{
    if (_gameAnswer < 10)
    {
        _answerFirstDigit = 0;
        _answerSecondDigit = 0;
        _answerThirdDigit = 0;
        _answerForthDigit = _gameAnswer;
    }
    else if (_gameAnswer < 100)
    {
        _answerFirstDigit = 0;
        _answerSecondDigit = 0;
        _answerForthDigit = _gameAnswer % 10;
        _answerThirdDigit = (_gameAnswer - _answerForthDigit) / 10;
    }
    else if (_gameAnswer < 1000)
    {
        _answerFirstDigit = 0;
        _answerSecondDigit = (_gameAnswer - (_gameAnswer % 100)) / 100;
        _answerThirdDigit = ((_gameAnswer - (100 * _answerSecondDigit)) - (_gameAnswer - (100 * _answerSecondDigit)) % 10) / 10;
        _answerForthDigit = _gameAnswer - (100 * _answerSecondDigit) - (10 * _answerThirdDigit);
    }
    else
    {
        NSInteger y,z;
        y = _gameAnswer % 1000;
        z = y % 100;
        _answerForthDigit = z % 10;
        _answerThirdDigit = (z - _answerForthDigit) / 10;
        _answerSecondDigit = (y - z) / 100;
        _answerFirstDigit = (_gameAnswer - y) / 1000;
    }
}

- (void)generateHint
{
    if ((_userFirstDigit != -1) && (_userSecondDigit != -1) && (_userThirdDigit != -1) && (_userForthDigit != -1))
    {
        [self verifyAnswer];
    }
    else
    {
        _succeed = 0;
    }
}

- (void)verifyAnswer
{
    
}

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer
{
    NSString *feedBackString = @"";
    
    switch (boxNum) {
        case 1:
        {
            _userFirstDigit = answer;
        }
            break;
        case 2:
        {
            _userSecondDigit = answer;
        }
            break;
        case 3:
        {
            _userThirdDigit = answer;
        }
            break;
        case 4:
        {
            _userForthDigit = answer;
        }
            break;
        default:
            break;
    }
    
    return feedBackString;
}

@end
