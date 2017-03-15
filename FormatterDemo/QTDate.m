//
//  QTDate.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTDate.h"
#import "QTDateTool.h"
@implementation QTDate

+ (NSArray *)dates
{
    NSMutableArray *dates = [NSMutableArray array];
    
    QTDateTool *dateTool = [QTDateTool sharedInstance];
    // 日历上总共可以显示的天数
    int count = 7;
    for (int i = 0; i < count; i++) {
        dateTool.index = i;
        QTDate *date = [[QTDate alloc]init];
        date.weekday = [dateTool getWeekday];
        date.day = [dateTool getDay];
        date.month = [dateTool getMonth];
        [dates addObject:date];
    }
    return [dates copy];
}

@end
