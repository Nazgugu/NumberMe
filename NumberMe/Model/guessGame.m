//
//  guessGame.m
//  
//
//  Created by Liu Zhe on 15/8/8.
//
//

#import "guessGame.h"
#import "EGOCache.h"

NSString * const kGameScore = @"gameScore";
NSString * const kGameDate = @"gameDate";
NSString * const kNumberTries = @"numberOfTries";
NSString * const kCorrectNumber = @"correctNumber";
NSString * const kGameDuration = @"gameDuration";
NSString * const kGameResult = @"result";
NSString * const kHintUsed = @"hintUsed";


@implementation guessGame

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:_gameScore] forKey:kGameScore];
    [aCoder encodeObject:_dateString forKey:kGameDate];
    [aCoder encodeObject:[NSNumber numberWithInteger:_numberOfTries] forKey:kNumberTries];
    [aCoder encodeObject:[NSNumber numberWithInteger:_correctNumber] forKey:kCorrectNumber];
    [aCoder encodeObject:[NSNumber numberWithInteger:_duration] forKey:kGameDuration];
    if (_succeed == 2)
    {
        [aCoder encodeObject:[NSNumber numberWithBool:YES] forKey:kGameResult];
    }
    else
    {
        [aCoder encodeObject:[NSNumber numberWithBool:NO] forKey:kGameResult];
    }
    [aCoder encodeObject:[NSNumber numberWithInteger:(4 - _availabelHints)] forKey:kHintUsed];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.gameScore = [[aDecoder decodeObjectForKey:kGameScore] integerValue];
        self.dateString = [aDecoder decodeObjectForKey:kGameDate];
        self.numberOfTries = [[aDecoder decodeObjectForKey:kNumberTries] integerValue];
        self.correctNumber = [[aDecoder decodeObjectForKey:kCorrectNumber] integerValue];
        BOOL succeed = [[aDecoder decodeObjectForKey:kGameResult] boolValue];
        if (succeed)
        {
            self.succeed = 2;
        }
        else
        {
            self.succeed = 1;
        }
        self.duration = [[aDecoder decodeObjectForKey:kGameDuration] integerValue];
        self.availabelHints = 4 - [[aDecoder decodeObjectForKey:kHintUsed] integerValue];
    }
    return self;
}

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
        _correctNumber = 0;
        
        _correctNess = [[NSMutableArray alloc] initWithObjects:@(0),@(0),@(0),@(0), nil];
        
        _numberOfTries = 0;
        
        //NSLog(@"correct answer = %ld",(long)_gameAnswer);
        
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
            NSLog(@"correct!");
            _succeed = 2;
        }
        else
        {
            NSLog(@"not correct!");
            _succeed = 1;
        }
    }
}

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer
{
    NSString *feedBackString = @"";
    
    _numberOfTries += 1;
    
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

//Total score is 1000, for each correct answer we give 100 and for each second past we deduct 10, for each hint used we give 75
- (void)endGameWithDuration:(NSInteger)secondsLeft
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    _dateString = [formatter stringFromDate:[NSDate date]];
    
    _duration = 30 - secondsLeft;
    
    //全部正确的情况
    if (_succeed == 2)
    {
        _gameScore = 400;
        _correctNumber = 4;
    }
    else
    {
        for (NSNumber *correct in _correctNess)
        {
            if ([correct integerValue] == 1)
            {
                //NSLog(@"one correct");
                _gameScore += 100;
                //NSLog(@"game score = %ld",_gameScore);
                _correctNumber = _correctNumber + 1;
            }
        }
    }
    _gameScore = secondsLeft * 10 + _availabelHints * 75 + _gameScore - _numberOfTries * 2;
    
    //record the game
    NSData *gameData = [[EGOCache globalCache] dataForKey:@"games"];
    NSMutableArray *games = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
    [games addObject:self];
    gameData = [NSKeyedArchiver archivedDataWithRootObject:games];
    [[EGOCache globalCache] setData:gameData forKey:@"games"];
}

@end
