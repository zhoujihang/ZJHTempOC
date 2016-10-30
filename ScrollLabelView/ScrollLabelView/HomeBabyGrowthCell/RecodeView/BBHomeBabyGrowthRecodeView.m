//
//  BBHomeBabyGrowthRecodeView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthRecodeView.h"
#import "Masonry.h"

@interface BBHomeBabyGrowthRecodeView ()

@property (nonatomic, weak) UIView *s_BackdropGrayView;
@property (nonatomic, weak) UIImageView *s_BabyWeightImgView;
@property (nonatomic, weak) UILabel *s_BabyWeightLabel;
@property (nonatomic, weak) UIImageView *s_BabyHeightImgView;
@property (nonatomic, weak) UILabel *s_BabyHeightLabel;
@property (nonatomic, weak) UIView *s_CenterLineView;

@property (nonatomic, weak) UIButton *s_RecodeBtn;
@end

@implementation BBHomeBabyGrowthRecodeView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)setupViews{
    UIView *backdropGrayView = [[UIView alloc] init];
    backdropGrayView.backgroundColor = RGBColor(246, 247, 249, 1);
    [self addSubview:backdropGrayView];
    self.s_BackdropGrayView = backdropGrayView;
    
    UIImageView *weightImgView = [[UIImageView alloc] init];
    [self.s_BackdropGrayView addSubview:weightImgView];
    self.s_BabyWeightImgView = weightImgView;
    
    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.textColor = RGBColor(109, 99, 101, 1);
    weightLabel.font = [UIFont systemFontOfSize:12];
    [self.s_BackdropGrayView addSubview:weightLabel];
    self.s_BabyWeightLabel = weightLabel;
    
    UIView *centerLineView = [[UIView alloc] init];
    centerLineView.backgroundColor = RGBColor(233, 235, 239, 1);
    [self.s_BackdropGrayView addSubview:centerLineView];
    self.s_CenterLineView = centerLineView;
    
    UIImageView *heightImgView = [[UIImageView alloc] init];
    [self.s_BackdropGrayView addSubview:heightImgView];
    self.s_BabyHeightImgView = heightImgView;
    
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.textColor = RGBColor(109, 99, 101, 1);
    heightLabel.font = [UIFont systemFontOfSize:12];
    [self.s_BackdropGrayView addSubview:heightLabel];
    self.s_BabyHeightLabel = heightLabel;
    
    UIButton *recodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recodeBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:recodeBtn];
    self.s_RecodeBtn = recodeBtn;
    
}
- (void)setupConstraints{
    [self.s_BackdropGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.s_RecodeBtn.mas_left).offset(-6);
    }];
    [self.s_RecodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(70));
        make.right.equalTo(self).offset(-16);
    }];
    
    // 身高、体重详情
    [self.s_BabyWeightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BackdropGrayView).offset(20);
        make.centerY.equalTo(self.s_BackdropGrayView);
        make.width.height.equalTo(@16);
    }];
    [self.s_BabyWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BabyWeightImgView.mas_right).offset(8);
        make.centerY.equalTo(self.s_BackdropGrayView);
        make.right.equalTo(self.s_CenterLineView).offset(-4);
    }];
    [self.s_CenterLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.s_BackdropGrayView);
        make.width.equalTo(@1);
        make.height.equalTo(@16);
    }];
    [self.s_BabyHeightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_CenterLineView).offset(13);
        make.centerY.equalTo(self.s_BackdropGrayView);
        make.width.height.equalTo(@16);
    }];
    [self.s_BabyHeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.s_BabyHeightImgView.mas_right).offset(8);
        make.right.equalTo(self.s_BackdropGrayView.mas_right).offset(-4);
        make.centerY.equalTo(self.s_BackdropGrayView);
    }];
}
- (void)setM_Model:(BBHomeBabyGrowthCellModel *)m_Model{
    _m_Model = m_Model;
    self.s_BabyWeightLabel.text = m_Model.m_BabyWeight;
    self.s_BabyHeightLabel.text = m_Model.m_BabyHeight;
}

- (void)setupData{
    self.s_BabyWeightImgView.image = [self solidCircleImageWithDiameter:16 color:[UIColor brownColor]];
    self.s_BabyHeightImgView.image = [self solidCircleImageWithDiameter:16 color:[UIColor brownColor]];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(-1, 34);
}

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
@end
