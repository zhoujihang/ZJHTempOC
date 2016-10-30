//
//  BBHomeBabyGrowthDayView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthDayView.h"
#import "BBHomeBabyGrowthDayCenterView.h"
#import "BBAutoCalculationSize.h"

static NSTimeInterval const kAnimationTime = 0.25;

@interface BBHomeBabyGrowthDayView ()

// 左右渐变层
@property (nonatomic, weak) CAGradientLayer *s_LeftGradientLayer;
@property (nonatomic, weak) CAGradientLayer *s_RightGradientLayer;
// 动画遮挡
@property (nonatomic, weak) UIView *s_LeftMaskView;
@property (nonatomic, weak) UIView *s_RightMaskView;
// 左右点击事件
@property (nonatomic, weak) UIView *s_LeftDayClickView;
@property (nonatomic, weak) UIView *s_RightDayClickView;

// 日期文字
@property (nonatomic, weak) UILabel *s_LeftLeftLabel;
@property (nonatomic, weak) UILabel *s_LeftLabel;
@property (nonatomic, weak) UILabel *s_CenterLabel;
@property (nonatomic, weak) UILabel *s_RightLabel;
@property (nonatomic, weak) UILabel *s_RightRightLabel;
@property (nonatomic, strong) UIFont *s_LeftLabelFont;
@property (nonatomic, weak) BBHomeBabyGrowthDayCenterView *s_CenterView;

// 今日视图
@property (nonatomic, weak) UIView *s_TodayView;
@property (nonatomic, weak) UILabel *s_TodayLabel;

// 日期文字固定位置
@property (nonatomic, assign) CGRect s_LeftLabelFrame;
@property (nonatomic, assign) CGRect s_CenterLabelFrame;
@property (nonatomic, assign) CGRect s_RightLabelFrame;
@property (nonatomic, assign) CGRect s_LeftLeftLabelFrame;
@property (nonatomic, assign) CGRect s_RightRightLabelFrame;
@property (nonatomic, assign) CGRect s_TodayViewShowFrame;
@property (nonatomic, assign) CGRect s_TodayViewHiddenFrame;

// 变量记录
@property (nonatomic, assign) NSInteger s_CurrentIndex;
@property (nonatomic, strong) NSDateComponents *s_CurrentDateComponents;
@property (nonatomic, assign) BOOL s_IsAnimating;
@property (nonatomic, assign) BOOL s_IsTodayViewAnimating;
@end

@implementation BBHomeBabyGrowthDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupPosition];
}
- (void)setupViews{
    self.s_IsAnimating = NO;
    self.s_IsTodayViewAnimating = NO;
    self.s_CurrentIndex = 0;
    self.s_LeftLabelFont = [UIFont systemFontOfSize:14];
    
    UITapGestureRecognizer *leftDayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftDayViewDidClick:)];
    UITapGestureRecognizer *rightDayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightDayViewDidClick:)];
    UITapGestureRecognizer *todayViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayViewDidClick:)];
    
    UIView *leftDayClickView = [[UIView alloc] init];
    [leftDayClickView addGestureRecognizer:leftDayTap];
    leftDayClickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftDayClickView];
    self.s_LeftDayClickView = leftDayClickView;
    
    UIView *rightDayClickView = [[UIView alloc] init];
    [rightDayClickView addGestureRecognizer:rightDayTap];
    rightDayClickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightDayClickView];
    self.s_RightDayClickView = rightDayClickView;
    
    // 日期文字
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = self.s_LeftLabelFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBColor(69, 61, 63, 1);
        [self addSubview:label];
        [marr addObject:label];
    }
    self.s_LeftLeftLabel = marr[0];
    self.s_LeftLabel = marr[1];
    self.s_CenterLabel = marr[2];
    self.s_RightLabel = marr[3];
    self.s_RightRightLabel = marr[4];
    
    // 动画遮挡
    UIView *leftMaskView = [[UIView alloc] init];
    leftMaskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftMaskView];
    self.s_LeftMaskView = leftMaskView;

    UIView *rightMaskView = [[UIView alloc] init];
    rightMaskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightMaskView];
    self.s_RightMaskView = rightMaskView;
    
    // 渐变层
    CAGradientLayer *leftLayer = [[CAGradientLayer alloc] init];
    leftLayer.colors = @[
                         (__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor,
                         (__bridge id)[UIColor colorWithWhite:1 alpha:0.28].CGColor,
                         ];
    leftLayer.locations = @[@0,@1];
    leftLayer.startPoint = CGPointMake(0, 0);
    leftLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:leftLayer];
    self.s_LeftGradientLayer = leftLayer;
    
    CAGradientLayer *rightLayer = [[CAGradientLayer alloc] init];
    rightLayer.colors = @[
                         (__bridge id)[UIColor colorWithWhite:1 alpha:0.28].CGColor,
                         (__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor,
                         ];
    rightLayer.locations = @[@0,@1];
    rightLayer.startPoint = CGPointMake(0, 0);
    rightLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:rightLayer];
    self.s_RightGradientLayer = rightLayer;
    
    // 中心视图
    BBHomeBabyGrowthDayCenterView *centerView = [[BBHomeBabyGrowthDayCenterView alloc] init];
    [self addSubview:centerView];
    self.s_CenterView = centerView;
    
    // 今日
    UIView *todayView = [[UIView alloc] init];
    [todayView addGestureRecognizer:todayViewTap];
    todayView.backgroundColor = RGBColor(204, 201, 202, 1);
    [self addSubview:todayView];
    self.s_TodayView = todayView;
    
    UILabel *todayLabel = [[UILabel alloc] init];
    todayLabel.text = @"今天";
    todayLabel.font = [UIFont systemFontOfSize:12];
    todayLabel.textColor = [UIColor whiteColor];
    [self.s_TodayView addSubview:todayLabel];
    self.s_TodayLabel = todayLabel;
}
- (void)setupPosition{
    if (self.s_IsAnimating) {return;}
    
    CGFloat viewHeight = 30;
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 中心视图
    CGFloat centerViewWidth = 84;
    CGFloat centerViewX = ceilf((viewWidth-centerViewWidth)*0.5);
    CGRect centerViewFrame = CGRectMake(centerViewX, 0, centerViewWidth, viewHeight);
    
    // 左右label
    CGFloat labelTextWidth = [[BBHomeBabyGrowthDayCenterView class] dateLabelWidth];
    CGFloat labelPadding = 20;
    CGFloat centerLabelX = ceilf(centerViewX+(centerViewWidth-labelTextWidth)*0.5);
    CGFloat leftLabelX = centerLabelX-labelPadding-labelTextWidth;
    CGFloat rightLabelX = centerLabelX+labelPadding+labelTextWidth;
    CGFloat leftLeftLabelX = leftLabelX-labelPadding-labelTextWidth;
    CGFloat rightRightLabelX = rightLabelX+labelPadding+labelTextWidth;
    CGRect leftLabelFrame = CGRectMake(leftLabelX, 0, labelTextWidth, viewHeight);
    CGRect rightLabelFrame = CGRectMake(rightLabelX, 0, labelTextWidth, viewHeight);
    CGRect centerLabelFrame = CGRectMake(centerLabelX, 0, labelTextWidth, viewHeight);
    CGRect leftLeftLabelFrame = CGRectMake(leftLeftLabelX, 0, labelTextWidth, viewHeight);
    CGRect rightRightLabelFrame = CGRectMake(rightRightLabelX, 0, labelTextWidth, viewHeight);
    
    CGFloat leftMaskViewWidth = leftLabelX;
    CGFloat rightMaskViewX = viewWidth-leftMaskViewWidth;
    CGRect leftMaskViewFrame = CGRectMake(0, 0, leftMaskViewWidth, viewHeight);
    CGRect rightMaskViewFrame = CGRectMake(rightMaskViewX, 0, leftMaskViewWidth, viewHeight);
    
    // 左右渐变
    CGFloat layerWidth = 76;
    CGFloat layerPadding = 14;
    CGFloat leftLayerX = centerViewX-layerPadding-layerWidth;
    CGFloat rightLayerX = ceilf(CGRectGetMaxX(centerViewFrame)+layerPadding);
    CGRect leftLayerFrame = CGRectMake(leftLayerX, 0, layerWidth, viewHeight);
    CGRect rightLayerFrame = CGRectMake(rightLayerX, 0, layerWidth, viewHeight);
    
    // 今天
    CGFloat todayViewHeight = 24;
    CGFloat todayViewCornerRadius = ceilf(todayViewHeight*0.5);
    CGFloat todayViewWidth = 48+todayViewCornerRadius;
    CGFloat todayViewShowX = viewWidth-todayViewWidth+todayViewCornerRadius;
    CGFloat todayViewY = ceilf((viewHeight-todayViewHeight)*0.5);
    CGRect todayViewShowFrame = CGRectMake(todayViewShowX, todayViewY, todayViewWidth, todayViewHeight);
    CGRect todayViewHiddenFrame = CGRectMake(viewWidth, todayViewY, todayViewWidth, todayViewHeight);
    CGRect todayLabelFrame = CGRectMake(7, 0, todayViewWidth-7, todayViewHeight);
    
    self.s_CenterView.frame = centerViewFrame;
    self.s_LeftLeftLabel.frame = leftLeftLabelFrame;
    self.s_LeftLabel.frame = leftLabelFrame;
    self.s_CenterLabel.frame = centerLabelFrame;
    self.s_RightLabel.frame = rightLabelFrame;
    self.s_RightRightLabel.frame = rightRightLabelFrame;
    
    self.s_LeftMaskView.frame = leftMaskViewFrame;
    self.s_RightMaskView.frame = rightMaskViewFrame;
    self.s_LeftGradientLayer.frame = leftLayerFrame;
    self.s_RightGradientLayer.frame = rightLayerFrame;
    self.s_LeftDayClickView.frame = leftLabelFrame;
    self.s_RightDayClickView.frame = rightLabelFrame;
    
    self.s_TodayView.frame = todayViewHiddenFrame;
    self.s_TodayLabel.frame = todayLabelFrame;
    self.s_TodayView.layer.cornerRadius = todayViewCornerRadius;
    self.s_TodayView.layer.masksToBounds = YES;
    
    self.s_LeftLabelFrame = leftLabelFrame;
    self.s_CenterLabelFrame = centerLabelFrame;
    self.s_RightLabelFrame = rightLabelFrame;
    self.s_LeftLeftLabelFrame = leftLeftLabelFrame;
    self.s_RightRightLabelFrame = rightRightLabelFrame;
    self.s_TodayViewShowFrame = todayViewShowFrame;
    self.s_TodayViewHiddenFrame = todayViewHiddenFrame;
}
- (void)resetPosition{
    self.s_LeftLeftLabel.frame = self.s_LeftLeftLabelFrame;
    self.s_LeftLabel.frame = self.s_LeftLabelFrame;
    self.s_CenterLabel.frame = self.s_CenterLabelFrame;
    self.s_RightLabel.frame = self.s_RightLabelFrame;
    self.s_RightRightLabel.frame = self.s_RightRightLabelFrame;
}
- (CGSize)intrinsicContentSize{
    return CGSizeMake(-1, 30);
}

