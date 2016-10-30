//
//  BBHomeGrowthCellViewController.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/26.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthCellViewController.h"
#import "BBHomeBabyGrowthCell.h"
#import "Masonry.h"

@interface BBHomeGrowthCellViewController () <UITableViewDelegate, UITableViewDataSource, BBHomeBabyGrowthCellDataSource, BBHomeBabyGrowthCellDelegate>

@property (nonatomic, weak) UITableView *s_TableView;
@property (nonatomic, strong) BBHomeBabyGrowthCell *s_BabyGrowthCell;
@property (nonatomic, strong) NSArray<BBHomeBabyGrowthCellModel *> *cellModelArray;
@property (nonatomic, strong) BBHomeBabyGrowthCellModel *s_TodayCellModel;

@end

@implementation BBHomeGrowthCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self setupViews];
    [self setupConstraints];
    [self setupData];
}
- (void)prepareData{
    self.cellModelArray = [BBHomeBabyGrowthCellModel fakeModelArray];
}
- (void)setupViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Home Cell";
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
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
- (void)setupData{
    self.s_TodayCellModel = [self.cellModelArray firstObject];
    [self.s_BabyGrowthCell resetViewWithItemIndex:0];
}
- (BBHomeBabyGrowthCell *)s_BabyGrowthCell{
    if (_s_BabyGrowthCell) {return _s_BabyGrowthCell;}
    
    _s_BabyGrowthCell = [[BBHomeBabyGrowthCell alloc] init];
    _s_BabyGrowthCell.m_Delegate = self;
    _s_BabyGrowthCell.m_DataSource = self;
    return _s_BabyGrowthCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.s_TableView.contentOffset.y;
    
    self.s_BabyGrowthCell.m_ScrollOffsetY = offsetY;
    
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        BBHomeBabyGrowthCell *growthDateCell = self.s_BabyGrowthCell;
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
        height = self.s_BabyGrowthCell.m_CurrentModel.m_ViewHeight;
    }else{
        height = 44;
    }
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"tap:%@",indexPath);
}

#pragma mark - BBHomeGrowthDateCell 数据源
- (NSInteger)numberOfItemsInHomeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell{
    return self.cellModelArray.count;
}
- (BBHomeBabyGrowthCellModel *)homeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell itemModelOfIndex:(NSInteger)index{
    return self.cellModelArray[index];
}
#pragma mark BBHomeGrowthDateCell 点击事件
- (void)homeBabyGrowthCellDidClickRecodeBtn:(BBHomeBabyGrowthCell *)cell{
    NSLog(@"%s", __func__);
}
- (void)homeBabyGrowthCellDidClickTodayView:(BBHomeBabyGrowthCell *)cell{
    NSInteger todayIndex = [self.cellModelArray indexOfObject:self.s_TodayCellModel];
    if (todayIndex != NSNotFound) {
        [self.s_BabyGrowthCell resetViewWithItemIndex:todayIndex];
    }
}
- (void)homeBabyGrowthCell:(BBHomeBabyGrowthCell *)cell willScrollToItemIndex:(NSInteger)index itemModel:(BBHomeBabyGrowthCellModel *)model{
    [self.s_TableView reloadData];
}

@end
