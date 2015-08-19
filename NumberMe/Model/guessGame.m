//
//  guessGame.m
//  
//
//  Created by Liu Zhe on 15/8/8.
//
//

#import "guessGame.h"
#import "EGOCache.h"

NSString * const kGameMode = @"gameMode";
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
    [aCoder encodeObject:[NSNumber numberWithInteger:_correctNumber] forKey:kCorrectNumber];
    [aCoder encodeObject:[NSNumber numberWithInteger:_duration] forKey:kGameDuration];
    [aCoder encodeObject:_dateOfGame forKey:kDateOfGame];
    [aCoder encodeObject:[NSNumber numberWithInteger:_gameMode] forKey:kGameMode];
    
    if (_gameMode == gameModeNormal)
    {
        [aCoder encodeObject:[NSNumber numberWithInteger:_numberOfTries] forKey:kNumberTries];
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
    else if (_gameMode == gameModeInfinity)
    {
        [aCoder encodeObject:[NSNumber numberWithInteger:_hintUsed] forKey:kHintUsed];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.gameMode = [[aDecoder decodeObjectForKey:kGameMode] integerValue];
        self.gameScore = [[aDecoder decodeObjectForKey:kGameScore] integerValue];
        self.dateString = [aDecoder decodeObjectForKey:kGameDate];
        self.correctNumber = [[aDecoder decodeObjectForKey:kCorrectNumber] integerValue];
        self.dateOfGame = [aDecoder decodeObjectForKey:kDateOfGame];
        self.duration = [[aDecoder decodeObjectForKey:kGameDuration] integerValue];
        
        if (_gameMode == gameModeNormal)
        {
            self.numberOfTries = [[aDecoder decodeObjectForKey:kNumberTries] integerValue];
            BOOL succeed = [[aDecoder decodeObjectForKey:kGameResult] boolValue];
            if (succeed)
            {
                self.succeed = 2;
            }
            else
            {
                self.succeed = 1;
            }
            self.availabelHints = 4 - [[aDecoder decodeObjectForKey:kHintUsed] integerValue];
        }
        else if (_gameMode == gameModeInfinity)
        {
            self.hintUsed = [[aDecoder decodeObjectForKey:kHintUsed] integerValue];
        }
    }
    return self;
}