#pragma mark - 数据源
- (NSInteger)itemCount{
    NSInteger count = 0;
    if ([self.m_DataSource respondsToSelector:@selector(numberOfDateComponentsInHomeBabyGrowthDayView:)]) {
        count = [self.m_DataSource numberOfDateComponentsInHomeBabyGrowthDayView:self];
    }
    return count;
}
- (NSDateComponents *)previousPreviousDateComponents{
    NSInteger previousIndex = self.s_CurrentIndex-2;
    
    return [self dateComponentsWithIndex:previousIndex];
}
- (NSDateComponents *)previousDateComponents{
    NSInteger previousIndex = self.s_CurrentIndex-1;
    
    return [self dateComponentsWithIndex:previousIndex];
}
- (NSDateComponents *)nextDateComponents{
    NSInteger nextIndex = self.s_CurrentIndex+1;
    
    return [self dateComponentsWithIndex:nextIndex];
}
- (NSDateComponents *)nextNextDateComponents{
    NSInteger nextIndex = self.s_CurrentIndex+2;
    
    return [self dateComponentsWithIndex:nextIndex];
}
- (NSDateComponents *)dateComponentsWithIndex:(NSInteger)index{
    NSInteger count = [self itemCount];
    if (index>=count || index<0) {return nil;}
    
    NSDateComponents *dateComponents = [self.m_DataSource homeBabyGrowthDayView:self dateComponentsOfIndex:index];
    return dateComponents;
}
#pragma mark - 视图刷新
- (void)resetViewWithItemIndex:(NSInteger)index{
    if (self.s_IsAnimating) {return;}
    NSDateComponents *dateComponents = [self dateComponentsWithIndex:index];
    if (!dateComponents) {return;}
    
    self.s_CurrentIndex = index;
    [self resetViewWithDateComponents:dateComponents];
}
- (void)resetViewWithDateComponents:(NSDateComponents *)dateComponents{
    if (self.s_IsAnimating) {return;}
    self.s_CurrentDateComponents = dateComponents;
    
    NSDateComponents *ppDateComponents = [self previousPreviousDateComponents];
    NSDateComponents *previousDateComponents = [self previousDateComponents];
    NSDateComponents *nextDateComponents = [self nextDateComponents];
    NSDateComponents *nnDateComponents = [self nextNextDateComponents];
    NSString *leftLeftString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:ppDateComponents];
    NSString *leftString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:previousDateComponents];
    NSString *centerString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:dateComponents];
    NSString *rightString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:nextDateComponents];
    NSString *rightRightString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:nnDateComponents];
    
    self.s_LeftLeftLabel.text = leftLeftString;
    self.s_LeftLabel.text = leftString;
    self.s_CenterLabel.text = centerString;
    self.s_RightLabel.text = rightString;
    self.s_RightRightLabel.text = rightRightString;
    [self.s_CenterView resetCenterDateComponents:dateComponents];
    
    [self checkTodayViewStateWithAnimation:NO];
}
- (void)checkTodayViewStateWithAnimation:(BOOL)isAnimate{
    if (self.s_CurrentDateComponents) {
        NSInteger year = self.s_CurrentDateComponents.year;
        NSInteger month = self.s_CurrentDateComponents.month;
        NSInteger day = self.s_CurrentDateComponents.day;
        
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *todayCpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
        if (year==todayCpt.year&&month==todayCpt.month&&day==todayCpt.day) {
            [self hideTodayViewAnimated:isAnimate];
            return;
        }
    }
    [self showToayViewAnimated:isAnimate];
}
#pragma mark - 视图滚动
- (void)scrollToPreviousDate{
    if (self.s_IsAnimating) {return;}
    if (!self.s_CurrentDateComponents) {return;}
    NSDateComponents *previousDateComponents = [self previousDateComponents];
    if (!previousDateComponents) {return;}
    
    self.s_CurrentIndex--;
    self.s_CurrentDateComponents = previousDateComponents;
    [self checkTodayViewStateWithAnimation:YES];
    [self.s_CenterView scrollToLeftDateComponents:previousDateComponents];
    [self animateScrollToPreviousDate:YES];
}
- (void)scrollToNextDate{
    if (self.s_IsAnimating) {return;}
    if (!self.s_CurrentDateComponents) {return;}
    NSDateComponents *nextDateComponents = [self nextDateComponents];
    if (!nextDateComponents) {return;}
    
    self.s_CurrentIndex++;
    self.s_CurrentDateComponents = nextDateComponents;
    [self checkTodayViewStateWithAnimation:YES];
    [self.s_CenterView scrollToRightDateComponents:nextDateComponents];
    [self animateScrollToPreviousDate:NO];
}
- (void)animateScrollToPreviousDate:(BOOL)isScrollToPrevious{
    self.s_IsAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{
        if (isScrollToPrevious) {
            weakSelf.s_LeftLeftLabel.frame = weakSelf.s_LeftLabelFrame;
            weakSelf.s_LeftLabel.frame = weakSelf.s_CenterLabelFrame;
            weakSelf.s_CenterLabel.frame = weakSelf.s_RightLabelFrame;
            weakSelf.s_RightLabel.frame = weakSelf.s_RightRightLabelFrame;
            weakSelf.s_RightRightLabel.frame = weakSelf.s_RightRightLabelFrame;
        }else{
            weakSelf.s_LeftLeftLabel.frame = weakSelf.s_LeftLeftLabelFrame;
            weakSelf.s_LeftLabel.frame = weakSelf.s_LeftLeftLabelFrame;
            weakSelf.s_CenterLabel.frame = weakSelf.s_LeftLabelFrame;
            weakSelf.s_RightLabel.frame = weakSelf.s_CenterLabelFrame;
            weakSelf.s_RightRightLabel.frame = weakSelf.s_RightLabelFrame;
        }
    } completion:^(BOOL finished) {
        UILabel *tempLabel = self.s_CenterLabel;
        if (isScrollToPrevious) {
            weakSelf.s_CenterLabel = weakSelf.s_LeftLabel;
            weakSelf.s_LeftLabel = weakSelf.s_LeftLeftLabel;
            weakSelf.s_LeftLeftLabel = weakSelf.s_RightRightLabel;
            weakSelf.s_RightRightLabel = weakSelf.s_RightLabel;
            weakSelf.s_RightLabel = tempLabel;
        }else{
            weakSelf.s_CenterLabel = weakSelf.s_RightLabel;
            weakSelf.s_RightLabel = weakSelf.s_RightRightLabel;
            weakSelf.s_RightRightLabel = weakSelf.s_LeftLeftLabel;
            weakSelf.s_LeftLeftLabel = weakSelf.s_LeftLabel;
            weakSelf.s_LeftLabel = tempLabel;
        }
        weakSelf.s_IsAnimating = NO;
        [weakSelf resetViewWithDateComponents:self.s_CurrentDateComponents];
        [weakSelf resetPosition];
    }];
}
#pragma mark - 今日视图动画
- (void)showToayViewAnimated:(BOOL)isAnimated{
    if (self.s_IsTodayViewAnimating) {return;}
    
    if (!isAnimated) {
        self.s_TodayView.frame = self.s_TodayViewShowFrame;
        return;
    }
    
    self.s_IsTodayViewAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{
        weakSelf.s_TodayView.frame = weakSelf.s_TodayViewShowFrame;
    } completion:^(BOOL finished) {
        weakSelf.s_IsTodayViewAnimating = NO;
    }];
}
- (void)hideTodayViewAnimated:(BOOL)isAnimated{
    if (self.s_IsTodayViewAnimating) {return;}
    
    if (!isAnimated) {
        self.s_TodayView.frame = self.s_TodayViewHiddenFrame;
        return;
    }
    
    self.s_IsTodayViewAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{
        weakSelf.s_TodayView.frame = weakSelf.s_TodayViewHiddenFrame;
    } completion:^(BOOL finished) {
        weakSelf.s_IsTodayViewAnimating = NO;
    }];
}
#pragma mark - 点击方法
- (void)leftDayViewDidClick:(UITapGestureRecognizer *)tap{
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthDayViewDidClickLeftDay:)]) {
        [self.m_Delegate homeBabyGrowthDayViewDidClickLeftDay:self];
    }
}
- (void)rightDayViewDidClick:(UITapGestureRecognizer *)tap{
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthDayViewDidClickRightDay:)]) {
        [self.m_Delegate homeBabyGrowthDayViewDidClickRightDay:self];
    }
}
- (void)todayViewDidClick:(UITapGestureRecognizer *)tap{
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthDayViewDidClickTodayView:)]) {
        [self.m_Delegate homeBabyGrowthDayViewDidClickTodayView:self];
    }
}

@end
