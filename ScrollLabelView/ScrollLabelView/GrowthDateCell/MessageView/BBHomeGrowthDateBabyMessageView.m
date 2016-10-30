//
//  BBHomeGrowthDateBabyMessageView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthDateBabyMessageView.h"
#import "BBHorizontalScrollLabelView.h"
#import <Masonry/Masonry.h>
@interface BBHomeGrowthDateBabyMessageView ()<BBHorizontalScrollLabelViewDelegate>

@property (nonatomic, weak) UIImageView *s_AvatarBackdropImgView;
@property (nonatomic, weak) UIImageView *s_AvatarImgView;
@property (nonatomic, weak) UILabel *s_NameLabel;
@property (nonatomic, weak) UILabel *s_AgeLabel;
@property (nonatomic, weak) BBHorizontalScrollLabelView *s_KnowledgeView;
@property (nonatomic, weak) UILabel *s_WeightLabel;
@property (nonatomic, weak) UILabel *s_HeightLabel;
@property (nonatomic, weak) UIButton *s_RecodeBtn;
@end

@implementation BBHomeGrowthDateBabyMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)setupViews{
    
    // 宝宝信息
    UIImageView *avatarBackdropImgView = [[UIImageView alloc] init];
    avatarBackdropImgView.image = [self solidCircleImageWithDiameter:32 color:[UIColor whiteColor]];
    [self addSubview:avatarBackdropImgView];
    self.s_AvatarBackdropImgView = avatarBackdropImgView;
    
    UIImageView *avatarImgView = [[UIImageView alloc] init];
    [self addSubview:avatarImgView];
    self.s_AvatarImgView = avatarImgView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = RGBColor(43, 43, 43, 1);
    nameLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:nameLabel];
    self.s_NameLabel = nameLabel;
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textColor = RGBColor(90, 90, 90, 1);
    ageLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:ageLabel];
    self.s_AgeLabel = ageLabel;
    
    // 今日知识
    BBHorizontalScrollLabelView *knowledgeView = [[BBHorizontalScrollLabelView alloc] init];
    knowledgeView.m_Delegate = self;
    [self addSubview:knowledgeView];
    self.s_KnowledgeView = knowledgeView;
    
    // 今日体重、身高
    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.textColor = RGBColor(103, 103, 103, 1);
    weightLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:weightLabel];
    self.s_WeightLabel = weightLabel;
    
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.textColor = RGBColor(103, 103, 103, 1);
    heightLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:heightLabel];
    self.s_HeightLabel = heightLabel;
    
    // 记录
    UIButton *recodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recodeBtn addTarget:self action:@selector(recodeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [recodeBtn setBackgroundColor:[UIColor blueColor]];
    [self addSubview:recodeBtn];
    self.s_RecodeBtn = recodeBtn;
    
}
- (void)setupConstraints{
    // 宝宝信息
    [self.s_AvatarBackdropImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self);
        make.width.height.equalTo(@32);
    }];
    [self.s_AvatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.s_AvatarBackdropImgView);
        make.width.height.equalTo(@28);
    }];
    [self.s_NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_AvatarBackdropImgView.mas_right).offset(11);
        make.top.equalTo(self.s_AvatarBackdropImgView).offset(2);
    }];
    [self.s_AgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_NameLabel);
        make.bottom.equalTo(self.s_AvatarBackdropImgView);
    }];
    
    // 今日知识
    [self.s_KnowledgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.s_AvatarBackdropImgView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    self.s_KnowledgeView.m_PreferedMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
    // 体重、身高
    [self.s_WeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.s_KnowledgeView.mas_bottom).offset(16);
    }];
    [self.s_HeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_WeightLabel.mas_right).offset(20);
        make.top.equalTo(self.s_WeightLabel);
    }];
    
    // 记录
    [self.s_RecodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-22);
        make.bottom.equalTo(self.s_WeightLabel);
        make.width.equalTo(@(16));
        make.height.equalTo(@(15));
    }];
    
}
- (void)setupData{
    self.s_AvatarImgView.image = [self solidCircleImageWithDiameter:30 color:[UIColor redColor]];
}
- (CGSize)intrinsicContentSize{
    CGFloat height = 0;
    
    CGFloat knowledgeViewHeight = [self.s_KnowledgeView intrinsicContentSize].height;
    height += 32;
    height += 10;
    height += knowledgeViewHeight;
    height += 16;
    height += self.s_WeightLabel.font.lineHeight;
    height += 16;
    
    height = ceilf(height);
    return CGSizeMake(-1, height);
}

#pragma mark - 视图数据
- (void)resetWithModel:(BBHomeGrowthDateCellModel *)model{
    [self resetUnanimatedViewWithModel:model];
    [self.s_KnowledgeView resetWithCenterString:model.m_KnowledgeContent];
}
- (void)leftSlideWithModel:(BBHomeGrowthDateCellModel *)model{
    [self resetUnanimatedViewWithModel:model];
    [self.s_KnowledgeView leftSlideWithCenterString:model.m_KnowledgeContent];
}
- (void)rightSlideWithModel:(BBHomeGrowthDateCellModel *)model{
    [self resetUnanimatedViewWithModel:model];
    [self.s_KnowledgeView rightSlideWithCenterString:model.m_KnowledgeContent];
}
- (void)resetUnanimatedViewWithModel:(BBHomeGrowthDateCellModel *)model{
    self.s_NameLabel.text = model.m_Name;
    self.s_AgeLabel.text = model.m_Age;
    self.s_WeightLabel.text = model.m_BabyWeight;
    self.s_HeightLabel.text = model.m_BabyHeight;
}

#pragma mark - 头像画圆
- (UIImage *)solidCircleImageWithDiameter:(CGFloat)diameter color:(UIColor *)color{
    if (!color) {return nil;}
    if (diameter<=0) {return nil;}
    
    UIImage *img;
    CGSize size = CGSizeMake(diameter, diameter);
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [color set];
    
    CGFloat radius = size.width * 0.5; // 圆半径
    CGFloat centerX = size.width * 0.5; // 圆心
    CGFloat centerY = size.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);   // 画实心圆
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - 事件
- (void)recodeBtnDidClick:(UIButton *)sender{
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateBabyMessageViewDidClickRecodeBtn:)]) {
        [self.m_Delegate homeGrowthDateBabyMessageViewDidClickRecodeBtn:self];
    }
}
- (void)horizontalScrollLabelView:(BBHorizontalScrollLabelView *)view didScrollToText:(NSString *)text viewNewHeight:(CGFloat)height{
    if ([self.m_Delegate respondsToSelector:@selector(homeGrowthDateBabyMessageViewDidEndScrollAnimation:)]) {
        [self.m_Delegate homeGrowthDateBabyMessageViewDidEndScrollAnimation:self];
    }
}



@end
