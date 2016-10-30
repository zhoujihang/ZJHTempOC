//
//  BBHomeGrowthDateDayNumberView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBHomeGrowthDateDayNumberView : UIView



- (void)resetWithNumber:(NSInteger)number;
// 上滑 2->3
- (void)upSlideWithNumber:(NSInteger)number;
// 下滑 3->2
- (void)downSlideWithNumber:(NSInteger)number;


@end
