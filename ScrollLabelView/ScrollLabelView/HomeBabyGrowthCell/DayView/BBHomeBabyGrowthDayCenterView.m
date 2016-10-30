//
//  BBHomeBabyGrowthDayCenterView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthDayCenterView.h"
#import "BBAutoCalculationSize.h"

static NSTimeInterval const kAnimationTime = 0.25;

@interface BBHomeBabyGrowthDayCenterView ()

@property (nonatomic, weak) UILabel *s_LeftLabel;
@property (nonatomic, weak) UILabel *s_CenterLabel;
@property (nonatomic, weak) UILabel *s_RightLabel;

@property (nonatomic, assign) CGSize s_ViewSize;
@property (nonatomic, assign) BOOL s_IsAnimating;

@property (nonatomic, assign) CGRect s_LeftLabelFrame;
@property (nonatomic, assign) CGRect s_CenterLabelFrame;
@property (nonatomic, assign) CGRect s_RightLabelFrame;

@end

@implementation BBHomeBabyGrowthDayCenterView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.s_IsAnimating = NO;
    [self setupViews];
    [self setupPosition];
}
- (void)setupViews{
    self.backgroundColor = RGBColor(221, 242, 246, 1);
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGBColor(117, 210, 212, 1);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [marr addObject:label];
    }
    self.s_LeftLabel = marr[0];
    self.s_CenterLabel = marr[1];
    self.s_RightLabel = marr[2];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    if (width == 0) {return;}
    if (self.s_IsAnimating) {return;}
    
    self.s_ViewSize = self.bounds.size;
    [self setupPosition];
}

- (void)setupPosition{
    if (self.s_IsAnimating) {return;}
    CGFloat viewHeight = self.s_ViewSize.height;
    
    // 左右label
    CGFloat labelTextWidth = [[BBHomeBabyGrowthDayCenterView class] dateLabelWidth];
    CGFloat labelPadding = 20;
    CGFloat centerLabelX = ceilf((self.s_ViewSize.width-labelTextWidth)*0.5);
    CGFloat leftLabelX = centerLabelX-labelPadding-labelTextWidth;
    CGFloat rightLabelX = centerLabelX+labelPadding+labelTextWidth;
    CGRect centerLabelFrame = CGRectMake(centerLabelX, 0, labelTextWidth, viewHeight);
    CGRect leftLabelFrame = CGRectMake(leftLabelX, 0, labelTextWidth, viewHeight);
    CGRect rightLabelFrame = CGRectMake(rightLabelX, 0, labelTextWidth, viewHeight);
    
    self.s_LeftLabel.frame = leftLabelFrame;
    self.s_RightLabel.frame = rightLabelFrame;
    self.s_CenterLabel.frame = centerLabelFrame;
    
    self.s_LeftLabelFrame = leftLabelFrame;
    self.s_CenterLabelFrame = centerLabelFrame;
    self.s_RightLabelFrame = rightLabelFrame;
}
- (void)resetPosition{
    self.s_LeftLabel.frame = self.s_LeftLabelFrame;
    self.s_CenterLabel.frame = self.s_CenterLabelFrame;
    self.s_RightLabel.frame = self.s_RightLabelFrame;
}
- (void)resetCenterDateComponents:(NSDateComponents *)dateComponents{
    if (self.s_IsAnimating) {return;}
    if (!dateComponents) {return;}
    
    NSString *centerString = [BBHomeBabyGrowthDayCenterView dateStringFromDateComponents:dateComponents];
    self.s_CenterLabel.text = centerString;
}
- (void)scrollToLeftDateComponents:(NSDateComponents *)dateComponents{
    if (self.s_IsAnimating) {return;}
    if (!dateComponents) {return;}
    
    NSString *leftString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:dateComponents];
    self.s_LeftLabel.text = leftString;
    
    [self animateScrollToPreviousDate:YES];
}
- (void)scrollToRightDateComponents:(NSDateComponents *)dateComponents{
    if (self.s_IsAnimating) {return;}
    if (!dateComponents) {return;}
    
    NSString *rightString = [[BBHomeBabyGrowthDayCenterView class] dateStringFromDateComponents:dateComponents];
    self.s_RightLabel.text = rightString;
    
    [self animateScrollToPreviousDate:NO];
}

- (void)animateScrollToPreviousDate:(BOOL)isScrollToPrevious{
    self.s_IsAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{
        if (isScrollToPrevious) {
            weakSelf.s_LeftLabel.frame = weakSelf.s_CenterLabelFrame;
            weakSelf.s_CenterLabel.frame = weakSelf.s_RightLabelFrame;
            weakSelf.s_RightLabel.frame = weakSelf.s_RightLabelFrame;
        }else{
            weakSelf.s_LeftLabel.frame = weakSelf.s_LeftLabelFrame;
            weakSelf.s_CenterLabel.frame = weakSelf.s_LeftLabelFrame;
            weakSelf.s_RightLabel.frame = weakSelf.s_CenterLabelFrame;
        }
    } completion:^(BOOL finished) {
        UILabel *tempLabel = self.s_CenterLabel;
        if (isScrollToPrevious) {
            weakSelf.s_CenterLabel = weakSelf.s_LeftLabel;
            weakSelf.s_LeftLabel = weakSelf.s_RightLabel;
            weakSelf.s_RightLabel = tempLabel;
        }else{
            weakSelf.s_CenterLabel = weakSelf.s_RightLabel;
            weakSelf.s_RightLabel = weakSelf.s_LeftLabel;
            weakSelf.s_LeftLabel = tempLabel;
        }
        weakSelf.s_IsAnimating = NO;
        weakSelf.s_LeftLabel.text = @"";
        weakSelf.s_RightLabel.text = @"";
        [weakSelf resetPosition];
    }];
}

#pragma mark - 私有逻辑
+ (CGFloat)dateLabelWidth{
    NSString *str = @"44月44日";
    CGFloat width = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeZero withFont:[UIFont systemFontOfSize:14] withString:str].width;
    return ceilf(width)+2;  // 确保任何日期都能显示完全
}
+ (NSString *)dateStringFromDateComponents:(NSDateComponents *)dateComponents{
    if (!dateComponents) {return nil;}
    NSString *string = [NSString stringWithFormat:@"%ld月%02ld日",dateComponents.month, dateComponents.day];
    return string;
}


@end
