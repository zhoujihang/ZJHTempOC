//
//  BBHomeBabyGrowthCell.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthCell.h"
#import "BBHomeBabyGrowthHeaderView.h"
#import "BBHomeBabyGrowthDayView.h"
#import "BBHorizontalScrollLabelView.h"
#import "BBHomeBabyGrowthVoteView.h"
#import "BBHomeBabyGrowthRecodeView.h"
#import "Masonry.h"

@interface BBHomeBabyGrowthCell () <BBHomeBabyGrowthDayViewDataSource,BBHorizontalScrollLabelViewDelegate, BBHomeBabyGrowthDayViewDelegate, BBHomeBabyGrowthVoteViewDelegate>

@property (nonatomic, weak) BBHomeBabyGrowthHeaderView *s_HeaderView;
@property (nonatomic, weak) BBHomeBabyGrowthDayView *s_DayView;
@property (nonatomic, weak) BBHorizontalScrollLabelView *s_KnowledgeView;
@property (nonatomic, weak) BBHomeBabyGrowthVoteView *s_VoteView;
@property (nonatomic, weak) BBHomeBabyGrowthRecodeView *s_RecodeView;

@property (nonatomic, assign) NSInteger s_CurrentIndex;
@property (nonatomic, strong, readwrite) BBHomeBabyGrowthCellModel *m_CurrentModel;
// 以知识文本动画结束回调为标记
@property (nonatomic, assign) BOOL s_IsAnimation;

@end

@implementation BBHomeBabyGrowthCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.s_IsAnimation = NO;
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)setupViews{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doLeftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doRightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:leftSwipe];
    [self.contentView addGestureRecognizer:rightSwipe];
    
    BBHomeBabyGrowthHeaderView *headerView = [[BBHomeBabyGrowthHeaderView alloc] init];
    [self.contentView addSubview:headerView];
    self.s_HeaderView = headerView;
    
    BBHomeBabyGrowthDayView *dayView = [[BBHomeBabyGrowthDayView alloc] init];
    dayView.m_DataSource = self;
    dayView.m_Delegate = self;
    [self.contentView addSubview:dayView];
    self.s_DayView = dayView;
    
    BBHorizontalScrollLabelView *knowledgeView = [[BBHorizontalScrollLabelView alloc] init];
    knowledgeView.m_Font = [UIFont systemFontOfSize:15];
    knowledgeView.m_Color = RGBColor(101, 101, 101, 1);
    knowledgeView.m_Delegate = self;
    [self.contentView addSubview:knowledgeView];
    self.s_KnowledgeView = knowledgeView;
    
    BBHomeBabyGrowthVoteView *voteView = [[BBHomeBabyGrowthVoteView alloc] init];
    [self.contentView addSubview:voteView];
    self.s_VoteView = voteView;
    
    BBHomeBabyGrowthRecodeView *recodeView = [[BBHomeBabyGrowthRecodeView alloc] init];
    [self.contentView addSubview:recodeView];
    self.s_RecodeView = recodeView;
}
- (void)setupConstraints{
    [self.s_HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    [self.s_DayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.s_HeaderView.mas_bottom).offset(14);
    }];
    [self.s_KnowledgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.s_DayView.mas_bottom).offset(8);
    }];
    self.s_KnowledgeView.m_PreferedMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-15-15;
    [self.s_RecodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.s_KnowledgeView.mas_bottom).offset(15);
    }];
    [self.s_VoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.s_KnowledgeView.mas_bottom).offset(15);
    }];
}
- (void)setupData{
    self.s_RecodeView.hidden = NO;
    self.s_VoteView.hidden = NO;
    
}
- (CGSize)intrinsicContentSize{
    CGFloat height = 0;
    
    CGFloat bottomHeight = 0;
    CGFloat voteViewHeight = [self.s_VoteView intrinsicContentSize].height;
    CGFloat recodeViewHeight = [self.s_RecodeView intrinsicContentSize].height;
    BBRemindCellVoteViewModel *voteModel = self.m_CurrentModel.m_VoteViewModel;
    if (voteModel && voteModel.m_ViewState!=BBRemindCellVoteViewStateHidden) {
        bottomHeight = voteViewHeight;
    }else{
        bottomHeight = recodeViewHeight;
    }
    
    height += [self.s_HeaderView intrinsicContentSize].height;
    height += 14;
    height += [self.s_DayView intrinsicContentSize].height;
    height += 8;
    height += [self.s_KnowledgeView intrinsicContentSize].height;
    height += 15;
    height += bottomHeight;
    height += 16;
    
    height = ceilf(height);
    return CGSizeMake(-1, height);
}

- (void)setM_ScrollOffsetY:(CGFloat)m_ScrollOffsetY{
    _m_ScrollOffsetY = m_ScrollOffsetY;
    
    self.s_HeaderView.m_ScrollOffsetY = m_ScrollOffsetY;
}

#pragma mark - 数据源
- (NSInteger)itemCount{
    NSInteger count = 0;
    if ([self.m_DataSource respondsToSelector:@selector(numberOfItemsInHomeBabyGrowthCell:)]) {
        count = [self.m_DataSource numberOfItemsInHomeBabyGrowthCell:self];
    }
    return count;
}
- (BBHomeBabyGrowthCellModel *)previousModel{
    NSInteger previousIndex = self.s_CurrentIndex-1;
    
    return [self modelWithIndex:previousIndex];
}
- (BBHomeBabyGrowthCellModel *)nextModel{
    NSInteger nextIndex = self.s_CurrentIndex+1;
    
    return [self modelWithIndex:nextIndex];
}
- (BBHomeBabyGrowthCellModel *)modelWithIndex:(NSInteger)index{
    NSInteger count = [self itemCount];
    if (index>=count || index<0) {return nil;}
    
    BBHomeBabyGrowthCellModel *model = nil;
    if ([self.m_DataSource respondsToSelector:@selector(homeBabyGrowthCell:itemModelOfIndex:)]) {
        model = [self.m_DataSource homeBabyGrowthCell:self itemModelOfIndex:index];
    }
    return model;
}

