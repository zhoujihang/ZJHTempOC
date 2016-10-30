//
//  BBHomeBabyGrowthHeaderView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHomeBabyGrowthCellModel.h"

@interface BBHomeBabyGrowthHeaderView : UIView

@property (nonatomic, assign) CGFloat m_ScrollOffsetY;
@property (nonatomic, strong) BBHomeBabyGrowthCellModel *m_Model;

@end
