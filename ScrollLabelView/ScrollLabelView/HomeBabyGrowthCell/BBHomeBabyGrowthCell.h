//
//  BBHomeBabyGrowthCell.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHomeBabyGrowthCellModel.h"

@class BBHomeBabyGrowthCell;
@protocol BBHomeBabyGrowthCellDelegate <NSObject>
@optional
- (void)homeBabyGrowthCellDidClickTodayView:(BBHomeBabyGrowthCell *)cell;
- (void)homeBabyGrowthCellDidClickRecodeBtn:(BBHomeBabyGrowthCell *)cell;
// 得到回调后需要更新cell高度
- (void)homeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell willScrollToItemIndex:(NSInteger)index itemModel:(BBHomeBabyGrowthCellModel *)model;

@end
@protocol BBHomeBabyGrowthCellDataSource <NSObject>

- (NSInteger)numberOfItemsInHomeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell;
- (BBHomeBabyGrowthCellModel *)homeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell itemModelOfIndex:(NSInteger)index;

@end

@interface BBHomeBabyGrowthCell : UITableViewCell

@property (nonatomic, assign) CGFloat m_ScrollOffsetY;

@property (nonatomic, weak) id<BBHomeBabyGrowthCellDelegate> m_Delegate;
@property (nonatomic, weak) id<BBHomeBabyGrowthCellDataSource> m_DataSource;

@property (nonatomic, strong, readonly) BBHomeBabyGrowthCellModel *m_CurrentModel;

- (void)resetViewWithItemIndex:(NSInteger)index;
- (void)resetViewWithModel:(BBHomeBabyGrowthCellModel *)model;

@end
