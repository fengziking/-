//
//  QTDateTool.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTDateTool.h"

@implementation QTDateTool

/// 单例
+ (instancetype)sharedInstance
{
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

/// 获取当前年份
- (NSString *)getYear
{
    return [self getDate][0];
}

/// 获取当前月份
- (NSString *)getMonth
{
    return [self getDate][1];
}

/// 获取当前天（几号）
- (NSString *)getDay
{
    return [self getDate][2];
}

/// 获取分割后的明天日期，形式"yyyy","MM","dd" WithIndex:(NSUInteger)index
- (NSArray *)getDate{
    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24*self.index];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat  = @"yyyy-MM-dd";
//    //    formatter.dateFormat =  [date getDayOfWeekShortString];
//    NSString *dateString = [formatter stringFromDate:date];
    //    NSLog(@"%@",dateStr);
    
    NSString *dateString = [self getInternetDate];
    NSDate *destDate= [self.formatter dateFromString:dateString];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:destDate];
    [components setDay:([components day]+1+self.index)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
//    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
//    [dateday setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [self.dateday stringFromDate:beginningOfWeek];
    return [str componentsSeparatedByString:@"-"];
    
}

/// 获取当前周几
- (NSString *)getWeekday
{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[[self getDay] integerValue]];
    NSString *monthStr = [self getDate][1];
    [_comps setMonth:[monthStr integerValue]];
    [_comps setYear:[[self getYear] integerValue]];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    //NSDateComponents Weekday] 的返回值，默认是 星期天是 1
    NSInteger _weekday = [weekdayComponents weekday]-1; // 此处结果多了一天，减1，得到当前是周几}
    // 转为字符串
    NSString *weekdayStr = nil;
    switch (_weekday) {
        case 1:
            weekdayStr = @"周一";
            break;
        case 2:
            weekdayStr = @"周二";
            break;
        case 3:
            weekdayStr = @"周三";
            break;
        case 4:
            weekdayStr = @"周四";
            break;
        case 5:
            weekdayStr = @"周五";
            break;
        case 6:
            weekdayStr = @"周六";
            break;
        case 0:
            weekdayStr = @"周日";
            break;
    }
    //     NSLog(@"_weekday::%@",weekdayStr);
    return weekdayStr;
}
//获取网络时间
-(NSString *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:localeDate];
    return dateString;
}
- (NSDateFormatter *)formatter {
    
    if(! _formatter) {
        
        _formatter = [[NSDateFormatter alloc] init];
        
        [_formatter setDateFormat: @"yyyy-MM-dd"];
        
    }
    
    return _formatter;
    
}

- (NSDateFormatter *)dateday {
    
    if(! _dateday) {
        
        _dateday = [[NSDateFormatter alloc] init];
        
        [_dateday setDateFormat:@"yyyy-MM-dd"];
        
    }
    
    return _dateday;
    
}

@end
