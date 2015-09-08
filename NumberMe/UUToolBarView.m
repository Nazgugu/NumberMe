//
//  UUToolBarView.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUToolBarView.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"
#import "HUMSlider.h"

@interface UUToolBarView()

@property (nonatomic, strong, getter = getButtonSend) UIButton *btnSend;
//@property (nonatomic, strong, getter = getButtonPreview) UIButton *btnPreview;
@property (nonatomic, strong) HUMSlider *blurSlider;

@property (nonatomic, strong, getter = getCancelButton) UIButton *cancelButton;
//@property (nonatomic, strong, getter = getButtonOriginalImage) UIButton *btnOriginal;

//@property (nonatomic, strong, getter = getImageOriginal) UIImageView *imgOriginal;
//@property (nonatomic, strong, getter = getLabelNumber) UILabel *lblNumOfSelect;


@end

@implementation UUToolBarView

- (instancetype)initWithWhiteColor{

    if (self = [super init]) {
        self.dynamic = YES;
        self.blurEnabled = YES;
        self.blurRadius = 12.0f;
        self.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        [self configureSlider];
    }
    
    return self;
}

- (instancetype)initWithBlackColor{

    if (self = [super init]) {
        //self.backgroundColor = [UIColor blackColor];
        self.dynamic = YES;
        self.blurEnabled = YES;
        self.blurRadius = 12.0f;
        self.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        [self configureSlider];
    }
    
    return self;
}

#pragma mark - life cycle

//- (void)configBlackColorUI{

//    [self addSubview:self.btnSend];
//    if (_isFromRoot)
//    {
//        [self addSubview:self.cancelButton];
//    }
//    [self addSubview:self.imgOriginal];
//    [self addSubview:self.btnOriginal];
//    [self addSubview:self.lblNumOfSelect];
    
//    self.backgroundColor = COLOR_WITH_RGB(87,87,87,.6f);
    
//    [self configNotification];
//    [self configureSlider];
//    
//    
//}

//- (void)configWhiteColorUI{

//    [self addSubview:self.btnSend];
//    if (_isFromRoot)
//    {
//        [self addSubview:self.cancelButton];
//    }
//    [self addSubview:self.btnPreview];
//    [self addSubview:self.lblNumOfSelect];
    
//    self.backgroundColor = COLOR_WITH_RGB(250,250,250,1);
//    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = COLOR_WITH_RGB(224,224,224,1).CGColor;
    
//    [self configNotification];
    
//    [self configureSlider];
//    
//}

- (void)configureSlider
{
    _blurSlider = [[HUMSlider alloc] init];
    if (IS_IPHONE_4_OR_LESS)
    {
        [_blurSlider setFrame:CGRectMake(10, 8, SCREENWIDTH - 70, 18)];
    }
    else if (IS_IPHONE_5)
    {
        [_blurSlider setFrame:CGRectMake(10, 14, SCREENWIDTH - 80, 22)];
    }
    else if (IS_IPHONE_6)
    {
        [_blurSlider setFrame:CGRectMake(10, 18, SCREENWIDTH - 85, 30)];
    }
    else if (IS_IPHONE_6P)
    {
        [_blurSlider setFrame:CGRectMake(10, 26, SCREENWIDTH - 90, 40)];
    }
    _blurSlider.minimumValueImage = [UIImage imageNamed:@"visible"];
    _blurSlider.maximumValueImage = [UIImage imageNamed:@"invisible"];
    _blurSlider.saturatedColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.455f alpha:1.00f];
    _blurSlider.desaturatedColor = [UIColor lightGrayColor];
    _blurSlider.tickColor = [UIColor colorWithRed:0.231f green:0.604f blue:0.847f alpha:1.00f];
    _blurSlider.minimumValue = 0;
    _blurSlider.maximumValue = 50;
//    _blurSlider.maximumTrackTintColor = [UIColor colorWithRed:0.231f green:0.604f blue:0.847f alpha:1.00f];
    //_blurSlider.minimumTrackTintColor = [UIColor colorWithRed:0.231f green:0.604f blue:0.847f alpha:1.00f];
    _blurSlider.tintColor = [UIColor colorWithRed:0.231f green:0.604f blue:0.847f alpha:1.00f];
