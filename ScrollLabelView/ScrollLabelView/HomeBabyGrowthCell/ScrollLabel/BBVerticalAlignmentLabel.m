//
//  BBVerticalAlignmentLabel.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBVerticalAlignmentLabel.h"


@implementation BBVerticalAlignmentLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.m_VerticalAlignment = BBVerticalAlignmentTypeCenter;
    }
    return self;
}

- (void)setM_VerticalAlignment:(BBVerticalAlignmentType)m_VerticalAlignment{
    _m_VerticalAlignment = m_VerticalAlignment;
    
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.m_VerticalAlignment) {
        case BBVerticalAlignmentTypeTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case BBVerticalAlignmentTypeBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case BBVerticalAlignmentTypeCenter:
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
