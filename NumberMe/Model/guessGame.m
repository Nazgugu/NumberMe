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
NSString * const kDateOfGame = @"dateOfGame";


@implementation guessGame

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:_gameScore] forKey:kGameScore];
    [aCoder encodeObject:_dateString forKey:kGameDate];
    [aCoder encodeObject:[NSNumber numberWithInteger:_numberOfTries] forKey:kNumberTries];
    [aCoder encodeObject:[NSNumber numberWithInteger:_correctNumber] forKey:kCorrectNumber];
    [aCoder encodeObject:[NSNumber numberWithInteger:_duration] forKey:kGameDuration];
    [aCoder encodeObject:_dateOfGame forKey:kDateOfGame];
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
        self.dateOfGame = [aDecoder decodeObjectForKey:kDateOfGame];
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
        
        _firstHint = NO;
        _secondHint = NO;
        _thirdHint = NO;
        _forthHint = NO;
        
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

- (void)generateHintOfDigit:(NSInteger)digit
{
    //1 for plus, 0 for minus
    NSInteger sign = arc4random() % 2;
    //0 for 1, 1 for 2
    NSInteger number = arc4random() % 2;
    
    if (number == 0)
    {
        number = 1;
    }
    else
    {
        number = 2;
    }
    
    NSInteger hintNumber;
    
    switch (digit) {
        case 1:
        {
            if (!_firstHint)
            {
                _availabelHints -= 1;
                _firstHint = YES;
            }
            if (sign == 0)
            {
                hintNumber = _answerFirstDigit - number;
                if (hintNumber < 0)
                {
                    hintNumber = _answerFirstDigit + number;
                }
            }
            else
            {
                hintNumber = _answerFirstDigit + number;
                if (hintNumber > 9)
                {
                    hintNumber = _answerFirstDigit - number;
                }
            }
        }
            break;
        case 2:
        {
            if (!_secondHint)
            {
                _availabelHints -= 1;
                _secondHint = YES;
            }
            if (sign == 0)
            {
                hintNumber = _answerSecondDigit - number;
                if (hintNumber < 0)
                {
                    hintNumber = _answerSecondDigit + number;
                }
            }
            else
            {
                hintNumber = _answerSecondDigit + number;
                if (hintNumber > 9)
                {
                    hintNumber = _answerSecondDigit - number;
                }
            }
        }
            break;
        case 3:
        {
            if (!_thirdHint)
            {
                _availabelHints -= 1;
                _thirdHint = YES;
            }
            if (sign == 0)
            {
                hintNumber = _answerThirdDigit - number;
                if (hintNumber < 0)
                {
                    hintNumber = _answerThirdDigit + number;
                }
            }
            else
            {
                hintNumber = _answerThirdDigit + number;
                if (hintNumber > 9)
                {
                    hintNumber = _answerThirdDigit - number;
                }
            }
        }
            break;
        case 4:
        {
            if (!_forthHint)
            {
                _availabelHints -= 1;
                _forthHint = YES;
            }
            if (sign == 0)
            {
                hintNumber = _answerForthDigit - number;
                if (hintNumber < 0)
                {
                    hintNumber = _answerForthDigit + number;
                }
            }
            else
            {
                hintNumber = _answerForthDigit + number;
                if (hintNumber > 9)
                {
                    hintNumber = _answerForthDigit - number;
                }
            }
        }
            break;
        default:
            break;
    }
    
    _hintMessage = [NSString stringWithFormat:NSLocalizedString(@"HINTMSG", nil),hintNumber];
}

