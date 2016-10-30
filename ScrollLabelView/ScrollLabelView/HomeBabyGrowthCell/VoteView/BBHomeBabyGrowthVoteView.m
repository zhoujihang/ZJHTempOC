//
//  BBHomeBabyGrowthVoteView.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeBabyGrowthVoteView.h"

@interface BBHomeBabyGrowthVoteView ()

@property (nonatomic, weak) UIButton *s_OptionBtn1;
@property (nonatomic, weak) UIButton *s_OptionBtn2;

@property (nonatomic, weak) UIView *s_BackdropResultView;
@property (nonatomic, weak) UILabel *s_ResultLabel;

@property (nonatomic, assign) BBRemindCellVoteViewState s_ViewState;

@end

@implementation BBHomeBabyGrowthVoteView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupViews];
    [self setupPosition];
    [self setupData];
}
- (void)setupViews{
    CGFloat onePixel = 1/[UIScreen mainScreen].scale;
    
    UIButton *optionBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    optionBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [optionBtn1 setTitle:@"是的" forState:UIControlStateNormal];
    [optionBtn1 setTitleColor:RGBColor(117, 210, 212, 1) forState:UIControlStateNormal];
    [optionBtn1 setTitleColor:RGBColor(216, 216, 216, 1) forState:UIControlStateDisabled];
    [optionBtn1 setBackgroundColor:[UIColor whiteColor]];
    optionBtn1.layer.cornerRadius = 3;
    optionBtn1.layer.masksToBounds = YES;
    optionBtn1.layer.borderWidth = onePixel;
    optionBtn1.layer.borderColor = RGBColor(117, 210, 212, 1).CGColor;
    [optionBtn1 addTarget:self action:@selector(optionBtn1DidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:optionBtn1];
    self.s_OptionBtn1 = optionBtn1;
    
    UIButton *optionBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    optionBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [optionBtn2 setTitle:@"还没有" forState:UIControlStateNormal];
    [optionBtn2 setTitleColor:RGBColor(117, 210, 212, 1) forState:UIControlStateNormal];
    [optionBtn2 setTitleColor:RGBColor(216, 216, 216, 1) forState:UIControlStateDisabled];
    [optionBtn2 setBackgroundColor:[UIColor whiteColor]];
    optionBtn2.layer.cornerRadius = 3;
    optionBtn2.layer.masksToBounds = YES;
    optionBtn2.layer.borderWidth = onePixel;
    optionBtn2.layer.borderColor = RGBColor(117, 210, 212, 1).CGColor;
    [optionBtn2 addTarget:self action:@selector(optionBtn2DidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:optionBtn2];
    self.s_OptionBtn2 = optionBtn2;
    
    
    UIView *backdropResultView = [[UIView alloc] init];
    backdropResultView.backgroundColor = RGBColor(246, 247, 249, 1);
    [self addSubview:backdropResultView];
    self.s_BackdropResultView = backdropResultView;
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.s_BackdropResultView addSubview:resultLabel];
    self.s_ResultLabel = resultLabel;
}
- (void)setupPosition{
    CGRect leftBtnFrame = CGRectMake(75, 0, 90, 30);
    CGFloat leftBtnMaxX = CGRectGetMaxX(leftBtnFrame);
    CGRect rightBtnFrame = CGRectMake(leftBtnMaxX+24, 0, 90, 30);
    
    CGRect backdropResultViewFrame = CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width-32, 30);
    CGRect resultLabelFrame = CGRectMake(8, 0, backdropResultViewFrame.size.width-16, backdropResultViewFrame.size.height);
    self.s_OptionBtn1.frame = leftBtnFrame;
    self.s_OptionBtn2.frame = rightBtnFrame;
    self.s_BackdropResultView.frame = backdropResultViewFrame;
    self.s_ResultLabel.frame = resultLabelFrame;
}
- (void)setupData{
    [self resetStateWithViewState:BBRemindCellVoteViewStateWait];
}

