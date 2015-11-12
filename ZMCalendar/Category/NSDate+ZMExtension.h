//
//  NSDate+ZMExtension.h
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZMExtension)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;

- (NSDateComponents *)HMSComponents;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

- (long)getWeekIntValueWithDate;

+ (long)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;


+ (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB;

+ (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate;

@end
