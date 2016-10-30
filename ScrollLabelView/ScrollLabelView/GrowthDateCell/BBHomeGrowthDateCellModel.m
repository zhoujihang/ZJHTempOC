//
//  BBHomeGrowthDateCellModel.m
//  ScrollLabelView
//
//  Created by zhoujihang on 16/10/24.
//  Copyright © 2016年 zhoujihang. All rights reserved.
//

#import "BBHomeGrowthDateCellModel.h"
#import "BBHomeGrowthDateCell.h"

@implementation BBHomeGrowthDateCellModel


+ (NSArray *)fakeModelArray{
    NSArray *contentArray = @[
                              @"越接近活动采矿面，环境就会变得越恶劣。过道变得越来越窄，矿工们只有弯着腰才能通过。",
                              @"",
                              @"在现代矿井内，水平巷道从中央竖井向各个方向延伸、进入到各个深度的采矿面。主巷道的直径超过7.5米，墙壁和顶部都是钢筋混凝土混合结构，钢筋与周围的岩石牢牢固定在了一起。但是越接近活动采矿面，环境就会变得越恶劣。",
                              @"北京CBD将不堪重负 十年后聚集60万上班族比卢森堡人口还多",
                              @"空气环境和交通拥堵还在持续恶化",
                              @"但首都CBD的聚合能力依然不减。",
                              @"60万人扎堆是什么概念呢？人口数量比欧洲国家卢森堡全国人口还多，而面积只有卢森堡的1/258（卢森堡国土面积2586.3平方公里）。",
                              @"早年，这片首都核心商务区的面积甚至不足4平方公里。如此增速令仲量联行的研究者们感到担心，北京近年来交通状况仍在恶化，在规划已经基本成型的基础上，他们认为十年后的国贸区域将承受比现在更大的压力。这片为60万上班族提供工作场所的区域有可能成为整个北京最难进出的地方。",
                              @"发家致富的秘密并不在于如何用钱，而在于如何思考。",
                              @"白手起家的百万富翁西博尔德（Steve Siebold）花了26年时间采访世界上最富有的人，随后将他的发现写入《富人怎么思考》（How Rich People Think）一书。\n他发现发家致富的秘密“并不在于如何用钱，而在于如何思考”。"
                              ];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *todayDate = [NSDate date];
    NSCalendarUnit option = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSInteger daySeconds = 24*60*60;
    NSDate *tempDate = todayDate;
    
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<10; i++) {
        BBHomeGrowthDateCellModel *model = [[BBHomeGrowthDateCellModel alloc] init];
        tempDate = [todayDate dateByAddingTimeInterval:daySeconds*i];
        NSDateComponents *dateCpt = [calendar components:option fromDate:tempDate];
        model.m_DateComponents = dateCpt;
        model.m_Name = @"阳阳";
        model.m_Age = @"1年11个月22天";
        model.m_KnowledgeContent = contentArray[i];
        model.m_BabyWeight = @"体重：2.3-4.8KG";
        model.m_BabyHeight = @"身高：45.3-56.8CM";
        [marr addObject:model];
    }
    return [marr copy];
}
- (CGFloat)m_ViewHeight{
    if (_m_ViewHeight!=0) {return _m_ViewHeight;}
    
    // 高度适配器
    static BBHomeGrowthDateCell *cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[BBHomeGrowthDateCell alloc] init];
    });
    
    [cell resetViewWithModel:self];
    _m_ViewHeight = [cell intrinsicContentSize].height;
    return _m_ViewHeight;
}


@end