//    _blurSlider.sectionCount = 9;
    [_blurSlider setValue:0 animated:YES];
    [_blurSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
//    _blurSlider.pointAdjustmentForCustomThumb = 5.0f;
    [_blurSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_blurSlider];
}

- (void)resetSlider
{
    [_blurSlider setValue:0 animated:YES];
}

//- (void)configNotification{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationUpdateSelected:)
//                                                 name:kNotificationUpdateSelected
//                                               object:nil];
//    
//    [self notificationUpdateSelected:nil];
//}

//- (void)dealloc{
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)valueChanged:(id)sender
{
//    NSLog(@"value is %lf",_blurSlider.value);
    if ([_delegate respondsToSelector:@selector(sliderValueDidChange:)])
    {
        [_delegate sliderValueDidChange:_blurSlider.value];
    }
}

#pragma mark - Delegate

#pragma mark - Custom Deledate

#pragma mark - Event Response

//- (void)addPreviewTarget:(id)target action:(SEL)action{
//
//    [_btnPreview addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//}

//- (void)onClickOriginal:(UIButton *)sender{
//
//    if (!sender.selected) {
//        
//        sender.selected = YES;
//        _imgOriginal.image = [UIImage imageNamed:@"ImageSelectedOn"];
//        
//    }else{
//        
//        sender.selected = NO;
//        _imgOriginal.image = [UIImage imageNamed:@"ImageSelectedOff"];
//    }
//}

- (void)onClickSend:(id)sender{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendPhotos object:nil];
    if ([_delegate respondsToSelector:@selector(hasChoseImageOfGameMode:)])
    {
        [_delegate hasChoseImageOfGameMode:_gameMode];
    }
}

- (void)dismissView
{
    if ([_delegate respondsToSelector:@selector(dismiss)])
    {
        [_delegate dismiss];
    }
}


#pragma mark - Public Methods

#pragma mark - Private Methods

//- (void)notificationUpdateSelected:(NSNotification *)note{
//
//    self.lblNumOfSelect.hidden = NO;
//    NSInteger count = [[UUAssetManager sharedInstance] getSelectedPhotoCount];
//    if (count == 0) {
//        
//        self.lblNumOfSelect.hidden = YES;
//        _btnPreview.enabled = _btnSend.enabled = NO;
//        return;
//    }
//
//    _btnPreview.enabled = _btnSend.enabled = YES;
//    self.lblNumOfSelect.text = [NSString stringWithFormat:@"%ld",(long)count];
//    self.lblNumOfSelect.transform = CGAffineTransformMakeScale(.5, .5);
//    [UIView animateWithDuration:.3
//                          delay:0
//         usingSpringWithDamping:.5
//          initialSpringVelocity:.5
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//        self.lblNumOfSelect.transform = CGAffineTransformIdentity;
//                         
//    } completion:nil];
//}

#pragma mark - Getters And Setters

//- (UIButton *)getButtonPreview{
//    
//    if (!_btnPreview) {
//        
//        _btnPreview = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnPreview.frame = CGRectMake(10, 0, 50, 50);
//        [_btnPreview setTitle:@"预览" forState:UIControlStateNormal];
//        [_btnPreview setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
//        _btnPreview.titleLabel.font = [UIFont systemFontOfSize:16];
//        _btnPreview.backgroundColor = [UIColor clearColor];
//        _btnPreview.enabled = NO;
//    }
//    
//    return _btnPreview;
//}

