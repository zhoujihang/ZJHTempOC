//
//  BBHomeBabyGrowthHeaderAvatarView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/27.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthHeaderAvatarView.h"

@interface BBHomeBabyGrowthHeaderAvatarView ()

@property (nonatomic, weak) UIImageView *s_WhiteImgView;
@property (nonatomic, weak) UIImageView *s_AvatarImgView;

@end

@implementation BBHomeBabyGrowthHeaderAvatarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
}
- (void)setupViews{
    UIImageView *whiteImgView = [[UIImageView alloc] init];
    [self addSubview:whiteImgView];
    self.s_WhiteImgView = whiteImgView;
    
    UIImageView *avatarImgView = [[UIImageView alloc] init];
    [self addSubview:avatarImgView];
    self.s_AvatarImgView = avatarImgView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    self.s_WhiteImgView.hidden = width==0;
    self.s_AvatarImgView.hidden = width==0;
    if (width == 0) {return;}
    
    self.s_WhiteImgView.frame = self.bounds;
    self.s_AvatarImgView.bounds = CGRectMake(0, 0, width-4, width-4);
    self.s_AvatarImgView.center = self.s_WhiteImgView.center;
    
    self.s_WhiteImgView.image = [self solidCircleImageWithDiameter:width color:[UIColor whiteColor]];
    self.s_AvatarImgView.image = [self solidCircleImageWithDiameter:width-4 color:[UIColor redColor]];
}

- (CGSize)sizeThatFits:(CGSize)size{
    return [self intrinsicContentSize];
}
- (CGSize)intrinsicContentSize{
    return CGSizeMake(64, 64);
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
