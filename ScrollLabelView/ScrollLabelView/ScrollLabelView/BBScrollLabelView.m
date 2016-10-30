//
//  BBScrollLabelView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/17.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBScrollLabelView.h"
#import <Masonry/Masonry.h>
#import "BBAutoCalculationSize.h"

@interface BBScrollLabelView ()

@property (nonatomic, weak) UILabel *s_LeftLabel;
@property (nonatomic, weak) UILabel *s_RightLabel;
@property (nonatomic, weak) UILabel *s_CenterLabel;
@property (nonatomic, weak) UILabel *s_UpLabel;
@property (nonatomic, weak) UILabel *s_DownLabel;

// 内容宽高
@property (nonatomic, assign) CGFloat s_IntrinsicContentWidth;
@property (nonatomic, assign) CGFloat s_IntrinsicContentHeight;
// 当前显示的数据索引
@property (nonatomic, assign) NSInteger s_CurrentIndex;
@property (nonatomic, assign) BOOL s_IsAnimating;
@end

@implementation BBScrollLabelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.clipsToBounds = YES;
    self.s_CurrentIndex = 0;
    self.s_IsAnimating = NO;
    self.m_ScrollType = BBScrollLabelViewScrollTypeLeftRight;
    [self setupViews];
}
- (void)setupViews{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [self addSubview:label];
        [marr addObject:label];
    }
    
    self.s_UpLabel = marr[0];
    self.s_DownLabel = marr[1];
    self.s_CenterLabel = marr[2];
    self.s_LeftLabel = marr[3];
    self.s_RightLabel = marr[4];
}
- (void)resetLabelText{
    self.s_CenterLabel.text = [self currentText];
    self.s_LeftLabel.text = [self previousText];
    self.s_UpLabel.text = [self previousText];
    self.s_DownLabel.text = [self nextText];
    self.s_RightLabel.text = [self nextText];
}
- (void)resetLabelPosition{
    CGSize size = self.bounds.size;
    
    CGSize currentSize = [self currentTextSize];
    CGSize previousSize = [self previousTextSize];
    CGSize nextSize = [self nextTextSize];
    
    CGRect upFrame = CGRectMake(0, -previousSize.height, size.width, previousSize.height);
    CGRect downFrame = CGRectMake(0, size.height, size.width, nextSize.height);
    CGRect centerFrame = CGRectMake(0, 0, size.width, currentSize.height);
    CGRect leftFrame = CGRectMake(-size.width, 0, size.width, previousSize.height);
    CGRect rightFrame = CGRectMake(size.width, 0, size.width, nextSize.height);
    
    self.s_UpLabel.hidden = YES;
    self.s_DownLabel.hidden = YES;
    self.s_LeftLabel.hidden = YES;
    self.s_RightLabel.hidden = YES;
    self.s_CenterLabel.hidden = NO;
    
    self.s_UpLabel.frame = upFrame;
    self.s_DownLabel.frame = downFrame;
    self.s_CenterLabel.frame = centerFrame;
    self.s_LeftLabel.frame = leftFrame;
    self.s_RightLabel.frame = rightFrame;
    
    self.s_UpLabel.preferredMaxLayoutWidth = size.width;
    self.s_DownLabel.preferredMaxLayoutWidth = size.width;
    self.s_CenterLabel.preferredMaxLayoutWidth = size.width;
    self.s_LeftLabel.preferredMaxLayoutWidth = size.width;
    self.s_RightLabel.preferredMaxLayoutWidth = size.width;
}
// 初始化数据
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {return;}
    
    [self resetLabelText];
}
// 初始化位置
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.s_IsAnimating) {return;}
    
    [self sizeToFit];
    [self resetLabelPosition];
}
- (CGSize)sizeThatFits:(CGSize)size{
    CGSize viewSize = self.frame.size;
    CGFloat height = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(viewSize.width, 0) withFont:self.m_Font withString:[self currentText]].height;
    height = ceilf(height);
    return CGSizeMake(viewSize.width, height);
}
- (void)setM_Font:(UIFont *)m_Font{
    _m_Font = m_Font;
    
    self.s_UpLabel.font = m_Font;
    self.s_DownLabel.font = m_Font;
    self.s_CenterLabel.font = m_Font;
    self.s_LeftLabel.font = m_Font;
    self.s_RightLabel.font = m_Font;
}
- (void)setM_TextColor:(UIColor *)m_TextColor{
    _m_TextColor = m_TextColor;
    
    self.s_UpLabel.textColor = m_TextColor;
    self.s_DownLabel.textColor = m_TextColor;
    self.s_CenterLabel.textColor = m_TextColor;
    self.s_LeftLabel.textColor = m_TextColor;
    self.s_RightLabel.textColor = m_TextColor;
}
#pragma mark - 数据源
#pragma mark 索引
- (NSInteger)previousIndex{
    NSInteger previousIndex = self.s_CurrentIndex-1;
    if (previousIndex < 0) {
        return NSNotFound;
    }
    return previousIndex;
}
- (NSInteger)nextIndex{
    NSInteger textCount = [self textCount];
    NSInteger nextIndex = self.s_CurrentIndex+1;
    if (nextIndex >= textCount) {return NSNotFound;}
    
    return nextIndex;
}
#pragma mark 内容
- (NSString *)currentText{
    return [self textOfIndex:self.s_CurrentIndex];
}
- (NSString *)previousText{
    NSInteger previousIndex = [self previousIndex];
    if (previousIndex == NSNotFound) {return @"";}
    
    return [self textOfIndex:previousIndex];
}
- (NSString *)nextText{
    NSInteger nextIndex = [self nextIndex];
    if (nextIndex == NSNotFound) {return @"";}
    
    return [self textOfIndex:nextIndex];
}
- (NSString *)textOfIndex:(NSInteger)index{
    NSString *text = nil;
    if ([self.m_DataSource respondsToSelector:@selector(scrollLabelView:textOfIndex:)]) {
        text = [self.m_DataSource scrollLabelView:self textOfIndex:index];
    }
    text = text ?: @"";
    return text;
}
- (NSInteger)textCount{
    NSInteger count = 0;
    if ([self.m_DataSource respondsToSelector:@selector(numberOfTextInScrollLabelView:)]) {
        count = [self.m_DataSource numberOfTextInScrollLabelView:self];
    }
    return count;
}
#pragma mark 内容高度
- (CGSize)currentTextSize{
    NSString *currentText = [self currentText];
    if (currentText.length == 0) {
        return CGSizeZero;
    }
    return [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(self.bounds.size.width, 0) withFont:self.m_Font withString:[self currentText]];
}
- (CGSize)previousTextSize{
    NSString *previousText = [self previousText];
    if (previousText.length == 0) {
        return CGSizeZero;
    }
    return [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(self.bounds.size.width, 0) withFont:self.m_Font withString:[self previousText]];
}
- (CGSize)nextTextSize{
    NSString *nextText = [self nextText];
    if (nextText.length == 0) {
        return CGSizeZero;
    }
    return [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(self.bounds.size.width, 0) withFont:self.m_Font withString:[self nextText]];
}
#pragma mark - 动作
- (void)swipeLeft:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    if (self.m_ScrollType == BBScrollLabelViewScrollTypeUpDown) {return;}
    if (self.s_IsAnimating) {return;}
    NSInteger nextIndex = [self nextIndex];
    if (nextIndex == NSNotFound) {return;}
    
    CGSize size = self.bounds.size;
    
    UILabel *oldCenterLabel = self.s_CenterLabel;
    CGRect oldCenterLabelFrame = oldCenterLabel.frame;
    oldCenterLabelFrame.origin.x = -size.width;
    
    UILabel *newCenterLabel = self.s_RightLabel;
    CGRect newCenterLabelFrame = newCenterLabel.frame;
    newCenterLabelFrame.origin.x = 0;
    
    [self animateWithOldCenterLabel:oldCenterLabel oldCenterLabelFrame:oldCenterLabelFrame newCenterLabel:newCenterLabel newCenterLabelFrame:newCenterLabelFrame direction:UISwipeGestureRecognizerDirectionLeft];
}
- (void)swipeRight:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    if (self.m_ScrollType == BBScrollLabelViewScrollTypeUpDown) {return;}
    if (self.s_IsAnimating) {return;}
    NSInteger previousIndex = [self previousIndex];
    if (previousIndex == NSNotFound) {return;}
    
    CGSize size = self.bounds.size;
    
    UILabel *oldCenterLabel = self.s_CenterLabel;
    CGRect oldCenterLabelFrame = oldCenterLabel.frame;
    oldCenterLabelFrame.origin.x = size.width;
    
    UILabel *newCenterLabel = self.s_LeftLabel;
    CGRect newCenterLabelFrame = newCenterLabel.frame;
    newCenterLabelFrame.origin.x = 0;
    
    [self animateWithOldCenterLabel:oldCenterLabel oldCenterLabelFrame:oldCenterLabelFrame newCenterLabel:newCenterLabel newCenterLabelFrame:newCenterLabelFrame direction:UISwipeGestureRecognizerDirectionRight];
}
- (void)swipeUp:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    if (self.m_ScrollType == BBScrollLabelViewScrollTypeLeftRight) {return;}
    if (self.s_IsAnimating) {return;}
    NSInteger nextIndex = [self nextIndex];
    if (nextIndex == NSNotFound) {return;}
    
    CGSize currentTextSize = [self currentTextSize];
    
    UILabel *oldCenterLabel = self.s_CenterLabel;
    CGRect oldCenterLabelFrame = oldCenterLabel.frame;
    oldCenterLabelFrame.origin.y = -currentTextSize.height;
    
    UILabel *newCenterLabel = self.s_DownLabel;
    CGRect newCenterLabelFrame = newCenterLabel.frame;
    newCenterLabelFrame.origin.y = 0;
    
    [self animateWithOldCenterLabel:oldCenterLabel oldCenterLabelFrame:oldCenterLabelFrame newCenterLabel:newCenterLabel newCenterLabelFrame:newCenterLabelFrame direction:UISwipeGestureRecognizerDirectionUp];
}
- (void)swipeDown:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    if (self.m_ScrollType == BBScrollLabelViewScrollTypeLeftRight) {return;}
    if (self.s_IsAnimating) {return;}
    NSInteger previousIndex = [self previousIndex];
    if (previousIndex == NSNotFound) {return;}
    
    CGSize currentTextSize = [self currentTextSize];
    
    UILabel *oldCenterLabel = self.s_CenterLabel;
    CGRect oldCenterLabelFrame = oldCenterLabel.frame;
    oldCenterLabelFrame.origin.y = currentTextSize.height;
    
    UILabel *newCenterLabel = self.s_UpLabel;
    CGRect newCenterLabelFrame = newCenterLabel.frame;
    newCenterLabelFrame.origin.y = 0;
    
    [self animateWithOldCenterLabel:oldCenterLabel oldCenterLabelFrame:oldCenterLabelFrame newCenterLabel:newCenterLabel newCenterLabelFrame:newCenterLabelFrame direction:UISwipeGestureRecognizerDirectionDown];
}

