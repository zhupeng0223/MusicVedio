//
//  AreaDic.m
//  UI_HIGH_1028
//
//  Created by 谢科的Mac on 15/11/5.
//  Copyright © 2015年 xxl. All rights reserved.
//

#import "AreaDic.h"

@implementation AreaDic

-(instancetype)init{
    self = [super init];
    if (self) {
        self.areadictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"110000",@"北京", @"120000",@"天津", @"310000",@"上海", @"500000",@"重庆", @"130000",@"河北", @"140000",@"山西", @"210000",@"辽宁", @"220000",@"吉林", @"230000",@"黑龙江", @"320000",@"江苏", @"330000",@"浙江", @"340000",@"安徽", @"350000",@"福建", @"360000",@"江西", @"370000",@"山东", @"410000",@"河南", @"420000",@"湖北", @"430000",@"湖南", @"440000",@"广东", @"620000",@"甘肃", @"510000",@"四川", @"520000",@"贵州", @"460000",@"海南", @"530000",@"云南", @"630000",@"青海", @"610000",@"陕西", @"450000",@"广西", @"540000",@"西藏", @"640000",@"宁夏", @"650000",@"新疆", @"150000",@"内蒙古",  nil];
    }
    
    
    return self;
}

@end