#pragma mark - 立即刷新视图
- (void)resetViewWithItemIndex:(NSInteger)index{
    if (self.s_IsAnimation) {return;}
    BBHomeBabyGrowthCellModel *model = [self modelWithIndex:index];
    if (!model) {return;}
    
    self.s_CurrentIndex = index;
    [self resetViewWithModel:model];
}
- (void)resetViewWithModel:(BBHomeBabyGrowthCellModel *)model{
    if (self.s_IsAnimation) {return;}
    self.m_CurrentModel = model;
    
    self.s_HeaderView.m_Model = model;
    [self.s_DayView resetViewWithItemIndex:self.s_CurrentIndex];
    [self.s_KnowledgeView resetWithCenterString:model.m_KnowledgeContent];
    self.s_RecodeView.m_Model = model;
    self.s_VoteView.m_ViewModel = model.m_VoteViewModel;
    self.s_RecodeView.hidden = !self.s_VoteView.hidden;
    [self invalidateIntrinsicContentSize];
    self.m_CurrentModel.m_ViewHeight = [self intrinsicContentSize].height;
}
#pragma mark - 手势滚动视图
// 出现左边数据
- (void)doRightSwipe:(UISwipeGestureRecognizer *)swipe{
    BBHomeBabyGrowthCellModel *previousModel = [self previousModel];
    if (!previousModel) {return;}
    if (self.s_IsAnimation) {return;}
    
    self.s_IsAnimation = YES;
    self.m_CurrentModel = previousModel;
    self.s_CurrentIndex--;
    self.s_HeaderView.m_Model = previousModel;
    [self.s_DayView scrollToPreviousDate];
    self.s_RecodeView.m_Model = previousModel;
    self.s_VoteView.m_ViewModel = previousModel.m_VoteViewModel;
    self.s_RecodeView.hidden = !self.s_VoteView.hidden;
    [self.s_KnowledgeView rightSlideWithCenterString:previousModel.m_KnowledgeContent];
}
// 出现右边数据
- (void)doLeftSwipe:(UISwipeGestureRecognizer *)swipe{
    BBHomeBabyGrowthCellModel *nextModel = [self nextModel];
    if (!nextModel) {return;}
    if (self.s_IsAnimation) {return;}
    
    self.s_IsAnimation = YES;
    self.m_CurrentModel = nextModel;
    self.s_CurrentIndex++;
    self.s_HeaderView.m_Model = nextModel;
    [self.s_DayView scrollToNextDate];
    self.s_RecodeView.m_Model = nextModel;
    self.s_VoteView.m_ViewModel = nextModel.m_VoteViewModel;
    self.s_RecodeView.hidden = !self.s_VoteView.hidden;
    [self.s_KnowledgeView leftSlideWithCenterString:nextModel.m_KnowledgeContent];
}

#pragma mark - BBHomeBabyGrowthDayViewDataSource 日期数据源
- (NSInteger)numberOfDateComponentsInHomeBabyGrowthDayView:(BBHomeBabyGrowthDayView *)view{
    NSInteger number = [self itemCount];
    return number;
}
- (NSDateComponents *)homeBabyGrowthDayView:(BBHomeBabyGrowthDayView *)view dateComponentsOfIndex:(NSInteger)index{
    BBHomeBabyGrowthCellModel *model = [self modelWithIndex:index];
    NSDateComponents *dateComponents = model.m_DateComponents;
    return dateComponents;
}
#pragma mark BBHomeBabyGrowthDayViewDelegate 日期滚动
- (void)homeBabyGrowthDayViewDidClickLeftDay:(BBHomeBabyGrowthDayView *)view{
    [self doRightSwipe:nil];
}
- (void)homeBabyGrowthDayViewDidClickRightDay:(BBHomeBabyGrowthDayView *)view{
    [self doLeftSwipe:nil];
}
// 点击今日
- (void)homeBabyGrowthDayViewDidClickTodayView:(BBHomeBabyGrowthDayView *)view{
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthCellDidClickTodayView:)]) {
        [self.m_Delegate homeBabyGrowthCellDidClickTodayView:self];
    }
    [self invalidateIntrinsicContentSize];
    self.m_CurrentModel.m_ViewHeight = [self intrinsicContentSize].height;
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthCell:willScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeBabyGrowthCell:self willScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
}
#pragma mark - BBHorizontalScrollLabelViewDelegate 知识内容滚动
- (void)horizontalScrollLabelView:(BBHorizontalScrollLabelView *)view willScrollToText:(NSString *)text viewNewHeight:(CGFloat)height{
    [self invalidateIntrinsicContentSize];
    self.m_CurrentModel.m_ViewHeight = [self intrinsicContentSize].height;
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthCell:willScrollToItemIndex:itemModel:)]) {
        [self.m_Delegate homeBabyGrowthCell:self willScrollToItemIndex:self.s_CurrentIndex itemModel:self.m_CurrentModel];
    }
}
- (void)horizontalScrollLabelView:(BBHorizontalScrollLabelView *)view didScrollToText:(NSString *)text viewNewHeight:(CGFloat)height{
    self.s_IsAnimation = NO;
}
#pragma mark -  投票视图
- (void)homeBabyGrowthVoteViewDidClickOptionOneBtn:(BBHomeBabyGrowthVoteView *)view{
    
}
- (void)homeBabyGrowthVoteViewDidClickOptionTwoBtn:(BBHomeBabyGrowthVoteView *)view{
    
}

@end