- (void)verifyAnswer
{
//    if (_userFirstDigit == _answerFirstDigit)
//    {
//        [_correctNess replaceObjectAtIndex:0 withObject:@(1)];
//    }
//    else
//    {
//        [_correctNess replaceObjectAtIndex:0 withObject:@(0)];
//    }
//    if (_userSecondDigit == _answerSecondDigit)
//    {
//        [_correctNess replaceObjectAtIndex:1 withObject:@(1)];
//    }
//    else
//    {
//        [_correctNess replaceObjectAtIndex:1 withObject:@(0)];
//    }
//    if (_userThirdDigit == _answerThirdDigit)
//    {
//        [_correctNess replaceObjectAtIndex:2 withObject:@(1)];
//    }
//    else
//    {
//        [_correctNess replaceObjectAtIndex:2 withObject:@(0)];
//    }
//    if (_userForthDigit == _answerForthDigit)
//    {
//        [_correctNess replaceObjectAtIndex:3 withObject:@(1)];
//    }
//    else
//    {
//        [_correctNess replaceObjectAtIndex:3 withObject:@(0)];
//    }
//    
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
            //NSLog(@"correct!");
            _succeed = 2;
        }
        else
        {
            //NSLog(@"not correct!");
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
                feedBackString = NSLocalizedString(@"RIGHT", nil);
                [_correctNess replaceObjectAtIndex:0 withObject:@(1)];
            }
            else
            {
                difference = labs(_userFirstDigit - _answerFirstDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = NSLocalizedString(@"FAR", nil);
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = NSLocalizedString(@"MAYBE", nil);
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = NSLocalizedString(@"NEAR", nil);
                }
            }
        }
            break;
        case 2:
        {
            _userSecondDigit = answer;
            if (_userSecondDigit == _answerSecondDigit)
            {
                feedBackString = NSLocalizedString(@"RIGHT", nil);
                [_correctNess replaceObjectAtIndex:1 withObject:@(1)];
            }
            else
            {
                difference = labs(_userSecondDigit - _answerSecondDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = NSLocalizedString(@"FAR", nil);
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = NSLocalizedString(@"MAYBE", nil);
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = NSLocalizedString(@"NEAR", nil);
                }
            }
        }
            break;
        case 3:
        {
            _userThirdDigit = answer;
            if (_userThirdDigit == _answerThirdDigit)
            {
                feedBackString = NSLocalizedString(@"RIGHT", nil);
                [_correctNess replaceObjectAtIndex:2 withObject:@(1)];
            }
            else
            {
                difference = labs(_userThirdDigit - _answerThirdDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = NSLocalizedString(@"FAR", nil);
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = NSLocalizedString(@"MAYBE", nil);
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = NSLocalizedString(@"NEAR", nil);
                }
            }
        }
            break;
        case 4:
        {
            _userForthDigit = answer;
            if (_userForthDigit == _answerForthDigit)
            {
                feedBackString = NSLocalizedString(@"RIGHT", nil);
                [_correctNess replaceObjectAtIndex:3 withObject:@(1)];
            }
            else
            {
                difference = labs(_userForthDigit - _answerForthDigit);
                //7,8,9
                if (difference > 6)
                {
                    feedBackString = NSLocalizedString(@"FAR", nil);
                }
                //4,5,6
                else if (difference <= 6 && difference >= 4)
                {
                    feedBackString = NSLocalizedString(@"MAYBE", nil);
                }
                //1,2,3
                else if (difference < 4 && difference >= 1)
                {
                    feedBackString = NSLocalizedString(@"NEAR", nil);
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
    _dateOfGame = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    _dateString = [formatter stringFromDate:[NSDate date]];
    
    _duration = 30 - secondsLeft;
    
    NSInteger baseScore = arc4random() % 200 + 100;
    _gameScore += baseScore;
    
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
    _gameScore += secondsLeft * 10 + _availabelHints * 75 - _numberOfTries * 5 - (arc4random() % 25) * (4 - _availabelHints);
    
    //NSLog(@"correct number = %ld",_correctNumber);
    
    //record the game
    NSData *gameData = [[EGOCache globalCache] dataForKey:@"games"];
    NSMutableArray *games = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
    [games addObject:self];
    gameData = [NSKeyedArchiver archivedDataWithRootObject:games];
    [[EGOCache globalCache] setData:gameData forKey:@"games"];
}

@end
