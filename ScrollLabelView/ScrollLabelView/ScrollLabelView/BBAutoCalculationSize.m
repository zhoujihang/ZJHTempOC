//
//  BBAutoCalculationSize.m
//  pregnancy
//
//  Created by whl on 13-12-31.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBAutoCalculationSize.h"
#import "NSString+Category.h"

@implementation BBAutoCalculationSize

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString{
        return [self autoCalculationSizeRect:sizeRect withFont:wordFont withString:calculationString paragraphStyle:nil];
}

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString paragraphStyle:(NSParagraphStyle *)paragraphStyle
{
    CGSize size = CGSizeZero;
    // 如果calculationString 为空， 会蹦
    if (![calculationString isNotEmpty]) {
        return size;
    }
    CGRect expectedFrame = [calculationString boundingRectWithSize:sizeRect
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    wordFont, NSFontAttributeName,
                                                                    paragraphStyle,NSParagraphStyleAttributeName,
                                                                    nil]
                                                           context:nil];
    size = expectedFrame.size;
    size.height = ceil(size.height);
    size.width  = ceil(size.width);
    CGSize  modifySize = CGSizeMake(size.width, size.height);
    
    return modifySize;
}

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString maxLine:(NSInteger)lineNum{
    return [self autoCalculationSizeRect:sizeRect withFont:wordFont withString:calculationString maxLine:lineNum paragraphStyle:nil];
}

+(CGSize)autoCalculationSizeRect:(CGSize)sizeRect withFont:(UIFont *)wordFont withString:(NSString*)calculationString maxLine:(NSInteger)lineNum paragraphStyle:(NSParagraphStyle *)paragraphStyle
{

    // 如果calculationString 为空， 会蹦
    if (![calculationString isNotEmpty]) {
        return CGSizeZero;
    }
    
    CGSize resultSize = [BBAutoCalculationSize autoCalculationSizeRect:sizeRect withFont:wordFont withString:calculationString paragraphStyle:paragraphStyle];
    
    if (lineNum<=0)
    {
        return resultSize;
    }
    
    CGSize fontSize = CGSizeZero;

    fontSize = [calculationString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil]];
    
    if (resultSize.height > fontSize.height*lineNum)
    {
        return CGSizeMake(resultSize.width, fontSize.height*lineNum);
    }
    else
    {
        return resultSize;
    }
}
@end
