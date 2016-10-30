//
//  BBRemindCellVoteViewModel.m
//  pregnancy
//
//  Created by zhoujihang on 16/10/20.
//  Copyright © 2016年 babytree. All rights reserved.
//

#import "BBRemindCellVoteViewModel.h"

@implementation BBRemindCellVoteViewModel

+ (instancetype)fakeModel{
    BBRemindCellVoteViewModel *model = [[BBRemindCellVoteViewModel alloc] init];
    model.m_KnowledgeID = @"7707";
    model.m_OptionOneText = @"喜欢";
    model.m_OptionOneValue = @"92.4%";
    model.m_OptionTwoText = @"不喜欢";
    model.m_OptionTwoValue = @"7.6%";
    return model;
}

+ (instancetype)fakeModelSelectOne{
    BBRemindCellVoteViewModel *model = [self fakeModel];
    model.m_SelectedOption = 1;
    model.m_ViewState = BBRemindCellVoteViewStateVoted;
    return model;
}
+ (instancetype)fakeModelSelectTwo{
    BBRemindCellVoteViewModel *model = [self fakeModel];
    model.m_SelectedOption = 2;
    model.m_ViewState = BBRemindCellVoteViewStateVoted;
    return model;
}
+ (instancetype)fakeModelWait{
    BBRemindCellVoteViewModel *model = [self fakeModel];
    model.m_SelectedOption = 0;
    model.m_ViewState = BBRemindCellVoteViewStateWait;
    return model;
}
+ (instancetype)fakeModelVoting{
    BBRemindCellVoteViewModel *model = [self fakeModel];
    model.m_SelectedOption = 0;
    model.m_ViewState = BBRemindCellVoteViewStateVoting;
    return model;
}
+ (instancetype)fakeModelHidden{
    BBRemindCellVoteViewModel *model = [self fakeModel];
    model.m_SelectedOption = 0;
    model.m_ViewState = BBRemindCellVoteViewStateHidden;
    return model;
}

@end
