//
//  BBScrollLabelView.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/17.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BBScrollLabelViewScrollType) {
    BBScrollLabelViewScrollTypeLeftRight,
    BBScrollLabelViewScrollTypeUpDown,
};

@class BBScrollLabelView;
@protocol BBScrollLabelViewDataSource <NSObject>

- (NSInteger)numberOfTextInScrollLabelView:(BBScrollLabelView *)view;
- (NSString *)scrollLabelView:(BBScrollLabelView *)view textOfIndex:(NSInteger)index;

@end
@protocol BBScrollLabelViewDelegate <NSObject>
@optional
- (void)scrollLabelView:(BBScrollLabelView *)view willScrollToIndex:(NSInteger)index text:(NSString *)text textHeight:(CGFloat)height;
- (void)scrollLabelView:(BBScrollLabelView *)view didScrollToIndex:(NSInteger)index text:(NSString *)text textHeight:(CGFloat)height;
@end

@interface BBScrollLabelView : UIView

@property (nonatomic, weak) id<BBScrollLabelViewDataSource> m_DataSource;
@property (nonatomic, weak) id<BBScrollLabelViewDelegate> m_Delegate;

@property (nonatomic, assign) BBScrollLabelViewScrollType m_ScrollType;

@property (nonatomic, strong) UIFont *m_Font;
@property (nonatomic, strong) UIColor *m_TextColor;
@property (nonatomic, assign) NSTimeInterval m_Duration;

@end
