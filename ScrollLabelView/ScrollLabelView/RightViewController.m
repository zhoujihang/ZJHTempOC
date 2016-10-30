//
//  RightViewController.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/21.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "RightViewController.h"
#import <Masonry/Masonry.h>
#import "BBHomeGrowthDateCell.h"

@interface RightViewController ()<UITableViewDelegate, UITableViewDataSource, BBHomeGrowthDateCellDelegate, BBHomeGrowthDateCellDataSource>

@property (nonatomic, weak) UITableView *s_TableView;
@property (nonatomic, strong) BBHomeGrowthDateCell *s_GrowthDateCell;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}
- (void)setupViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Home Cell";
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    tableView.contentOffset = CGPointMake(0, -64);
    [self.view addSubview:tableView];
    self.s_TableView = tableView;
    
    [self.s_TableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}
- (void)setupConstraints{
    [self.s_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
}

- (BBHomeGrowthDateCell *)s_GrowthDateCell{
    if (_s_GrowthDateCell) {return _s_GrowthDateCell;}
    
    _s_GrowthDateCell = [[BBHomeGrowthDateCell alloc] init];
    _s_GrowthDateCell.m_Delegate = self;
    _s_GrowthDateCell.m_DataSource = self;
    [_s_GrowthDateCell resetViewWithItemIndex:0];
    return _s_GrowthDateCell;
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        BBHomeGrowthDateCell *growthDateCell = self.s_GrowthDateCell;
        cell = growthDateCell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = self.s_GrowthDateCell.m_CurrentModel.m_ViewHeight;
    }else{
        height = 44;
    }
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"tap:%@",indexPath);
}

#pragma mark - BBHomeGrowthDateCell 代理
- (NSInteger)numberOfItemsInHomeGrowthDateCell:(BBHomeGrowthDateCell *)cell{
    NSArray *fakeModelArray = [BBHomeGrowthDateCellModel fakeModelArray];
    return fakeModelArray.count;
}
- (BBHomeGrowthDateCellModel *)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell itemModelOfIndex:(NSInteger)index{
    NSArray *fakeModelArray = [BBHomeGrowthDateCellModel fakeModelArray];
    return fakeModelArray[index];
}

- (void)homeGrowthDateCellDidClickRecodeBtn:(BBHomeGrowthDateCell *)cell{
    NSLog(@"%s", __func__);
}
- (void)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell willScrollToItemIndex:(NSInteger)index itemModel:(BBHomeGrowthDateCellModel *)model{
    [self.s_TableView reloadData];
}
- (void)homeGrowthDateCell:(BBHomeGrowthDateCell *)cell didEndScrollToItemIndex:(NSInteger)index itemModel:(BBHomeGrowthDateCellModel *)model{
    // 重新计算高度
//    [self.s_TableView reloadData];
}


@end
