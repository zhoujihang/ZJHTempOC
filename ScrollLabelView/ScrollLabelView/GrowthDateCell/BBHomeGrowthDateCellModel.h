//
//  BBHomeGrowthDateCellModel.h
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/24.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBHomeGrowthDateCellModel : NSObject

// 视图内容
@property (nonatomic, copy) NSString *m_KnowledgeID;
@property (nonatomic, strong) NSDateComponents *m_DateComponents;
@property (nonatomic, copy) NSString *m_AvatarUrl;
@property (nonatomic, copy) NSString *m_Name;
@property (nonatomic, copy) NSString *m_Age;
@property (nonatomic, copy) NSString *m_KnowledgeContent;
@property (nonatomic, copy) NSString *m_BabyWeight;
@property (nonatomic, copy) NSString *m_BabyHeight;



// 计算视图高度，此方法必须在主线程调用
@property (nonatomic, assign) CGFloat m_ViewHeight;

+ (NSArray *)fakeModelArray;

@end
