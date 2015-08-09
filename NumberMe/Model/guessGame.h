//
//  guessGame.h
//  
//
//  Created by Liu Zhe on 15/8/8.
//
//

#import <Foundation/Foundation.h>

@interface guessGame : NSObject

@property (nonatomic) NSInteger gameAnswer;
@property (nonatomic) NSInteger userAnswer;

@property (nonatomic) NSInteger gameScore;
@property (nonatomic) NSInteger hintUsed;

//in seconds
@property (nonatomic) NSInteger duration;

//0 = not able to check yet, 1 = failed, 2 = succeed
@property (nonatomic) NSInteger succeed;

@property (nonatomic, strong) NSDate *dateOfGame;

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

//0 = incorrect, 1 = correct
@property (nonatomic, strong) NSMutableArray *correctNess;

- (void)generateHint;

- (NSString *)userAnswersAtBox:(NSInteger)boxNum andAnswer:(NSInteger)answer;

@end
