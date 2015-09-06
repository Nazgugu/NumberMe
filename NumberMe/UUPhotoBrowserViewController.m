//
//  UUPhotoBrowserViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoBrowserViewController.h"
#import "UUPhoto-Import.h"
#import "UUPhoto-Macros.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOCache.h"

#define PADDING 10

@interface UUPhotoBrowserViewController() < UIScrollViewDelegate, UUToolBarViewDelegate >{
    
    NSMutableSet *_visiblePages, *_recycledPages;
}

@property (nonatomic, strong, getter = getRootScrollView) UIScrollView *rootScroller;
@property (nonatomic, strong, getter = getToolBarView) UUToolBarView *toolBarView;
//@property (nonatomic, strong, getter = getButtonSelected) UIButton *btnSelected;

@property (nonatomic, strong) UUZoomingScrollView *currentPage;

//sizes
@property (nonatomic) CGFloat buttonSize;
@property (nonatomic) CGFloat gapSize;

@property (nonatomic) CGFloat verticalGap;

@property (nonatomic) CGFloat boxWidth;
@property (nonatomic) CGFloat boxHeight;

@property (nonatomic) CGFloat toolButtonHeight;
@property (nonatomic) CGFloat toolButtonWidth;

//showing purpose
@property (nonatomic, strong) UILabel *guideLabel;

@end

@implementation UUPhotoBrowserViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    
    [self configUI];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{

    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    _visiblePages = nil;
    _recycledPages = nil;
}

#pragma mark - life cycle

- (void)configUI{
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.view addSubview:self.rootScroller];
    
    //initiate layer
    [self calculateSize];
    
    [self configureGameView];
    
    
    
//    [self configBarButtonItem];
    [self updateVisiblePageView];
    if ([self jumpPage] > 0) [self jumpToPageAtIndex:[self jumpPage] animated:NO];
        
}

- (void)calculateSize
{
    _verticalGap = 20.0f;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _gapSize = 28.0f;
        _verticalGap = 10.0f;
        _boxHeight = 60.0f;
        _toolButtonHeight = 25.0f;
        _guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(26,0, SCREENWIDTH - 2 * 26, 41)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:14.0f];
        
    }
    else if (IS_IPHONE_5)
    {
        _gapSize = 25.0f;
        _verticalGap = 15.0f;
        _boxHeight = 65.0f;
        _toolButtonHeight = 28.0f;
        _guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, SCREENWIDTH - 2 * 26, 66)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    }
    else if (IS_IPHONE_6)
    {
        _gapSize = 30.0f;
        _boxHeight = 80.0f;
        _toolButtonHeight = 33.0f;
        _guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, SCREENWIDTH - 2 * 26, 66)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:17.0f];
    }
    else
    {
        _gapSize = 35.0f;
        _boxHeight = 95.0f;
        _toolButtonHeight = 38.0f;
        _guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, SCREENWIDTH - 2 * 26, 76)];
        _guideLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:19.0f];
    }
    
    _boxWidth = (SCREENWIDTH - 5 * _gapSize) / 4;

    _guideLabel.numberOfLines = 0;
    _guideLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _guideLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    _guideLabel.textAlignment = NSTextAlignmentCenter;
    
    _toolButtonWidth = (SCREENWIDTH - 5 * (_gapSize - 18)) / 4;
    
    _buttonSize = (SCREENWIDTH - 4 * _gapSize) / 3;
    [self.view addSubview:_guideLabel];
}

- (void)configureGameView
{
    [self initButtons];
    [self initBoxes];
    [self createLine];
    [self createToolButton];
    [self initLevelLabel];
    NSInteger gameLevel = 1;
    if (_gameMode == gameModeNormal)
    {
        _guideLabel.text = NSLocalizedString(@"GUIDE_ONE", nil);
    }
    else if (_gameMode == gameModeInfinity)
    {
        _guideLabel.text = NSLocalizedString(@"INFINITI", nil);
    }
    else if (_gameMode == gameModeLevelUp)
    {
        _guideLabel.text = [NSString stringWithFormat:NSLocalizedString(@"GAMELEVEL", nil),gameLevel];
    }
}

- (void)initButtons
{
    CGFloat xPosition, yPosition;
    NSInteger k;
    for (NSInteger i = 1; i < 10; i++)
    {
        k = i % 3;
        if (k == 0)
        {
            k = 3;
        }
        xPosition = k * _gapSize + (k - 1) * _buttonSize;
        if (i < 4)
        {
            yPosition = SCREENHEIGHT - _verticalGap * 4 - _buttonSize * 4;
        }
        else if (i > 3 && i < 7)
        {
            yPosition = SCREENHEIGHT - _verticalGap * 3 - _buttonSize * 3;
        }
        else
        {
            yPosition = SCREENHEIGHT - _verticalGap * 2 - _buttonSize * 2;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, yPosition, _buttonSize, _buttonSize)];
        button.layer.cornerRadius = _buttonSize / 2;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
        button.layer.masksToBounds = YES;
        [button setTitle:[NSString stringWithFormat:@"%ld",i] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:32.0f];
        button.userInteractionEnabled = NO;
        [self.view addSubview:button];
    }
}

