//
//  BBHomeBabyGrowthDayCenterView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBHomeBabyGrowthDayCenterView : UIView

- (void)resetCenterDateComponents:(NSDateComponents *)dateComponents;
- (void)scrollToLeftDateComponents:(NSDateComponents *)dateComponents;
- (void)scrollToRightDateComponents:(NSDateComponents *)dateComponents;


+ (CGFloat)dateLabelWidth;
+ (NSString *)dateStringFromDateComponents:(NSDateComponents *)dateComponents;

@end
