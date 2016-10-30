//
//  BBHorizontalScrollLabelView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHorizontalScrollLabelView.h"
#import "BBAutoCalculationSize.h"
#import "BBVerticalAlignmentLabel.h"

static CGFloat const kLabelFrameHeight = 1000;
static NSTimeInterval const kAnimationTime = 0.25;

@interface BBHorizontalScrollLabelView ()

@property (nonatomic, weak) UILabel *s_LeftLabel;
@property (nonatomic, weak) UILabel *s_CenterLabel;
@property (nonatomic, weak) UILabel *s_RightLabel;

@property (nonatomic, assign) BOOL s_IsAnimating;

@property (nonatomic, copy) NSString *s_CenterString;
@property (nonatomic, assign) CGFloat s_ContentWidth;
@property (nonatomic, assign) CGFloat s_ContentHeight;

@end

@implementation BBHorizontalScrollLabelView

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
    self.s_IsAnimating = NO;
    self.clipsToBounds = YES;
    self.m_Font = [UIFont systemFontOfSize:14];
    self.m_Color = RGBColor(4, 4, 4, 1);
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<3; i++) {
        BBVerticalAlignmentLabel *label = [[BBVerticalAlignmentLabel alloc] init];
        label.m_VerticalAlignment = BBVerticalAlignmentTypeTop;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = self.m_Font;
        label.textColor = self.m_Color;
        [self addSubview:label];
        [marr addObject:label];
    }
    self.s_LeftLabel = marr[0];
    self.s_CenterLabel = marr[1];
    self.s_RightLabel = marr[2];
}
- (void)setupData{
    
}

- (void)resetPosition{
    CGRect leftFrame = CGRectMake(-self.s_ContentWidth, 0, self.s_ContentWidth, kLabelFrameHeight);
    CGRect centerFrame = CGRectMake(0, 0, self.s_ContentWidth, kLabelFrameHeight);
    CGRect rightFrame = CGRectMake(self.s_ContentWidth, 0, self.s_ContentWidth, kLabelFrameHeight);
    
    self.s_LeftLabel.frame = leftFrame;
    self.s_CenterLabel.frame = centerFrame;
    self.s_RightLabel.frame = rightFrame;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.s_IsAnimating) {return;}
    
    // 以实际宽度为准
    self.s_ContentWidth = self.bounds.size.width;
    [self resetPosition];
}
- (CGSize)sizeThatFits:(CGSize)size{
    CGSize contentSize = [self intrinsicContentSize];
    return contentSize;
}
- (CGSize)intrinsicContentSize{
    CGFloat minHeight = self.m_Font.lineHeight;
    if (self.s_CenterString.length == 0) {
        return CGSizeMake(-1, minHeight);
    }
    
    CGFloat height = [self textHeightWithString:self.s_CenterString];
    height = height==0 ? minHeight : height;
    return CGSizeMake(-1, height);
}

#pragma mark - 外部变量设置
- (void)setM_Font:(UIFont *)m_Font{
    _m_Font = m_Font;
    self.s_LeftLabel.font = m_Font;
    self.s_CenterLabel.font = m_Font;
    self.s_RightLabel.font = m_Font;
    [self invalidateIntrinsicContentSize];
}
- (void)setM_Color:(UIColor *)m_Color{
    _m_Color = m_Color;
    self.s_LeftLabel.textColor = m_Color;
    self.s_CenterLabel.textColor = m_Color;
    self.s_RightLabel.textColor = m_Color;
}
- (void)setM_PreferedMaxLayoutWidth:(CGFloat)m_PreferedMaxLayoutWidth{
    _m_PreferedMaxLayoutWidth = m_PreferedMaxLayoutWidth;
    
    self.s_ContentWidth = m_PreferedMaxLayoutWidth;
}
- (void)setS_ContentWidth:(CGFloat)s_ContentWidth{
    _s_ContentWidth = s_ContentWidth;
    
    self.s_LeftLabel.preferredMaxLayoutWidth = s_ContentWidth;
    self.s_CenterLabel.preferredMaxLayoutWidth = s_ContentWidth;
    self.s_RightLabel.preferredMaxLayoutWidth = s_ContentWidth;
}

- (void)resetWithCenterString:(NSString *)string{
    self.s_CenterString = string;
    
    self.s_CenterLabel.text = self.s_CenterString;
    [self invalidateIntrinsicContentSize];
}
- (void)leftSlideWithCenterString:(NSString *)string{
    if (self.s_IsAnimating) {return;}
    
    self.s_CenterString = string;
    self.s_RightLabel.text = self.s_CenterString;
    
    CGRect leftFrame = CGRectMake(-self.s_ContentWidth, 0, self.s_ContentWidth, kLabelFrameHeight);
    CGRect centerFrame = CGRectMake(0, 0, self.s_ContentWidth, kLabelFrameHeight);
    
    [self animateWithOldCenterLabel:self.s_CenterLabel oldCenterLabelFrame:leftFrame newCenterLabel:self.s_RightLabel newCenterLabelFrame:centerFrame isLeftSlide:YES];
}
- (void)rightSlideWithCenterString:(NSString *)string{
    if (self.s_IsAnimating) {return;}
    
    self.s_CenterString = string;
    self.s_LeftLabel.text = self.s_CenterString;
    
    CGRect centerFrame = CGRectMake(0, 0, self.s_ContentWidth, kLabelFrameHeight);
    CGRect rightFrame = CGRectMake(self.s_ContentWidth, 0, self.s_ContentWidth, kLabelFrameHeight);
    
    [self animateWithOldCenterLabel:self.s_CenterLabel oldCenterLabelFrame:rightFrame newCenterLabel:self.s_LeftLabel newCenterLabelFrame:centerFrame isLeftSlide:NO];
}

- (void)animateWithOldCenterLabel:(UILabel *)oldCenterLabel
              oldCenterLabelFrame:(CGRect)oldCenterLabelFrame
                   newCenterLabel:(UILabel *)newCenterLabel
              newCenterLabelFrame:(CGRect)newCenterLabelFrame
                        isLeftSlide:(BOOL)isLeftSlide{
    
    [self invalidateIntrinsicContentSize];
    CGFloat viewHeight = [self intrinsicContentSize].height;
    if ([self.m_Delegate respondsToSelector:@selector(horizontalScrollLabelView:willScrollToText:viewNewHeight:)]) {
        [self.m_Delegate horizontalScrollLabelView:self willScrollToText:self.s_CenterString viewNewHeight:viewHeight];
    }
    
    self.s_IsAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{
        oldCenterLabel.frame = oldCenterLabelFrame;
        newCenterLabel.frame = newCenterLabelFrame;
    } completion:^(BOOL finished) {
        oldCenterLabel.text = nil;
        weakSelf.s_CenterLabel = newCenterLabel;
        if (isLeftSlide) {
            weakSelf.s_RightLabel = oldCenterLabel;
        }else{
            weakSelf.s_LeftLabel = oldCenterLabel;
        }
        [weakSelf resetPosition];
        weakSelf.s_IsAnimating = NO;
        
        if ([weakSelf.m_Delegate respondsToSelector:@selector(horizontalScrollLabelView:didScrollToText:viewNewHeight:)]) {
            [weakSelf.m_Delegate horizontalScrollLabelView:weakSelf didScrollToText:weakSelf.s_CenterString viewNewHeight:viewHeight];
        }
    }];
}

- (CGFloat)textHeightWithString:(NSString *)string{
    CGFloat height = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(self.s_ContentWidth, 0) withFont:self.m_Font withString:string].height;
    return ceilf(height);
}

@end
