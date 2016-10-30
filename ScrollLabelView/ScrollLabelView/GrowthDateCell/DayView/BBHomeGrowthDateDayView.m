//
//  BBHomeGrowthDateDayView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthDateDayView.h"
#import "BBHomeGrowthDateDayNumberView.h"
#import <Masonry/Masonry.h>

@interface BBHomeGrowthDateDayView ()

@property (nonatomic, weak) UIImageView *s_BigCircleImgView;
@property (nonatomic, weak) UIImageView *s_SmallCircleImgView;
@property (nonatomic, weak) BBHomeGrowthDateDayNumberView *s_LeftDayNumberView;
@property (nonatomic, weak) BBHomeGrowthDateDayNumberView *s_RightDayNumberView;
@property (nonatomic, weak) UILabel *s_BottomMonthLabel;

@property (nonatomic, assign) CGFloat s_Diameter;
@property (nonatomic, assign) CGFloat s_BigCircleDiameter;
@property (nonatomic, assign) CGFloat s_SmallCircleDiameter;
@property (nonatomic, assign) CGFloat s_ShadowCircleWidth;
@property (nonatomic, copy) NSDateComponents *s_DateComponents;
@end

@implementation BBHomeGrowthDateDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.s_Diameter = 116;
    self.s_BigCircleDiameter = self.s_Diameter-4;
    self.s_SmallCircleDiameter = self.s_BigCircleDiameter-8;
    self.s_ShadowCircleWidth = 2;
    
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)setupViews{
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bigCircleImgView = [[UIImageView alloc] init];
    bigCircleImgView.image = [self bigCircleImage];
    bigCircleImgView.layer.shadowColor = RGBColor(0, 0, 0, 1).CGColor;
    bigCircleImgView.layer.shadowOpacity = 0.2;
    bigCircleImgView.layer.shadowOffset = CGSizeZero;
    bigCircleImgView.layer.shadowRadius = 2;
    CGRect shadowPathRect = CGRectMake(0, 0, self.s_BigCircleDiameter, self.s_BigCircleDiameter);
    bigCircleImgView.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:shadowPathRect].CGPath;
    [self addSubview:bigCircleImgView];
    self.s_BigCircleImgView = bigCircleImgView;
    
    UIImageView *smallCircleImgView = [[UIImageView alloc] init];
    smallCircleImgView.image = [self smallCircleImage];
    [self addSubview:smallCircleImgView];
    self.s_SmallCircleImgView = smallCircleImgView;
    
    BBHomeGrowthDateDayNumberView *leftDayNumberView = [[BBHomeGrowthDateDayNumberView alloc] init];
    [self addSubview:leftDayNumberView];
    self.s_LeftDayNumberView = leftDayNumberView;
    
    BBHomeGrowthDateDayNumberView *rightDayNumberView = [[BBHomeGrowthDateDayNumberView alloc] init];
    [self addSubview:rightDayNumberView];
    self.s_RightDayNumberView = rightDayNumberView;
    
    UILabel *bottomMonthLabel = [[UILabel alloc] init];
    bottomMonthLabel.font = [UIFont boldSystemFontOfSize:14];
    bottomMonthLabel.textColor = [UIColor whiteColor];
    [self addSubview:bottomMonthLabel];
    self.s_BottomMonthLabel = bottomMonthLabel;
    
}
- (void)setupConstraints{
    [self.s_BigCircleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(self.s_BigCircleDiameter));
    }];
    [self.s_SmallCircleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(self.s_SmallCircleDiameter));
    }];
    [self.s_LeftDayNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-18);
        make.centerY.equalTo(self).offset(-12);
    }];
    [self.s_RightDayNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(18);
        make.centerY.equalTo(self).offset(-12);
    }];
    [self.s_BottomMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(28);
    }];
}
- (void)setupData{
    NSDateComponents *dateCpt = [[NSDateComponents alloc] init];
    dateCpt.year = 2016;
    dateCpt.month = 8;
    dateCpt.day = 3;
    [self resetWithDateComponents:dateCpt];
}

- (CGSize)sizeThatFits:(CGSize)size{
    return [self intrinsicContentSize];
}
- (CGSize)intrinsicContentSize{
    return CGSizeMake(self.s_Diameter, self.s_Diameter);
}


- (void)resetWithDateComponents:(NSDateComponents *)dateComponents{
    self.s_DateComponents = dateComponents;
    
    NSInteger dayLeftInt = dateComponents.day/10;
    NSInteger dayRightInt = dateComponents.day%10;
    
    NSString *monthYearString = [NSString stringWithFormat:@"%02ld.%ld",dateComponents.month, dateComponents.year];
    
    [self.s_LeftDayNumberView resetWithNumber:dayLeftInt];
    [self.s_RightDayNumberView resetWithNumber:dayRightInt];
    self.s_BottomMonthLabel.text = monthYearString;
}
- (void)upSlideWithDateComponents:(NSDateComponents *)dateComponents{
    NSInteger dayLeftInt1 = self.s_DateComponents.day/10;
    
    NSInteger dayLeftInt2 = dateComponents.day/10;
    NSInteger dayRightInt2 = dateComponents.day%10;
    NSString *monthYearString2 = [NSString stringWithFormat:@"%02ld.%ld",dateComponents.month, dateComponents.year];
    
    [self.s_RightDayNumberView upSlideWithNumber:dayRightInt2];
    if (dayLeftInt1 != dayLeftInt2) {
        [self.s_LeftDayNumberView upSlideWithNumber:dayLeftInt2];
    }
    self.s_BottomMonthLabel.text = monthYearString2;
    self.s_DateComponents = dateComponents;
}
- (void)downSlideWithDateComponents:(NSDateComponents *)dateComponents{
    NSInteger dayLeftInt1 = self.s_DateComponents.day/10;
    
    NSInteger dayLeftInt2 = dateComponents.day/10;
    NSInteger dayRightInt2 = dateComponents.day%10;
    NSString *monthYearString2 = [NSString stringWithFormat:@"%02ld.%ld",dateComponents.month, dateComponents.year];
    
    [self.s_RightDayNumberView downSlideWithNumber:dayRightInt2];
    if (dayLeftInt1 != dayLeftInt2) {
        [self.s_LeftDayNumberView downSlideWithNumber:dayLeftInt2];
    }
    self.s_BottomMonthLabel.text = monthYearString2;
    self.s_DateComponents = dateComponents;
}

- (UIImage *)bigCircleImage{
    UIImage *bigCircleImg = [self solidCircleImageWithDiameter:self.s_BigCircleDiameter color:RGBColor(223, 255, 239, 1)];
    return bigCircleImg;
}
- (UIImage *)smallCircleImage{
    UIImage *smallCircleImg = [self solidCircleImageWithDiameter:self.s_SmallCircleDiameter color:RGBColor(159, 215, 187, 1)];
    return smallCircleImg;
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
