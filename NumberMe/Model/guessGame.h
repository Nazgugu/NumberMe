//
//  guessGame.h
//  
//
//  Created by Liu Zhe on 15/8/8.
//
//

#import <Foundation/Foundation.h>

@interface guessGame : NSObject<NSCoding>

@property (nonatomic) NSInteger gameMode;

//for unlimited mode only
@property (nonatomic) NSInteger availableTries;

@property (nonatomic) NSInteger gameAnswer;
@property (nonatomic) NSInteger userAnswer;

@property (nonatomic) NSInteger gameScore;
@property (nonatomic) NSInteger hintUsed;

//in seconds
@property (nonatomic) NSInteger duration;

//0 = not able to check yet, 1 = failed, 2 = succeed
@property (nonatomic) NSInteger succeed;

@property (nonatomic) BOOL allWrong;

@property (nonatomic, strong) NSDate *dateOfGame;
@property (nonatomic, strong) NSString *dateString;

@property (nonatomic) NSInteger userFirstDigit;
@property (nonatomic) NSInteger userSecondDigit;
@property (nonatomic) NSInteger userThirdDigit;
@property (nonatomic) NSInteger userForthDigit;

@property (nonatomic) NSInteger answerFirstDigit;
@property (nonatomic) NSInteger answerSecondDigit;
@property (nonatomic) NSInteger answerThirdDigit;
@property (nonatomic) NSInteger answerForthDigit;

@property (nonatomic) NSInteger availabelHints;

@property (nonatomic, strong) NSString *hintMessage;

@property (nonatomic) NSInteger correctNumber;

@property (nonatomic) NSInteger numberOfTries;

@property (nonatomic) BOOL firstHint;
@property (nonatomic) BOOL secondHint;
@property (nonatomic) BOOL thirdHint;
@property (nonatomic) BOOL forthHint;

//0 = incorrect, 1 = correct
@property (nonatomic, strong) NSMutableArray *correctNess;

- (instancetype)initWithGameMode:(NSInteger)gameMode;

- (void)generateNewAnswer;

- (void)generateHintOfDigit:(NSInteger)digit;

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer;

- (void)verifyAnswer;

- (void)endGameWithDuration:(NSInteger)secondsLeft;

@end
