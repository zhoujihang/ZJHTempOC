//
//  BBHomeGrowthDateBabyMessageView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHomeGrowthDateCellModel.h"
@class BBHomeGrowthDateBabyMessageView;
@protocol BBHomeGrowthDateBabyMessageViewDelegate <NSObject>

- (void)homeGrowthDateBabyMessageViewDidClickRecodeBtn:(BBHomeGrowthDateBabyMessageView *)view;
- (void)homeGrowthDateBabyMessageViewDidEndScrollAnimation:(BBHomeGrowthDateBabyMessageView *)view;
@end

@interface BBHomeGrowthDateBabyMessageView : UIView

@property (nonatomic, weak) id<BBHomeGrowthDateBabyMessageViewDelegate> m_Delegate;

- (void)resetWithModel:(BBHomeGrowthDateCellModel *)model;
- (void)leftSlideWithModel:(BBHomeGrowthDateCellModel *)model;
- (void)rightSlideWithModel:(BBHomeGrowthDateCellModel *)model;

@end
