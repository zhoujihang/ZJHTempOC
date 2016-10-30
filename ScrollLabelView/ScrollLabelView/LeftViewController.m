//
//  LeftViewController.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "LeftViewController.h"
#import "BBScrollLabelView.h"

@interface LeftViewController ()<BBScrollLabelViewDelegate, BBScrollLabelViewDataSource>

@property (nonatomic, weak) BBScrollLabelView *s_ScrollLabelView;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupPosition];
}
- (void)setupViews{
    self.navigationItem.title = @"Scroll Label";
    
    BBScrollLabelView *scrollLabelView = [[BBScrollLabelView alloc] init];
    scrollLabelView.m_Delegate = self;
    scrollLabelView.m_DataSource = self;
    scrollLabelView.backgroundColor = [UIColor redColor];
    scrollLabelView.m_ScrollType = BBScrollLabelViewScrollTypeLeftRight;
    scrollLabelView.m_Font = [UIFont boldSystemFontOfSize:25];
    scrollLabelView.m_TextColor = [UIColor greenColor];
    scrollLabelView.m_Duration = 0.5;
    [self.view addSubview:scrollLabelView];
    self.s_ScrollLabelView = scrollLabelView;
    
}
- (void)setupPosition{
    CGFloat padding = 18;
    CGFloat preferedMaxWidth = [UIScreen mainScreen].bounds.size.width - padding*2;
    self.s_ScrollLabelView.frame = CGRectMake(18, 100, preferedMaxWidth, 100);
}

- (NSInteger)numberOfTextInScrollLabelView:(BBScrollLabelView *)view{
    return 10;
}
- (NSString *)scrollLabelView:(BBScrollLabelView *)view textOfIndex:(NSInteger)index{
    NSInteger i = index%3;
    NSArray *textArray = @[
                           @"UIPanGestureRecognizer主要用于拖动,比如桌面上有一张图片uiimageview,你想让它由原始位置拖到任何一个位置,就是图片跟着你的手指走动,那么就需要用",
                           @"凤凰资本（ Phoenix Capital.）表示，“中央银行家几乎在明确暗示，他们想要通货膨胀，他们甚至暗示，央行愿意让通货膨胀高于目标通胀运行。我们应该清楚，一旦通货膨胀了，控制几乎是不可能的。并不是说美联储可以让“通胀精灵”在瓶子外待一段时间，过上一两个月后，美联储再把它抓回瓶子。”",
                           @"因为中国游客去了朝鲜，违背了联合国对朝制裁决议。而隔壁金大帅搞核试验的钱，都是中国游客“送”去的。为了彻底阻断金大帅赚取外汇，韩国人不许中国人再去朝鲜。对于向中国人销售朝鲜旅游产品的中国旅行社，如果其销售朝鲜旅游产品，将中断其代理申请韩国签证的业务。"
                           ];
    NSString *text = textArray[i];
    
    return text;
}

- (void)scrollLabelView:(BBScrollLabelView *)view willScrollToIndex:(NSInteger)index text:(NSString *)text textHeight:(CGFloat)height{
    [self.s_ScrollLabelView sizeToFit];
}
- (void)scrollLabelView:(BBScrollLabelView *)view didScrollToIndex:(NSInteger)index text:(NSString *)text textHeight:(CGFloat)height{
    //    CGRect frame = self.s_ScrollLabelView.frame;
    //    frame.size.height = height;
    //    self.s_ScrollLabelView.frame = frame;
}
@end