- (void)animateWithOldCenterLabel:(UILabel *)oldCenterLabel
              oldCenterLabelFrame:(CGRect)oldCenterLabelFrame
                   newCenterLabel:(UILabel *)newCenterLabel
              newCenterLabelFrame:(CGRect)newCenterLabelFrame
                        direction:(UISwipeGestureRecognizerDirection)direction{
    NSTimeInterval duration = self.m_Duration>0 ? self.m_Duration : 0.25;
    
    // 修改当前显示数据索引
    if (direction==UISwipeGestureRecognizerDirectionLeft || direction==UISwipeGestureRecognizerDirectionUp) {
        self.s_CurrentIndex = self.s_CurrentIndex + 1;
    }else{
        self.s_CurrentIndex = self.s_CurrentIndex - 1;
    }
    
    [self callBackBeforeAnimation:YES];
    
    // 滑动动画&结束回调
    oldCenterLabel.hidden = NO;
    newCenterLabel.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.s_IsAnimating = YES;
        oldCenterLabel.frame = oldCenterLabelFrame;
        newCenterLabel.frame = newCenterLabelFrame;
    } completion:^(BOOL finished) {
        weakSelf.s_CenterLabel = newCenterLabel;
        if (direction == UISwipeGestureRecognizerDirectionLeft) {
            weakSelf.s_RightLabel = oldCenterLabel;
        }else if (direction == UISwipeGestureRecognizerDirectionRight) {
            weakSelf.s_LeftLabel = oldCenterLabel;
        }else if (direction == UISwipeGestureRecognizerDirectionUp) {
            weakSelf.s_DownLabel = oldCenterLabel;
        }else if (direction == UISwipeGestureRecognizerDirectionDown) {
            weakSelf.s_UpLabel = oldCenterLabel;
        }
        [weakSelf resetLabelText];
        [weakSelf resetLabelPosition];
        weakSelf.s_IsAnimating = NO;
        
        // 动画结束后回调
        [weakSelf callBackBeforeAnimation:NO];
    }];
}
- (void)callBackBeforeAnimation:(BOOL)isBeforeAnimation{
    CGSize size = self.bounds.size;
    NSString *currentText = [self currentText];
    CGFloat height = [BBAutoCalculationSize autoCalculationSizeRect:CGSizeMake(size.width, 0) withFont:self.m_Font withString:currentText].height;
    
    if (isBeforeAnimation) {
        if ([self.m_Delegate respondsToSelector:@selector(scrollLabelView:willScrollToIndex:text:textHeight:)]) {
            [self.m_Delegate scrollLabelView:self willScrollToIndex:self.s_CurrentIndex text:currentText textHeight:height];
        }
    }else{
        if ([self.m_Delegate respondsToSelector:@selector(scrollLabelView:didScrollToIndex:text:textHeight:)]) {
            [self.m_Delegate scrollLabelView:self didScrollToIndex:self.s_CurrentIndex text:currentText textHeight:height];
        }
    }
}


@end
