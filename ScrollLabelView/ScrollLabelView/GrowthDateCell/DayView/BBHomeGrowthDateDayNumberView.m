//
//  BBHomeGrowthDateDayNumberView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthDateDayNumberView.h"
#import "BBAutoCalculationSize.h"

@interface BBHomeGrowthDateDayNumberView ()

@property (nonatomic, weak) UILabel *s_UpLabel;
@property (nonatomic, weak) UILabel *s_CenterLabel;
@property (nonatomic, weak) UILabel *s_DownLabel;

@property (nonatomic, strong) UIFont *s_Font;
@property (nonatomic, assign) BOOL s_IsAnimating;

@property (nonatomic, assign) NSInteger s_Number;
@end

@implementation BBHomeGrowthDateDayNumberView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupData];
}
- (void)setupViews{
    self.clipsToBounds = YES;
    self.s_IsAnimating = NO;
    self.s_Font = [UIFont systemFontOfSize:56];
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.s_Font;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [marr addObject:label];
    }
    self.s_UpLabel = marr[0];
    self.s_CenterLabel = marr[1];
    self.s_DownLabel = marr[2];
}
- (void)setupData{
    self.s_CenterLabel.text = @" ";
}
- (void)resetPosition{
    CGSize contentSize = [self intrinsicContentSize];
    CGRect upFrame = CGRectMake(0, -contentSize.height, contentSize.width, contentSize.height);
    CGRect centerFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    CGRect downFrame = CGRectMake(0, contentSize.height, contentSize.width, contentSize.height);
    
    self.s_UpLabel.frame = upFrame;
    self.s_CenterLabel.frame = centerFrame;
    self.s_DownLabel.frame = downFrame;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.s_IsAnimating) {return;}
    
    [self resetPosition];
}
- (CGSize)sizeThatFits:(CGSize)size{
    CGSize contentSize = [self intrinsicContentSize];
    return contentSize;
}
- (CGSize)intrinsicContentSize{
    NSString *numberString = @"0";
    CGSize size = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeZero withFont:self.s_Font withString:numberString];
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    return size;
}

- (void)resetWithNumber:(NSInteger)number{
    self.s_Number = number;
    
    self.s_CenterLabel.text = [NSString stringWithFormat:@"%ld", number];
}
- (void)upSlideWithNumber:(NSInteger)number{
    if (self.s_IsAnimating) {return;}
    self.s_Number = number;
    
    self.s_DownLabel.text = [NSString stringWithFormat:@"%ld", number];
    
    CGSize contentSize = [self intrinsicContentSize];
    CGRect upFrame = CGRectMake(0, -contentSize.height, contentSize.width, contentSize.height);
    CGRect centerFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    
    [self animateWithOldCenterLabel:self.s_CenterLabel oldCenterLabelFrame:upFrame newCenterLabel:self.s_DownLabel newCenterLabelFrame:centerFrame isUpSlide:YES];
}
- (void)downSlideWithNumber:(NSInteger)number{
    if (self.s_IsAnimating) {return;}
    self.s_Number = number;
    
    self.s_UpLabel.text = [NSString stringWithFormat:@"%ld", number];
    
    CGSize contentSize = [self intrinsicContentSize];
    CGRect centerFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    CGRect downFrame = CGRectMake(0, contentSize.height, contentSize.width, contentSize.height);
    
    [self animateWithOldCenterLabel:self.s_CenterLabel oldCenterLabelFrame:downFrame newCenterLabel:self.s_UpLabel newCenterLabelFrame:centerFrame isUpSlide:NO];
}

- (void)animateWithOldCenterLabel:(UILabel *)oldCenterLabel
              oldCenterLabelFrame:(CGRect)oldCenterLabelFrame
                   newCenterLabel:(UILabel *)newCenterLabel
              newCenterLabelFrame:(CGRect)newCenterLabelFrame
                        isUpSlide:(BOOL)isUpSlide{
    
    self.s_IsAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        oldCenterLabel.frame = oldCenterLabelFrame;
        newCenterLabel.frame = newCenterLabelFrame;
    } completion:^(BOOL finished) {
        weakSelf.s_CenterLabel = newCenterLabel;
        if (isUpSlide) {
            weakSelf.s_DownLabel = oldCenterLabel;
        }else{
            weakSelf.s_UpLabel = oldCenterLabel;
        }
        [weakSelf resetPosition];
        weakSelf.s_IsAnimating = NO;
    }];
}


@end
