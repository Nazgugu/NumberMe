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
        _succeed = NO;
        _userFirstDigit = -1;
        _userSecondDigit = -1;
        _userThirdDigit = -1;
        _userForthDigit = -1;
        _gameScore = 0;
        _gameAnswer = arc4random() % 10000;
        _availabelHints = 4;
    }
    return self;
}

- (void)generateHint
{
    
}

@end