- (UIButton *)getButtonSend{
    
    if (!_btnSend) {
        
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_isFromRoot)
        {
            if (IS_IPHONE_4_OR_LESS)
            {
                _btnSend.frame = CGRectMake(ScreenWidth - 55, 6, 50, 16);
            }
            else if (IS_IPHONE_5)
            {
                _btnSend.frame = CGRectMake(ScreenWidth - 65, 8, 60, 18);
            }
            else if (IS_IPHONE_6)
            {
                _btnSend.frame = CGRectMake(ScreenWidth - 70, 10, 65, 22);
            }
            else if (IS_IPHONE_6P)
            {
                _btnSend.frame = CGRectMake(ScreenWidth - 75, 12, 70, 25);
            }
            _btnSend.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:12.0f];
        }
        else
        {
            if (IS_IPHONE_4_OR_LESS)
            {
                _btnSend.frame = CGRectMake(ScreenWidth -55, 15, 50, 20);
            }
            else if (IS_IPHONE_5)
            {
                _btnSend.frame = CGRectMake(ScreenWidth -65, 18, 60, 24);
            }
            else if (IS_IPHONE_6)
            {
                _btnSend.frame = CGRectMake(ScreenWidth -70, 23, 60, 28);
            }
            else if (IS_IPHONE_6P)
            {
                _btnSend.frame = CGRectMake(ScreenWidth -75, 28, 70, 30);
            }
            _btnSend.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
        }
        [_btnSend setTitle:NSLocalizedString(@"CONF", nil) forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f] forState:UIControlStateNormal];
        _btnSend.layer.borderWidth = 1.0f;
        _btnSend.layer.borderColor = [UIColor colorWithRed:0.176f green:0.718f blue:0.984f alpha:1.00f].CGColor;
        _btnSend.layer.cornerRadius = 5.0f;
        _btnSend.layer.masksToBounds = YES;
        
        _btnSend.backgroundColor = [UIColor clearColor];
//        _btnSend.enabled = YES;
        
        [_btnSend addTarget:self action:@selector(onClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnSend;
}

- (UIButton *)getCancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE_4_OR_LESS)
        {
            _cancelButton.frame = CGRectMake(ScreenWidth -55, 28, 50, 16);
        }
        else if (IS_IPHONE_5)
        {
            _cancelButton.frame = CGRectMake(ScreenWidth - 65, 34, 60, 18);
        }
        else if (IS_IPHONE_6)
        {
            _cancelButton.frame = CGRectMake(ScreenWidth - 70, 42, 65, 22);
        }
        else if (IS_IPHONE_6P)
        {
            _cancelButton.frame = CGRectMake(ScreenWidth - 75, 49, 70, 25);
        }
        [_cancelButton setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.969f green:0.353f blue:0.380f alpha:1.00f] forState:UIControlStateNormal];
        _cancelButton.layer.borderWidth = 1.0f;
        _cancelButton.layer.borderColor = [UIColor colorWithRed:0.969f green:0.353f blue:0.380f alpha:1.00f].CGColor;
        _cancelButton.layer.cornerRadius = 5.0f;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:12.0f];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)setIsFromRoot:(BOOL)isFromRoot
{
    _isFromRoot = isFromRoot;
    [self addSubview:self.btnSend];
    if (_isFromRoot)
    {
        [self addSubview:self.cancelButton];
    }
}

//- (UILabel *)getLabelNumber{
//
//    if (!_lblNumOfSelect) {
//        
//        _lblNumOfSelect = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -75, 16, 18, 18)];
//        _lblNumOfSelect.backgroundColor = COLOR_WITH_RGB(94,201,252,.9f);
//        _lblNumOfSelect.layer.borderColor = [UIColor whiteColor].CGColor;
//        _lblNumOfSelect.textAlignment = NSTextAlignmentCenter;
//        _lblNumOfSelect.font = [UIFont systemFontOfSize:10];
//        _lblNumOfSelect.textColor = [UIColor whiteColor];
//
//        _lblNumOfSelect.layer.cornerRadius = 8;
//        _lblNumOfSelect.layer.borderWidth = 1;
//        _lblNumOfSelect.clipsToBounds = YES;
//        _lblNumOfSelect.hidden = YES;
//    }
//    
//    return _lblNumOfSelect;
//}

//- (UIButton *)getButtonOriginalImage{
//
//    if (!_btnOriginal) {
//        
//        _btnOriginal = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnOriginal.frame = CGRectMake(25, 10, 50, 30);
//        [_btnOriginal setTitle:@"原图" forState:UIControlStateNormal];
//        [_btnOriginal setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
//        _btnOriginal.backgroundColor = [UIColor clearColor];
//        _btnOriginal.titleLabel.font = [UIFont systemFontOfSize:16];
//        
//        [_btnOriginal addTarget:self action:@selector(onClickOriginal:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    return _btnOriginal;
//}

//- (UIImageView *)getImageOriginal{
//
//    if (!_imgOriginal) {
//        
//        _imgOriginal = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 18, 18)];
//        _imgOriginal.image = [UIImage imageNamed:@"ImageSelectedOff"];
//    }
//    
//    return _imgOriginal;
//}
@end