- (instancetype)initWithGameMode:(gameMode)gameMode
{
    self = [super init];
    if (self)
    {
        _gameMode = gameMode;
        
        _succeed = 0;
        _userFirstDigit = -1;
        _userSecondDigit = -1;
        _userThirdDigit = -1;
        _userForthDigit = -1;
        _gameScore = 0;
        _gameAnswer = arc4random() % 10000;
        
        if (gameMode == gameModeNormal)
        {
            _availabelHints = 4;
            _numberOfTries = 0;
        }
        else if (gameMode == gameModeInfinity)
        {
            _hintUsed = 0;
            _availableTries = 5;
        }
        
        _allWrong = YES;
        _correctNumber = 0;
        
        _correctNess = [[NSMutableArray alloc] initWithObjects:@(0),@(0),@(0),@(0), nil];
        
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

- (void)generateNewAnswer
{
    _userFirstDigit = -1;
    _userSecondDigit = -1;
    _userThirdDigit = -1;
    _userForthDigit = -1;
    _gameAnswer = arc4random() % 10000;
    _firstHint = NO;
    _secondHint = NO;
    _thirdHint = NO;
    _forthHint = NO;
    for (NSInteger i = 0; i < 4; i++)
    {
        [_correctNess replaceObjectAtIndex:i withObject:@(0)];
    }
    _availableTries += 1;
    [self calculateDigits];
    NSLog(@"%ld, %ld, %ld, %ld",_answerFirstDigit, _answerSecondDigit, _answerThirdDigit, _answerForthDigit);
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
                 _firstHint = YES;
                if (_gameMode == gameModeNormal)
                {
                    _availabelHints -= 1;
                }
                else if (_gameMode == gameModeInfinity)
                {
                    _hintUsed += 1;
                }
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
                _secondHint = YES;
                if (_gameMode == gameModeNormal)
                {
                    _availabelHints -= 1;
                }
                else if (_gameMode == gameModeInfinity)
                {
                    _hintUsed += 1;
                }

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
                _thirdHint = YES;
                if (_gameMode == gameModeNormal)
                {
                    _availabelHints -= 1;
                }
                else if (_gameMode == gameModeInfinity)
                {
                    _hintUsed += 1;
                }

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
                _forthHint = YES;
                if (_gameMode == gameModeNormal)
                {
                    _availabelHints -= 1;
                }
                else if (_gameMode == gameModeInfinity)
                {
                    _hintUsed += 1;
                }
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
    if (_gameMode == gameModeNormal)
    {
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
    else if (_gameMode == gameModeInfinity)
    {
        return;
    }
    
}

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer
{
    NSString *feedBackString = @"";
    
    if (_gameMode == gameModeNormal)
    {
        _numberOfTries += 1;
    }
    else if (_gameMode == gameModeInfinity)
    {
        _availableTries -= 1;
//        if (_availableTries == 0)
//        {
//            _succeed = 3;
//            return feedBackString;
//        }
    }
    
    NSUInteger difference;
    
    switch (boxNum) {
        case 1:
        {
            _userFirstDigit = answer;
            if (_userFirstDigit == _answerFirstDigit)
            {
                feedBackString = NSLocalizedString(@"RIGHT", nil);
                [_correctNess replaceObjectAtIndex:0 withObject:@(1)];
                if (_gameMode ==  gameModeInfinity)
                {
                    _availableTries += 3;
                    _correctNumber += 1;
                }
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
                if (_gameMode == gameModeInfinity)
                {
                    if (_availableTries == 0)
                    {
                        _succeed = 3;
                        return feedBackString;
                    }
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
                if (_gameMode == gameModeInfinity)
                {
                    _availableTries += 3;
                    _correctNumber += 1;
                }
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
                if (_gameMode == gameModeInfinity)
                {
                    if (_availableTries == 0)
                    {
                        _succeed = 3;
                        return feedBackString;
                    }
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
                if (_gameMode == gameModeInfinity)
                {
                    _availableTries += 3;
                    _correctNumber += 1;
                }
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
                if (_gameMode == gameModeInfinity)
                {
                    if (_availableTries == 0)
                    {
                        _succeed = 3;
                        return feedBackString;
                    }
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
                if (_gameMode == gameModeInfinity)
                {
                    _availableTries += 3;
                    _correctNumber += 1;
                }
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
                if (_gameMode == gameModeInfinity)
                {
                    if (_availableTries == 0)
                    {
                        _succeed = 3;
                        return feedBackString;
                    }
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
- (void)endGameWithDuration:(NSInteger)duration
{
    _dateOfGame = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    _dateString = [formatter stringFromDate:[NSDate date]];
    
    NSInteger baseScore = arc4random() % 25 + 100;
    _gameScore += baseScore;
    
    if (_gameMode == gameModeNormal)
    {
        _duration = 30 - duration;
        
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
        NSInteger punishment;
        if (_numberOfTries > 20)
        {
            punishment = 30;
        }
        else
        {
            punishment = 20;
        }
        if (_availabelHints == 4)
        {
            _gameScore += duration * 10 + 100 - _numberOfTries * punishment;
        }
        else
        {
            _gameScore += duration * 10 - _numberOfTries * punishment - (arc4random() % 25) * (4 - _availabelHints);
        }
        
        if (_gameScore < 0)
        {
            _gameScore = 0;
        }
        
        //NSLog(@"correct number = %ld",_correctNumber);
        
        //record the game
        NSData *gameData = [[EGOCache globalCache] dataForKey:@"normalGames"];
        NSMutableArray *games = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
        [games addObject:self];
        gameData = [NSKeyedArchiver archivedDataWithRootObject:games];
        [[EGOCache globalCache] setData:gameData forKey:@"normalGames"];
    }
    else if (_gameMode == gameModeInfinity)
    {
        _duration = duration;
        
        //for each correct guess scrore increase by 30, for each hint used, deduct the score by 15, then plus 10 * (seconds / correctNumber);
        NSInteger bonus;
        if (_correctNumber > 0)
        {
            float quotient = (float)_correctNumber/(float)_duration;
            bonus = (NSInteger)(100.0f * quotient);
            //NSLog(@"bonus = %ld",bonus);
        }
        else
        {
            bonus = 0;
        }
        
        _gameScore += 30 * _correctNumber - (_hintUsed) * 15 + bonus;
        
        if (_gameScore < 0)
        {
            _gameScore = 0;
        }
        
        NSData *gameData = [[EGOCache globalCache] dataForKey:@"infinityGames"];
        NSMutableArray *games = [NSKeyedUnarchiver unarchiveObjectWithData:gameData];
        [games addObject:self];
        gameData = [NSKeyedArchiver archivedDataWithRootObject:games];
        [[EGOCache globalCache] setData:gameData forKey:@"infinityGames"];
    }
}


@end
