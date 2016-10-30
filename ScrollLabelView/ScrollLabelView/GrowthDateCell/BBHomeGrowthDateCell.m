//
//  BBHomeGrowthDateCell.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthDateCell.h"
#import "BBHomeGrowthDateDayView.h"
#import "BBHomeGrowthDateBabyMessageView.h"
#import <Masonry/Masonry.h>

@interface BBHomeGrowthDateCell ()<BBHomeGrowthDateBabyMessageViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *s_BackdropView;
@property (nonatomic, weak) UIButton *s_LeftDateBtn;
@property (nonatomic, weak) UIButton *s_RightDateBtn;
@property (nonatomic, weak) BBHomeGrowthDateDayView *s_DayView;
@property (nonatomic, weak) BBHomeGrowthDateBabyMessageView *s_MessageView;

@property (nonatomic, assign) NSInteger s_CurrentIndex;
@property (nonatomic, strong, readwrite) BBHomeGrowthDateCellModel *m_CurrentModel;
// 以知识文本动画结束回调为标记
@property (nonatomic, assign) BOOL s_IsAnimation;
@end

@implementation BBHomeGrowthDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.s_CurrentIndex = 0;
    self.s_IsAnimation = NO;
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.delegate = self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.delegate = self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UIView *backdropView = [[UIView alloc] init];
    backdropView.backgroundColor = RGBColor(146, 212, 179, 1);
    [backdropView addGestureRecognizer:swipeLeft];
    [backdropView addGestureRecognizer:swipeRight];
    [self.contentView addSubview:backdropView];
    self.s_BackdropView = backdropView;
    
    UIButton *leftDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftDateBtn setBackgroundColor:[UIColor redColor]];
    [leftDateBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.s_BackdropView addSubview:leftDateBtn];
    self.s_LeftDateBtn = leftDateBtn;
    
    UIButton *rightDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDateBtn setBackgroundColor:[UIColor redColor]];
    [rightDateBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.s_BackdropView addSubview:rightDateBtn];
    self.s_RightDateBtn = rightDateBtn;
    
    BBHomeGrowthDateDayView *dayView = [[BBHomeGrowthDateDayView alloc] init];
    [self.s_BackdropView addSubview:dayView];
    self.s_DayView = dayView;
    
    BBHomeGrowthDateBabyMessageView *messageView = [[BBHomeGrowthDateBabyMessageView alloc] init];
    messageView.m_Delegate = self;
    [self.s_BackdropView addSubview:messageView];
    self.s_MessageView = messageView;
    
}
- (void)setupConstraints{
    [self.s_BackdropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.s_LeftDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BackdropView).offset(41);
        make.top.equalTo(self.s_BackdropView).offset(132);
        make.width.equalTo(@(10));
        make.height.equalTo(@(16));
    }];
    [self.s_RightDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.s_BackdropView).offset(-41);
        make.top.equalTo(self.s_BackdropView).offset(132);
        make.width.equalTo(@(10));
        make.height.equalTo(@(16));
    }];
    [self.s_DayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.s_BackdropView);
        make.top.equalTo(self.s_BackdropView).offset(82);
    }];
    [self.s_MessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.s_BackdropView);
    }];
}

- (CGSize)intrinsicContentSize{
    CGFloat height = 0;
    height += 222;
    height += [self.s_MessageView intrinsicContentSize].height;
    height = ceilf(height);
    return CGSizeMake(-1, height);
}

#pragma mark - 数据源
- (NSInteger)itemCount{
    NSInteger count = 0;
    if ([self.m_DataSource respondsToSelector:@selector(numberOfItemsInHomeGrowthDateCell:)]) {
        count = [self.m_DataSource numberOfItemsInHomeGrowthDateCell:self];
    }
    return count;
}
- (BBHomeGrowthDateCellModel *)previousModel{
    NSInteger previousIndex = self.s_CurrentIndex-1;
    
    return [self modelWithIndex:previousIndex];
}
- (BBHomeGrowthDateCellModel *)nextModel{
    NSInteger nextIndex = self.s_CurrentIndex+1;
    
    return [self modelWithIndex:nextIndex];
}
- (BBHomeGrowthDateCellModel *)modelWithIndex:(NSInteger)index{
    NSInteger count = [self itemCount];
    if (index>=count || index<0) {return nil;}
    
    BBHomeGrowthDateCellModel *model = [self.m_DataSource homeGrowthDateCell:self itemModelOfIndex:index];
    return model;
}

#pragma mark - 刷新视图
- (void)resetViewWithItemIndex:(NSInteger)index{
    if (self.s_IsAnimation) {return;}
    BBHomeGrowthDateCellModel *model = [self modelWithIndex:index];
    if (!model) {return;}
    
    self.s_CurrentIndex = index;
    [self resetViewWithModel:model];
}
- (void)resetViewWithModel:(BBHomeGrowthDateCellModel *)model{
    if (self.s_IsAnimation) {return;}
    self.m_CurrentModel = model;
    
    [self.s_DayView resetWithDateComponents:model.m_DateComponents];
    [self.s_MessageView resetWithModel:model];
    
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateCell:didEndScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeGrowthDateCell:self didEndScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
}
// 上一日知识，手势：右滑   文本：右滑   日期：上滑
- (void)scrollViewWithPreviousDayModel:(BBHomeGrowthDateCellModel *)model{
    if (self.s_IsAnimation) {return;}
    self.m_CurrentModel = model;
    
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateCell:willScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeGrowthDateCell:self willScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
    self.s_IsAnimation = YES;
    [self.s_DayView upSlideWithDateComponents:model.m_DateComponents];
    [self.s_MessageView rightSlideWithModel:model];
}

// 下一日知识，手势：左滑   文本：左滑   日期：下滑
- (void)scrollViewWithNextDayModel:(BBHomeGrowthDateCellModel *)model{
    if (self.s_IsAnimation) {return;}
    self.m_CurrentModel = model;
    
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateCell:willScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeGrowthDateCell:self willScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
    self.s_IsAnimation = YES;
    [self.s_DayView downSlideWithDateComponents:model.m_DateComponents];
    [self.s_MessageView leftSlideWithModel:model];
}
#pragma mark - 滑动手势
- (void)swipeLeft:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    [self rightBtnDidClick:nil];
}
- (void)swipeRight:(UISwipeGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateEnded) {return;}
    [self leftBtnDidClick:nil];
}
#pragma mark - 点击
- (void)leftBtnDidClick:(UIButton *)sender{
    if (self.s_IsAnimation) {return;}
    BBHomeGrowthDateCellModel *previousModel = [self previousModel];
    if (!previousModel) {return;}
    
    self.s_CurrentIndex -= 1;
    [self scrollViewWithPreviousDayModel:previousModel];
}
- (void)rightBtnDidClick:(UIButton *)sender{
    if (self.s_IsAnimation) {return;}
    BBHomeGrowthDateCellModel *nextModel = [self nextModel];
    if (!nextModel) {return;}
    
    self.s_CurrentIndex += 1;
    [self scrollViewWithNextDayModel:nextModel];
}
#pragma mark - message 代理
- (void)homeGrowthDateBabyMessageViewDidClickRecodeBtn:(BBHomeGrowthDateBabyMessageView *)view{
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateCellDidClickRecodeBtn:)]) {
        [self.m_Delegate homeGrowthDateCellDidClickRecodeBtn:self];
    }
}
- (void)homeGrowthDateBabyMessageViewDidEndScrollAnimation:(BBHomeGrowthDateBabyMessageView *)view{
    self.s_IsAnimation = NO;
    
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateCell:didEndScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeGrowthDateCell:self didEndScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
}
@end
