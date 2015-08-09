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
        _allWrong = YES;
        
        _correctNess = [[NSMutableArray alloc] initWithObjects:@(0),@(0),@(0),@(0), nil];
        
        NSLog(@"correct answer = %ld",(long)_gameAnswer);
        
        [self calculateDigits];
        NSLog(@"%ld, %ld, %ld, %ld",_answerFirstDigit, _answerSecondDigit, _answerThirdDigit, _answerForthDigit);
        
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
    if (_userFirstDigit == _answerFirstDigit)
    {
        [_correctNess replaceObjectAtIndex:0 withObject:@(1)];
    }
    else
    {
        [_correctNess replaceObjectAtIndex:0 withObject:@(0)];
    }
    if (_userSecondDigit == _answerSecondDigit)
    {
        [_correctNess replaceObjectAtIndex:1 withObject:@(1)];
    }
    else
    {
        [_correctNess replaceObjectAtIndex:1 withObject:@(0)];
    }
    if (_userThirdDigit == _answerThirdDigit)
    {
        [_correctNess replaceObjectAtIndex:2 withObject:@(1)];
    }
    else
    {
        [_correctNess replaceObjectAtIndex:2 withObject:@(0)];
    }
    if (_userForthDigit == _answerForthDigit)
    {
        [_correctNess replaceObjectAtIndex:3 withObject:@(1)];
    }
    else
    {
        [_correctNess replaceObjectAtIndex:3 withObject:@(0)];
    }
    
    for (int i = 0; i < 4; i++)
    {
        //0 incorrect, 1 correct
        if ([[_correctNess objectAtIndex:i] integerValue] == 1)
        {
            _allWrong = NO;
        }
    }
    
    NSInteger userAnswer = _userFirstDigit * 1000 + _userSecondDigit * 100 + _userThirdDigit * 10 + _userForthDigit;
    
    if ((_userFirstDigit != -1) && (_userSecondDigit != -1) && (_userThirdDigit != -1) && (_userForthDigit != -1))
    {
        if (userAnswer == _gameAnswer)
        {
            _succeed = 2;
        }
        else
        {
            _succeed = 1;
        }
    }
}

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer
{
    NSString *feedBackString = @"";
    
    NSUInteger difference;
    
    switch (boxNum) {
        case 1:
        {
            _userFirstDigit = answer;
            if (_userFirstDigit == _answerFirstDigit)
            {
                feedBackString = @"This is probably the answer!";
            }
            else
            {
                difference = labs(_userFirstDigit - _answerFirstDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = @"Input is far from the answer";
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = @"Input has some difference from the answer";
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = @"Input is quite near the answer";
                }
            }
        }
            break;
        case 2:
        {
            _userSecondDigit = answer;
            if (_userSecondDigit == _answerSecondDigit)
            {
                feedBackString = @"This is probably the answer!";
            }
            else
            {
                difference = labs(_userSecondDigit - _answerSecondDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = @"Input is far from the answer";
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = @"Input has some difference from the answer";
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = @"Input is quite near the answer";
                }
            }
        }
            break;
        case 3:
        {
            _userThirdDigit = answer;
            if (_userThirdDigit == _answerThirdDigit)
            {
                feedBackString = @"This is probably the answer!";
            }
            else
            {
                difference = labs(_userThirdDigit - _answerThirdDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = @"Input is far from the answer";
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = @"Input has some difference from the answer";
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = @"Input is quite near the answer";
                }
            }
        }
            break;
        case 4:
        {
            _userForthDigit = answer;
            if (_userForthDigit == _answerForthDigit)
            {
                feedBackString = @"This is probably the answer!";
            }
            else
            {
                difference = labs(_userForthDigit - _answerForthDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = @"Input is far from the answer";
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = @"Input has some difference from the answer";
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = @"Input is quite near the answer";
                }
            }
        }
            break;
        default:
            break;
    }
    
    [self verifyAnswer];
    
    return feedBackString;
}

@end
