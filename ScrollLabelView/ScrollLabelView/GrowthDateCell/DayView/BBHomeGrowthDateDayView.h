//
//  BBHomeGrowthDateDayView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBHomeGrowthDateDayView : UIView


- (void)resetWithDateComponents:(NSDateComponents *)dateComponents;
// 日期上滑，02->03
- (void)upSlideWithDateComponents:(NSDateComponents *)dateComponents;
// 日期下滑，03->02
- (void)downSlideWithDateComponents:(NSDateComponents *)dateComponents;

@end
