//
//  BBVerticalAlignmentLabel.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BBVerticalAlignmentType) {
    BBVerticalAlignmentTypeCenter,
    BBVerticalAlignmentTypeTop,
    BBVerticalAlignmentTypeBottom,
};

@interface BBVerticalAlignmentLabel : UILabel

@property (nonatomic, assign) BBVerticalAlignmentType m_VerticalAlignment;

@end