- (void)initBoxes
{
    CGFloat xPosition, yPosition;
    for (NSInteger i = 1; i <=4; i++)
    {
        xPosition = i * _gapSize + (i - 1) * _boxWidth;
        yPosition = SCREENHEIGHT - _verticalGap * 6 - 4 * _buttonSize - _boxHeight;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, yPosition, _boxWidth, _boxHeight)];
        label.layer.borderWidth = 1.5f;
        label.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor;
        label.layer.cornerRadius = 8.0f;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:35.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld",i];
        [self.view addSubview:label];
    }
}

- (void)createLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_gapSize - 18, SCREEN_HEIGHT - _verticalGap * 5 - 4 * _buttonSize, SCREENWIDTH - 2 * (_gapSize - 18), 1)];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    [self.view addSubview:line];
}

- (void)createToolButton
{
    UIButton *_deleteOneButton, *_clearButton, *_restartButton, *_hintButton;
    _deleteOneButton = [[UIButton alloc] initWithFrame:CGRectMake(_gapSize - 18, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    _deleteOneButton.layer.borderWidth = 1.0f;
    _deleteOneButton.layer.borderColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f].CGColor;
    _deleteOneButton.layer.cornerRadius = _toolButtonHeight/2;
    _deleteOneButton.layer.masksToBounds = YES;
    [_deleteOneButton setTitleColor:[UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f] forState:UIControlStateNormal];
    [_deleteOneButton setTitleColor:[UIColor colorWithRed:0.941f green:0.608f blue:0.173f alpha:1.00f] forState:UIControlStateHighlighted];
    [_deleteOneButton setTitle:NSLocalizedString(@"DELETE", nil) forState:UIControlStateNormal];
    _deleteOneButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _deleteOneButton.titleLabel.minimumScaleFactor = 0.5f;
    _deleteOneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _deleteOneButton.tintColor = [UIColor colorWithRed:0.941f green:0.761f blue:0.188f alpha:1.00f];
//    _deleteOneButton.alpha = 0;
//    _deleteOneButton.tag = -1;
    _deleteOneButton.userInteractionEnabled = NO;
    [self.view addSubview:_deleteOneButton];
    
    //
    _clearButton = [[UIButton alloc] initWithFrame:CGRectMake((_gapSize - 18) * 2 + _toolButtonWidth, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    _clearButton.layer.borderWidth = 1.0f;
    _clearButton.layer.borderColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f].CGColor;
    _clearButton.layer.cornerRadius = _toolButtonHeight/2;
    _clearButton.layer.masksToBounds = YES;
    [_clearButton setTitleColor:[UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f] forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor colorWithRed:0.812f green:0.333f blue:0.098f alpha:1.00f] forState:UIControlStateHighlighted];
    [_clearButton setTitle:NSLocalizedString(@"CLEAR", nil) forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _clearButton.titleLabel.minimumScaleFactor = 0.5f;
    _clearButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _clearButton.tintColor = [UIColor colorWithRed:0.890f green:0.494f blue:0.188f alpha:1.00f];
//    _clearButton.alpha = 0;
//    _clearButton.tag = -2;
    _clearButton.userInteractionEnabled = NO;
    [self.view addSubview:_clearButton];
    
    //
    _restartButton = [[UIButton alloc] initWithFrame:CGRectMake((_gapSize - 18) * 3 + _toolButtonWidth * 2, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    _restartButton.layer.borderWidth = 1.0f;
    _restartButton.layer.borderColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f].CGColor;
    _restartButton.layer.cornerRadius = _toolButtonHeight/2;
    _restartButton.layer.masksToBounds = YES;
    [_restartButton setTitleColor:[UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f] forState:UIControlStateNormal];
    [_restartButton setTitleColor:[UIColor colorWithRed:0.737f green:0.231f blue:0.188f alpha:1.00f] forState:UIControlStateHighlighted];
    [_restartButton setTitle:NSLocalizedString(@"RESTART", nil) forState:UIControlStateNormal];
    _restartButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _restartButton.titleLabel.minimumScaleFactor = 0.5f;
    _restartButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _restartButton.tintColor = [UIColor colorWithRed:0.890f green:0.306f blue:0.259f alpha:1.00f];
    _restartButton.userInteractionEnabled = NO;
    [self.view addSubview:_restartButton];
    
    //
    _hintButton = [[UIButton alloc] initWithFrame:CGRectMake((_gapSize - 18) * 4 + _toolButtonWidth * 3, SCREEN_HEIGHT - _verticalGap * 7 - 4 * _buttonSize - _boxHeight - _toolButtonHeight, _toolButtonWidth, _toolButtonHeight)];
    _hintButton.layer.borderWidth = 1.0f;
    _hintButton.layer.borderColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f].CGColor;
    _hintButton.layer.cornerRadius = _toolButtonHeight/2;
    _hintButton.layer.masksToBounds = YES;
    [_hintButton setTitleColor:[UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f] forState:UIControlStateNormal];
    [_hintButton setTitleColor:[UIColor colorWithRed:0.224f green:0.675f blue:0.388f alpha:1.00f] forState:UIControlStateHighlighted];
    [_hintButton setTitle:NSLocalizedString(@"HINT", nil) forState:UIControlStateNormal];
    _hintButton.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:15.0f];
    _hintButton.titleLabel.minimumScaleFactor = 0.5f;
    _hintButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _hintButton.tintColor = [UIColor colorWithRed:0.263f green:0.792f blue:0.459f alpha:1.00f];
    _hintButton.userInteractionEnabled = NO;
    [self.view addSubview:_hintButton];
}

- (void)initLevelLabel
{
    UILabel *_levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENHEIGHT - 10 - 42, 10, 42, 16)];
    _levelLabel.layer.borderWidth = 1.0f;
    _levelLabel.layer.cornerRadius = 5.0f;
    _levelLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelLabel.layer.masksToBounds = YES;
    _levelLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:12.0f];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.text = @"LV 1";
    if (_gameMode == gameModeLevelUp)
    {
        _levelLabel.hidden = NO;
    }
    else
    {
        _levelLabel.hidden = YES;
    }
}

