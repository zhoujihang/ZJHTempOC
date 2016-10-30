//
//  BBHomeBabyGrowthDayView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBHomeBabyGrowthDayView;
@protocol BBHomeBabyGrowthDayViewDataSource <NSObject>
- (NSInteger)numberOfDateComponentsInHomeBabyGrowthDayView:(BBHomeBabyGrowthDayView *)view;
- (NSDateComponents *)homeBabyGrowthDayView:(BBHomeBabyGrowthDayView *)view dateComponentsOfIndex:(NSInteger)index;
@end
@protocol BBHomeBabyGrowthDayViewDelegate <NSObject>

- (void)homeBabyGrowthDayViewDidClickLeftDay:(BBHomeBabyGrowthDayView *)view;
- (void)homeBabyGrowthDayViewDidClickRightDay:(BBHomeBabyGrowthDayView *)view;
- (void)homeBabyGrowthDayViewDidClickTodayView:(BBHomeBabyGrowthDayView *)view;

@end


@interface BBHomeBabyGrowthDayView : UIView

@property (nonatomic, weak) id<BBHomeBabyGrowthDayViewDelegate> m_Delegate;
@property (nonatomic, weak) id<BBHomeBabyGrowthDayViewDataSource> m_DataSource;

- (void)resetViewWithItemIndex:(NSInteger)index;
- (void)scrollToPreviousDate;
- (void)scrollToNextDate;

@end





