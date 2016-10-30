//
//  BBHomeBabyGrowthHeaderView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthHeaderView.h"
#import "BBHomeBabyGrowthHeaderAvatarView.h"

@interface BBHomeBabyGrowthHeaderView ()

@property (nonatomic, weak) CALayer *s_AnimateLayer;
@property (nonatomic, weak) CALayer *s_TriangleLayer;

@property (nonatomic, weak) BBHomeBabyGrowthHeaderAvatarView *s_AvatarView;
@property (nonatomic, weak) UILabel *s_NameLabel;
@property (nonatomic, weak) UILabel *s_AgeLabel;

@end


@implementation BBHomeBabyGrowthHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupPosition];
}
- (void)setupViews{
//    self.backgroundColor = RGBColor(131, 220, 222, 1);
    self.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doLeftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doRightSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:leftSwipe];
    [self addGestureRecognizer:rightSwipe];
    
    CALayer *animateLayer = [[CALayer alloc] init];
    animateLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:animateLayer];
    self.s_AnimateLayer = animateLayer;
    
    CALayer *triangleLayer = [[CALayer alloc] init];
    triangleLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:triangleLayer];
    self.s_TriangleLayer = triangleLayer;
    
    BBHomeBabyGrowthHeaderAvatarView *avatarView = [[BBHomeBabyGrowthHeaderAvatarView alloc] init];
    [self addSubview:avatarView];
    self.s_AvatarView = avatarView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    self.s_NameLabel = nameLabel;
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.textAlignment = NSTextAlignmentCenter;
    ageLabel.font = [UIFont systemFontOfSize:14];
    ageLabel.textColor = [UIColor whiteColor];
    [self addSubview:ageLabel];
    self.s_AgeLabel = ageLabel;
}
- (void)setupPosition{
    CGSize contentSize = [self intrinsicContentSize];
    
    // layer
    CGFloat triangleLayerWidth = 16;
    CGFloat triangleLayerHeight = 10;
    CGFloat triangleLayerX = ceilf((contentSize.width-triangleLayerWidth)*0.5);
    CGFloat triangleLayerY = ceilf(contentSize.height-triangleLayerHeight+4);
    CGFloat animateLayerHeight = 30;
    CGFloat animateLayerY = contentSize.height-animateLayerHeight;
    self.s_AnimateLayer.frame = CGRectMake(0, animateLayerY, contentSize.width, animateLayerHeight);
    self.s_TriangleLayer.frame = CGRectMake(triangleLayerX, triangleLayerY, triangleLayerWidth, triangleLayerHeight);
    [self updateMaskLayerWithControlPointOffsetY:50];
    
    // 视图
    CGSize avatarContentSize = [self.s_AvatarView intrinsicContentSize];
    CGFloat avatarViewX = ceilf((contentSize.width-avatarContentSize.width)*0.5);
    CGFloat avatarViewY = 74;
    CGFloat nameLabelHeight = self.s_NameLabel.font.lineHeight;
    CGFloat nameLabelY = ceilf(avatarViewY+avatarContentSize.height+4);
    CGFloat ageLabelY = ceilf(nameLabelY+nameLabelHeight+5);
    self.s_AvatarView.frame = CGRectMake(avatarViewX, avatarViewY, avatarContentSize.width, avatarContentSize.height);
    self.s_NameLabel.frame = CGRectMake(0, nameLabelY, contentSize.width, nameLabelHeight);
    self.s_AgeLabel.frame = CGRectMake(0, ageLabelY, contentSize.width, nameLabelHeight);
}
// controlOffsetY 曲线曲度，0 无曲线 50曲度最大
- (void)updateMaskLayerWithControlPointOffsetY:(CGFloat)controlOffsetY{
    controlOffsetY = controlOffsetY>=0 ? controlOffsetY : 0;
    controlOffsetY = controlOffsetY<=50 ? controlOffsetY : 50;
    CGFloat curvePositionDelt = (50-controlOffsetY)/50.0 * (30-6);
    CGSize contentSize = [self intrinsicContentSize];
    
    // 图片大小
    CGFloat animateImgWidth = contentSize.width;
    CGFloat animateImgHeight = 30;
    CGSize animateImgSize = CGSizeMake(contentSize.width, animateImgHeight);
    
    // 控制点
    CGFloat imgCenterX = ceilf(animateImgWidth*0.5);
    CGFloat grayTopPadding = 4;
    CGPoint leftTopPoint = CGPointMake(0, 0);
    CGPoint rightTopPoint = CGPointMake(animateImgWidth, 0);
    // 灰色控制点
    CGPoint grayCurvePoint1 = CGPointMake(0, curvePositionDelt+grayTopPadding);
    CGPoint grayCurvePoint2 = CGPointMake(animateImgWidth, curvePositionDelt+grayTopPadding);
    CGPoint grayControlPoint = CGPointMake(imgCenterX, controlOffsetY+grayTopPadding);
    // 青色控制点
    CGPoint cyanCurvePoint1 = CGPointMake(0, curvePositionDelt);
    CGPoint cyanCurvePoint2 = CGPointMake(animateImgWidth, curvePositionDelt);
    CGPoint cyanControlPoint = CGPointMake(imgCenterX, controlOffsetY);
    
    // 绘图开始
    UIImage *animateImg = nil;
    UIGraphicsBeginImageContextWithOptions(animateImgSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 白色
//    [[UIColor blueColor] set];
//    CGContextFillRect(ctx, CGRectMake(0, 0, animateImgWidth, animateImgHeight));
//
//    // 灰色
//    [RGBColor(222, 242, 246, 1) set];
//    UIBezierPath *grayPath = [UIBezierPath bezierPath];
//    [grayPath moveToPoint:grayCurvePoint2];
//    [grayPath addLineToPoint:rightTopPoint];
//    [grayPath addLineToPoint:leftTopPoint];
//    [grayPath addLineToPoint:grayCurvePoint1];
//    [grayPath addQuadCurveToPoint:grayCurvePoint2 controlPoint:grayControlPoint];
//    CGContextAddPath(ctx, grayPath.CGPath);
//    CGContextFillPath(ctx);
    // 青色
//    [RGBColor(131, 220, 222, 1) set];
//    UIBezierPath *cyanPath = [UIBezierPath bezierPath];
//    [cyanPath moveToPoint:cyanCurvePoint2];
//    [cyanPath addLineToPoint:rightTopPoint];
//    [cyanPath addLineToPoint:leftTopPoint];
//    [cyanPath addLineToPoint:cyanCurvePoint1];
//    [cyanPath addQuadCurveToPoint:cyanCurvePoint2 controlPoint:cyanControlPoint];
//    CGContextAddPath(ctx, cyanPath.CGPath);
//    CGContextFillPath(ctx);
    
    animateImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.s_AnimateLayer.contents = animateImg;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 190);
}

