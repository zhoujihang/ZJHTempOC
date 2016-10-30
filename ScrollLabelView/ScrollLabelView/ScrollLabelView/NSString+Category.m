//
//  NSString+Category.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/18.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (BOOL)isNotEmpty{
    return !(self == nil || [self isKindOfClass:[NSNull class]] || ([self respondsToSelector:@selector(length)] && [(NSData *)self length] == 0) || ([self respondsToSelector:@selector(count)] && ([(NSArray *)self count] == 0)));
}

@end