//- (void)configBarButtonItem{
//
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.btnSelected];
//    self.navigationItem.rightBarButtonItem = barButton;
//}

- (void)configurePage:(UUZoomingScrollView *)page forIndex:(NSUInteger)index {
    
    page.tag = index;
    page.frame = [self frameForPageAtIndex:index];
    [page displayImage:[self displayImageWithIndex:index]];
    _currentPage = page;
//    NSLog(@"configure");
    if (_toolBarView)
    {
        [_toolBarView resetSlider];
    }
//    [self isSelectedPhotoWithIndex:index];
}

#pragma mark UUToolBarViewDelegate

- (void)sliderValueDidChange:(CGFloat)value
{
//    NSLog(@"value changed");
    [_currentPage blurImageOfRadius:value];
}

- (void)hideAllSource
{
    for (UIView *view in self.view.subviews)
    {
        if (![view isKindOfClass:[UIScrollView class]])
        {
            [view removeFromSuperview];
        }
    }
    
}

- (void)hasChoseImage
{
//    NSLog(@"has choose image");
    [self hideAllSource];
    [self savePhoto];
    if (_isFromRoot)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)savePhoto
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
        
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[EGOCache globalCache] setImage:image forKey:@"test"];
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self updateVisiblePageView];
}

#pragma mark - Custom Deledate

//- (BOOL)isMaxSelectedNumber{
//
//    if (_delegate && [_delegate respondsToSelector:@selector(isCheckMaxSelectedFromPhotoBrowser:)]) {
//    
//        return [_delegate isCheckMaxSelectedFromPhotoBrowser:self];
//    }
//    
//    return YES;
//}

//- (void)isSelectedPhotoWithIndex:(NSInteger )index{
//
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(isSelectedPhotosWithIndex:fromPhotoBrowser:)]) {

//        _btnSelected.tag = index;
//        if ([_delegate isSelectedPhotosWithIndex:index fromPhotoBrowser:self]){
//        
//            _btnSelected.selected = YES;
//            [_btnSelected setImage:[UIImage imageNamed:@"ImageSelectedOn"] forState:UIControlStateNormal];
//            
//        }else{
//        
//            _btnSelected.selected = NO;
//            [_btnSelected setImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
//        }
//    }
//}

- (NSInteger )jumpPage{

    if (_delegate && [_delegate respondsToSelector:@selector(jumpIndexFromPhotoBrowser:)]) {
        
        return [_delegate jumpIndexFromPhotoBrowser:self];
    }
    
    return 0;
}

- (NSInteger )numberOfPhotos{
    
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfPhotosFromPhotoBrowser:)]) {
        
        return [_delegate numberOfPhotosFromPhotoBrowser:self];
    }
    
    return 0;
}

- (UIImage *)displayImageWithIndex:(NSInteger )index{

    if (_delegate && [_delegate respondsToSelector:@selector(displayImageWithIndex:fromPhotoBrowser:)]) {
        
        return [_delegate displayImageWithIndex:index fromPhotoBrowser:self];
    }
    
    return nil;
}


#pragma mark - Event Response

//- (void)onClickSelected:(UIButton *)sender{

