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

@property (nonatomic) BOOL succeed;

@property (nonatomic, strong) NSDate *dateOfGame;

@property (nonatomic) NSInteger userFirstDigit;
@property (nonatomic) NSInteger userSecondDigit;
@property (nonatomic) NSInteger userThirdDigit;
@property (nonatomic) NSInteger userForthDigit;

@property (nonatomic) NSInteger availabelHints;

@property (nonatomic, strong) NSString *hintMessage;

- (void)generateHint;

@end
