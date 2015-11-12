//
//  NSDate+ZMExtension.m
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "NSDate+ZMExtension.h"

@implementation NSDate (ZMExtension)

+ (NSCalendar *)calendar{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return calendar;
}

/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{

    // 频繁调用 [NSDate calendar] 可能存在性能问题
    return [[NSDate calendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:[self firstDayOfCurrentMonth]];
    long weekday = [componets weekday];
    return --weekday;
}



//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSDate calendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}


- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSDate calendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSDate calendar] dateFromComponents:dateComponents];
}

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSDate calendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSDate calendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSDate calendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSDate calendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSDate calendar] components:
            NSYearCalendarUnit|
            NSMonthCalendarUnit|
            NSDayCalendarUnit|
            NSWeekdayCalendarUnit fromDate:self];
}

-(NSDateComponents *)HMSComponents
{
    return [[NSDate calendar] components:
            NSHourCalendarUnit|
            NSMinuteCalendarUnit|
            NSSecondCalendarUnit
                                           fromDate:self];
}
//-----------------------------------------
//
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


+ (long)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//日历控件对象
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return day;
}


//周日是“1”，周一是“2”...
-(long)getWeekIntValueWithDate
{
    int weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps= [calendar components:(NSYearCalendarUnit |
                                                   NSMonthCalendarUnit |
                                                   NSDayCalendarUnit |
                                                   NSWeekdayCalendarUnit) fromDate:self];
    return weekIntValue = [comps weekday];
}


#pragma mark - Comparaison

+ (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
}

+ (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateA];
    NSDateComponents *componentsB = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear;
}

+ (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *componentsB = [[NSDate calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

+ (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedAscending || [self date:dateA isTheSameMonthThan:dateB]){
        return YES;
    }
    
    return NO;
}

+ (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedDescending || [self date:dateA isTheSameMonthThan:dateB]){
        return YES;
    }
    
    return NO;
}

+ (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate
{
    if([self date:date isEqualOrAfter:startDate] && [self date:date isEqualOrBefore:endDate]){
        return YES;
    }
    
    return NO;
}

@end