//    if (!sender.selected && [self isMaxSelectedNumber]) return;
//    
//    sender.selected = !sender.selected;
    
//    if (sender.selected) {
//        
//        [_btnSelected setImage:[UIImage imageNamed:@"ImageSelectedOn"] forState:UIControlStateNormal];
//    }else{
//    
//        [_btnSelected setImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
//    }
    
    
//    if (_delegate && [_delegate respondsToSelector:@selector(displayImageWithIndex:selectedChanged:)]) {
//        
//        return [_delegate displayImageWithIndex:sender.tag selectedChanged:sender.selected];
//    }
//}

- (void)onClickImageBrowser:(UIGestureRecognizer *)gesture{
    
    [self setHideNavigationBar];
}

#pragma mark - Private Methods

- (void)updateVisiblePageView{

    CGRect visibleBounds = _rootScroller.bounds;
    NSInteger iFirstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
    NSInteger iLastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > [self numberOfPhotos] - 1) iFirstIndex = [self numberOfPhotos] - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > [self numberOfPhotos] - 1) iLastIndex = [self numberOfPhotos] - 1;
    
    NSInteger pageIndex;
    for (UUZoomingScrollView *page in _visiblePages) {
        pageIndex = page.tag;
        if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
            [_recycledPages addObject:page];
            
            [page prepareForReuse];
            [page removeFromSuperview];
        }
    }
    
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
    // Add missing pages
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            
            // Add new page
            UUZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[UUZoomingScrollView alloc] init];
                [page addImageTarget:self action:@selector(onClickImageBrowser:)];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];
            
            [_rootScroller addSubview:page];
        }
    }
//    NSLog(@"adding");
}

- (void)setHideNavigationBar{
    
    CGRect frame = _toolBarView.frame;
    if (_isFromRoot)
    {
        if (frame.origin.y == ScreenHeight)
        {
            frame.origin.y = ScreenHeight - 50;
        }
        else
        {
            frame.origin.y = ScreenHeight;
        }
    }
    else
    {
        if (self.navigationController.navigationBarHidden) {
            
            frame.origin.y = ScreenHeight -50;
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            
        } else {
            
            frame.origin.y = ScreenHeight;
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    
    [UIView animateWithDuration:.25f animations:^{
        
        _toolBarView.frame = frame;
    }];
}

- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
    
    // Change page
    //NSLog(@"jumping");
    NSInteger numberOfPhotos = [UUAssetManager sharedInstance].assetPhotos.count;
    if (index < numberOfPhotos) {
        
        CGRect pageFrame = [self frameForPageAtIndex:index];
        [_rootScroller setContentOffset:CGPointMake(pageFrame.origin.x - PADDING, 0) animated:animated];
//        NSLog(@"set new image");
    }
}

- (UUZoomingScrollView *)dequeueRecycledPage {
    
    UUZoomingScrollView *page = [_recycledPages anyObject];
    if (page) [_recycledPages removeObject:page];
    
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    
    for (UUZoomingScrollView *page in _visiblePages){
        
        if (page.tag == index) return YES;
    }
    
    return NO;
}



- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    
    CGRect bounds = _rootScroller.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}

- (CGRect)frameForPagingScrollView {
    
    CGRect frame = self.view.bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}


- (CGSize)contentSizeForPagingScrollView {
    
    CGRect bounds = _rootScroller.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], 0);
}

#pragma mark - Getters And Setters

- (UIScrollView *)getRootScrollView{
    
    if (!_rootScroller) {
        
        _rootScroller = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
        _rootScroller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rootScroller.pagingEnabled = YES;
        _rootScroller.delegate = self;
        _rootScroller.showsHorizontalScrollIndicator = NO;
        _rootScroller.showsVerticalScrollIndicator = NO;
        _rootScroller.backgroundColor = [UIColor blackColor];
        _rootScroller.contentSize = [self contentSizeForPagingScrollView];
    }
    
    return _rootScroller;
}

- (UUToolBarView *)getToolBarView{
    
    if (!_toolBarView) {
        
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) -50, ScreenWidth, 50);
        _toolBarView = [[UUToolBarView alloc] initWithBlackColor];
        _toolBarView.isFromRoot = _isFromRoot;
        _toolBarView.frame = frame;
        _toolBarView.delegate = self;
    }
    
    return _toolBarView;
}

- (void)setIsFromRoot:(BOOL)isFromRoot
{
    _isFromRoot = isFromRoot;
    [self.view addSubview:self.toolBarView];
    
}

//- (UIButton *)getButtonSelected{
//
//    if (!_btnSelected) {
//        
//        _btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnSelected.frame = CGRectMake(0, 0, 25, 25);
//        [_btnSelected setImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
//        [_btnSelected addTarget:self action:@selector(onClickSelected:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    
//    return _btnSelected;
//}

@end