- (void)setM_ScrollOffsetY:(CGFloat)m_ScrollOffsetY{
    _m_ScrollOffsetY = m_ScrollOffsetY;
    CGSize contentSize = [self intrinsicContentSize];
    
    CGFloat minScrollOffsetY = 0;
    CGFloat maxScrollOffsetY = contentSize.height-20;
    maxScrollOffsetY = 119;
    
    m_ScrollOffsetY = m_ScrollOffsetY>minScrollOffsetY ? m_ScrollOffsetY : minScrollOffsetY;
    m_ScrollOffsetY = m_ScrollOffsetY<maxScrollOffsetY ? m_ScrollOffsetY : maxScrollOffsetY;
    
    CGFloat scrollOffsetLengthMax = maxScrollOffsetY-minScrollOffsetY;
    CGFloat scrollOffsetLengthCurrent = m_ScrollOffsetY-minScrollOffsetY;
    
    CGFloat controlPointOffsetDelt = scrollOffsetLengthCurrent/scrollOffsetLengthMax * 50;
    CGFloat offsetY = 50-controlPointOffsetDelt;
    [self updateMaskLayerWithControlPointOffsetY:offsetY];
    
}

- (void)setM_Model:(BBHomeBabyGrowthCellModel *)m_Model{
    _m_Model = m_Model;
    
    self.s_NameLabel.text = m_Model.m_Name;
    self.s_AgeLabel.text = m_Model.m_Age;
}


- (void)doLeftSwipe:(UISwipeGestureRecognizer *)swipe{
    NSLog(@"head left");
}
- (void)doRightSwipe:(UISwipeGestureRecognizer *)swipe{
    NSLog(@"head left");
}





@end
