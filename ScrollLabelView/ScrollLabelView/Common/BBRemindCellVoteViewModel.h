//
//  BBRemindCellVoteViewModel.h
//  pregnancy
//
//  Created by zhoujihang on 16/10/20.
//  Copyright © 2016年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BBRemindCellVoteViewState) {
    BBRemindCellVoteViewStateHidden,        // 无投票功能
    BBRemindCellVoteViewStateWait,          // 还不能投票
    BBRemindCellVoteViewStateVoted,         // 已投票
    BBRemindCellVoteViewStateVoting,        // 可以投票
};

@interface BBRemindCellVoteViewModel : NSObject



@property (nonatomic, copy) NSString *m_KnowledgeID;

@property (nonatomic, copy) NSString *m_OptionOneText;
@property (nonatomic, copy) NSString *m_OptionOneValue;

@property (nonatomic, copy) NSString *m_OptionTwoText;
@property (nonatomic, copy) NSString *m_OptionTwoValue;

// 0 没有选中 1 选中optionOne, 2 选中optionTwo
@property (nonatomic, assign) NSInteger m_SelectedOption;
// 视图当前显示状态
@property (nonatomic, assign) BBRemindCellVoteViewState m_ViewState;

+ (instancetype)fakeModelSelectOne;
+ (instancetype)fakeModelSelectTwo;
+ (instancetype)fakeModelWait;
+ (instancetype)fakeModelVoting;
+ (instancetype)fakeModelHidden;
@end