- (void)setM_ViewModel:(BBRemindCellVoteViewModel *)m_ViewModel{
    _m_ViewModel = m_ViewModel;
    
    [self resetStateWithViewState:m_ViewModel.m_ViewState];
    
    [self.s_OptionBtn1 setTitle:m_ViewModel.m_OptionOneText forState:UIControlStateNormal];
    [self.s_OptionBtn2 setTitle:m_ViewModel.m_OptionTwoText forState:UIControlStateNormal];
    
    // 设置结果
    if (m_ViewModel.m_SelectedOption == 0) {
        self.s_ResultLabel.attributedText = nil;
        return;
    }
    UIFont *titleFont = [UIFont boldSystemFontOfSize:14];
    UIFont *contentFont = [UIFont systemFontOfSize:14];
    if ([UIScreen mainScreen].bounds.size.width < 375) {
        // 小屏幕
        titleFont = [UIFont boldSystemFontOfSize:12];
        contentFont = [UIFont systemFontOfSize:12];
    }
    NSString *titleString = @"您选择了：";
    NSString *contentString = @"";
    if (m_ViewModel.m_SelectedOption == 1){
        contentString = [NSString stringWithFormat:@"%@，有%@的宝宝和您的宝宝一样",m_ViewModel.m_OptionOneText, m_ViewModel.m_OptionOneValue];
        
    }else if (m_ViewModel.m_SelectedOption == 2){
        contentString = [NSString stringWithFormat:@"%@，有%@的宝宝和您的宝宝一样",m_ViewModel.m_OptionTwoText, m_ViewModel.m_OptionTwoValue];
    }
    NSString *resultString = [NSString stringWithFormat:@"%@%@",titleString, contentString];
    NSDictionary *titleOptions = @{
                                   NSFontAttributeName : titleFont,
                                   NSForegroundColorAttributeName : RGBColor(101, 101, 101, 1),
                                   };
    NSDictionary *contentOptions = @{
                                     NSFontAttributeName : contentFont,
                                     NSForegroundColorAttributeName : RGBColor(152, 152, 152, 1),
                                     };
    NSRange titleRange = [resultString rangeOfString:titleString];
    NSRange contentRange = [resultString rangeOfString:contentString];
    
    NSMutableAttributedString *resultAttrString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [resultAttrString addAttributes:titleOptions range:titleRange];
    [resultAttrString addAttributes:contentOptions range:contentRange];
    self.s_ResultLabel.attributedText = resultAttrString;
}
- (void)resetStateWithViewState:(BBRemindCellVoteViewState)state{
    self.hidden = NO;
    switch (state) {
        case BBRemindCellVoteViewStateHidden:{
            self.hidden = YES;
        }
            break;
        case BBRemindCellVoteViewStateVoted:{
            self.s_BackdropResultView.hidden= NO;
            self.s_OptionBtn1.hidden = YES;
            self.s_OptionBtn2.hidden = YES;
        }
            break;
        case BBRemindCellVoteViewStateVoting:{
            self.s_BackdropResultView.hidden= YES;
            self.s_OptionBtn1.hidden = NO;
            self.s_OptionBtn2.hidden = NO;
            self.s_OptionBtn1.enabled = YES;
            self.s_OptionBtn2.enabled = YES;
            self.s_OptionBtn1.layer.borderColor = RGBColor(117, 210, 212, 1).CGColor;
            self.s_OptionBtn2.layer.borderColor = RGBColor(117, 210, 212, 1).CGColor;
        }
            break;
        case BBRemindCellVoteViewStateWait:{
            self.s_BackdropResultView.hidden= YES;
            self.s_OptionBtn1.hidden = NO;
            self.s_OptionBtn2.hidden = NO;
            self.s_OptionBtn1.enabled = NO;
            self.s_OptionBtn2.enabled = NO;
            self.s_OptionBtn1.layer.borderColor = RGBColor(216, 216, 216, 1).CGColor;
            self.s_OptionBtn2.layer.borderColor = RGBColor(216, 216, 216, 1).CGColor;
        }
            break;
            
        default:
            break;
    }
}
- (CGSize)intrinsicContentSize{
    CGFloat height = self.m_ViewModel.m_ViewState==BBRemindCellVoteViewStateHidden ? 0 : 30;
    return CGSizeMake(-1, height);
}

- (void)optionBtn1DidClick:(UIButton *)sender{
    self.m_ViewModel.m_SelectedOption = 1;
    self.m_ViewModel.m_ViewState = BBRemindCellVoteViewStateVoted;
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthVoteViewDidClickOptionOneBtn:)]) {
        [self.m_Delegate homeBabyGrowthVoteViewDidClickOptionOneBtn:self];
    }
}
- (void)optionBtn2DidClick:(UIButton *)sender{
    self.m_ViewModel.m_SelectedOption = 2;
    self.m_ViewModel.m_ViewState = BBRemindCellVoteViewStateVoted;
    if ([self.m_Delegate respondsToSelector:@selector(homeBabyGrowthVoteViewDidClickOptionTwoBtn:)]) {
        [self.m_Delegate homeBabyGrowthVoteViewDidClickOptionTwoBtn:self];
    }
}

@end
