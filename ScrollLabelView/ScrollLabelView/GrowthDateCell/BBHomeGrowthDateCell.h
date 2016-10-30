//
//  BBHomeGrowthDateCell.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHomeGrowthDateCellModel.h"

@class BBHomeGrowthDateCell;
@protocol BBHomeGrowthDateCellDelegate <NSObject>

@optional
- (void)homeGrowthDateCellDidClickRecodeBtn:(BBHomeGrowthDateCell *)cell;
- (void)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell willScrollToItemIndex:(NSInteger)index itemModel:(BBHomeGrowthDateCellModel *)model;
- (void)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell didEndScrollToItemIndex:(NSInteger)index itemModel:(BBHomeGrowthDateCellModel *)model;

@end
@protocol BBHomeGrowthDateCellDataSource <NSObject>

- (NSInteger)numberOfItemsInHomeGrowthDateCell:(BBHomeGrowthDateCell *)cell;
- (BBHomeGrowthDateCellModel *)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell itemModelOfIndex:(NSInteger)index;

@end

@interface BBHomeGrowthDateCell : UITableViewCell

@property (nonatomic, weak) id<BBHomeGrowthDateCellDelegate> m_Delegate;
@property (nonatomic, weak) id<BBHomeGrowthDateCellDataSource> m_DataSource;

@property (nonatomic, strong, readonly) BBHomeGrowthDateCellModel *m_CurrentModel;

- (void)resetViewWithItemIndex:(NSInteger)index;
- (void)resetViewWithModel:(BBHomeGrowthDateCellModel *)model;

@end
