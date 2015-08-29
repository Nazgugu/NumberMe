//
//  DOPScrollableActionSheet.m
//  DOPScrollableActionSheet
//
//  Created by weizhou on 12/27/14.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import "DOPScrollableActionSheet.h"
#import "UIImage+ImageEffects.h"

static CGFloat horizontalMargin = 20.0;

@interface DOPScrollableActionSheet ()

@property (nonatomic, assign) CGRect         screenRect;
@property (nonatomic, strong) UIWindow       *window;
@property (nonatomic, strong) UIImageView    *dimBackground;
@property (nonatomic, copy  ) NSArray        *actions;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *handlers;
@property (nonatomic, copy) void(^dismissHandler)(void);

@end

@implementation DOPScrollableActionSheet

- (instancetype)initWithActionArray:(NSArray *)actions {
    self = [super init];
    if (self) {
        _screenRect = [UIScreen mainScreen].bounds;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.5 &&
            UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            _screenRect = CGRectMake(0, 0, _screenRect.size.height, _screenRect.size.width);
        }
        //NSLog(@"actions count = %ld",actions.count);
        _actions = actions;
        _buttons = [NSMutableArray array];
        _handlers = [NSMutableArray array];
        _dimBackground = [[UIImageView alloc] initWithFrame:_screenRect];
        _dimBackground.userInteractionEnabled = YES;
        //_dimBackground.backgroundColor = [UIColor clearColor];
        UIImage *bluredImage = [[self convertViewToImage] applyBlurWithRadius:12 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4f] saturationDeltaFactor:1.0f maskImage:nil];
        [_dimBackground setImage:bluredImage];
        _dimBackground.alpha = 0;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_dimBackground addGestureRecognizer:gr];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3f];
    
        NSInteger rowCount = _actions.count;
    
        /*calculate action sheet frame begin*/
        //row title screenwidth*40 without row title margin screenwidth*20
        //60*60 icon 60*30 icon name
        CGFloat height = 0.0;
        for (int i = 0; i < rowCount; i++) {
            if ([_actions[i] isKindOfClass:[NSString class]]) {
                if ([_actions[i] isEqualToString:@""]) {
                    height += 10;
                } else {
                    height += 30;
                }
            } else {
                height = height+60+30;
            }
        }
        height -= 5;
        //cancel button screenwidth*60
        //height += 20;
        /*calculation end*/
        self.frame = CGRectMake(0, _screenRect.size.height, _screenRect.size.width, height);
        
        //add each row
        CGFloat y = 0.0;
        for (int i = 0; i < rowCount; i++) {
            if ([_actions[i] isKindOfClass:[NSString class]]) {
                //title
                //NSLog(@"this case");
                if ([_actions[i] isEqualToString:@""]) {
                    //NSLog(@"NO TITLE");
//                    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, y, _screenRect.size.width, 20.0)];
//                    [self addSubview:marginView];
//                    y+=20;
                } else {
                    UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, _screenRect.size.width, 40.0)];
                    rowTitle.font = [UIFont systemFontOfSize:14.0];
                    rowTitle.text = _actions[i];
                    rowTitle.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:rowTitle];
                    y+=40;
                }
            } else {
                NSArray *items = _actions[i];
                //actions array
                UIScrollView *rowContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, _screenRect.size.width, 65)];
                //rowContainer.backgroundColor = [UIColor blueColor];
                rowContainer.backgroundColor = [UIColor clearColor];
                rowContainer.directionalLockEnabled = YES;
                rowContainer.showsHorizontalScrollIndicator = NO;
                rowContainer.showsVerticalScrollIndicator = NO;
                rowContainer.contentSize = CGSizeMake(items.count*80+20, 65);
                [self addSubview:rowContainer];
                //add each item
                CGFloat x = horizontalMargin;
                for (int j = 0; j < items.count; j++) {
                    DOPAction *action = items[j];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(x, 10, 30, 30);
                    //button.layer.borderWidth = 1.0f;
                    //button.layer.borderColor = [UIColor blackColor].CGColor;
                    button.layer.cornerRadius = button.frame.size.height / 2;
                    button.layer.masksToBounds = YES;
                    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [button setImage:[UIImage imageNamed:action.iconName] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
                    [rowContainer addSubview:button];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 10, 45, 50, 20)];
                    label.text = action.actionName;
//                    label.layer.borderWidth = 1.0f;
//                    label.layer.borderColor = [UIColor blackColor].CGColor;
//                    label.layer.masksToBounds = YES;
                    label.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:10.0f];
                    label.textColor = [UIColor lightTextColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    [rowContainer addSubview:label];
                    x = x + 40 + horizontalMargin;
                    
                    [_buttons addObject:button];
                    [_handlers addObject:action.handler];
                }
                y+=65;
//                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, y, _screenRect.size.width,0.5)];
//                separator.backgroundColor = [UIColor lightGrayColor];
//                [self addSubview:separator];
            }
        }
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        cancel.frame = CGRectMake(0, y, _screenRect.size.width, 30);
        [cancel setTitle:NSLocalizedString(@"Cancel", @"cancel button name") forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Light" size:16.0f];

        cancel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
        [self addSubview:cancel];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)handlePress:(UIButton *)button {
    NSInteger index = [self.buttons indexOfObject:button];
    //NSLog(@"index = %ld",index);
    if (index != self.buttons.count) {
        NSLog(@"index = %ld",index);
        void(^handler)(void) = self.handlers[index];
        handler();
    }
    [self dismiss];
}

- (void)show {
    self.window = [[UIWindow alloc] initWithFrame:self.screenRect];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = [UIViewController new];
    self.window.rootViewController.view.backgroundColor = [UIColor clearColor];
    
    [self.window.rootViewController.view addSubview:self.dimBackground];
    
    [self.window.rootViewController.view addSubview:self];
    
    self.window.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.dimBackground.alpha = 1.0f;
        self.frame = CGRectMake(0, self.screenRect.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.dimBackground.alpha = 0.0f;
        self.frame = CGRectMake(0, self.screenRect.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}

-(UIImage *)convertViewToImage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}

@end

@implementation DOPAction

- (instancetype)initWithName:(NSString *)name iconName:(NSString *)iconName handler:(void(^)(void))handler {
    self = [super init];
    if (self) {
        _actionName = name;
        _iconName = iconName;
        _handler = handler;
    }
    return self;
}

@end
