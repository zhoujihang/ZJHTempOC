//
//  BBHorizontalScrollLabelView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBHorizontalScrollLabelView;
@protocol BBHorizontalScrollLabelViewDelegate <NSObject>
- (void)horizontalScrollLabelView:(BBHorizontalScrollLabelView *)view willScrollToText:(NSString *)text viewNewHeight:(CGFloat)height;
- (void)horizontalScrollLabelView:(BBHorizontalScrollLabelView *)view didScrollToText:(NSString *)text viewNewHeight:(CGFloat)height;
@end

@interface BBHorizontalScrollLabelView : UIView

@property (nonatomic, weak) id<BBHorizontalScrollLabelViewDelegate> m_Delegate;

- (void)resetWithCenterString:(NSString *)string;
- (void)leftSlideWithCenterString:(NSString *)string;
- (void)rightSlideWithCenterString:(NSString *)string;

@property (nonatomic, assign) CGFloat m_PreferedMaxLayoutWidth;
@property (nonatomic, strong) UIFont *m_Font;
@property (nonatomic, strong) UIColor *m_Color;
@end
