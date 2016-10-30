//
//  BBHomeBabyGrowthVoteView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRemindCellVoteViewModel.h"

@class BBHomeBabyGrowthVoteView;
@protocol BBHomeBabyGrowthVoteViewDelegate <NSObject>
- (void)homeBabyGrowthVoteViewDidClickOptionOneBtn:(BBHomeBabyGrowthVoteView *)view;
- (void)homeBabyGrowthVoteViewDidClickOptionTwoBtn:(BBHomeBabyGrowthVoteView *)view;
@end

@interface BBHomeBabyGrowthVoteView : UIView

@property (nonatomic, weak) id<BBHomeBabyGrowthVoteViewDelegate> m_Delegate;

@property (nonatomic, strong) BBRemindCellVoteViewModel *m_ViewModel;

@end
