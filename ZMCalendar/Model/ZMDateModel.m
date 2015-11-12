//
//  ZMDateModel.m
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "ZMDateModel.h"
#import "NSDate+ZMExtension.h"

@implementation ZMDateModel

-(instancetype)initWithYear:(NSString *)year month:(NSString *)month{
    if (self = [super init]) {
        self.year = year;
        self.month = month;
        self.day = @"01";
        
    }
    return self;
}

-(instancetype)initWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    if (self = [super init]) {
        self.year = year;
        self.month = month;
        self.day = day;
    }
    return self;
}

+(instancetype)dateModelWithNSDate:(NSDate *)date{
    ZMDateModel *dateModel = [ZMDateModel new];
    
    NSDateFormatter *dateFormatter = [dateModel _dateFormatter];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    dateModel.year = [dateStr substringToIndex:4];
    dateModel.month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    dateModel.day = [dateStr substringWithRange:NSMakeRange(6, 2)];
    
    return dateModel;
}

-(NSString *)getDateString{
    NSString *Year = self.year;
    NSString *Month = self.month.length > 1 ? self.month : [NSString stringWithFormat:@"0%@",self.month];
    NSString *Day = self.day.length > 1 ? self.day : [NSString stringWithFormat:@"0%@",self.day];
    return [NSString stringWithFormat:@"%@%@%@",Year,Month,Day];
}

-(NSDate *)getNSDate{
    NSDateFormatter *dateFormatter = [self _dateFormatter];
    NSString *dateString = [NSString stringWithFormat:@"%@0000",[self getDateString]];
    return [dateFormatter dateFromString:dateString];
}

-(NSDateFormatter *)_dateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatter.dateFormat = @"yyyyMMddHHmm";
    return dateFormatter;
}

-(BOOL)isToday{
    return [NSDate date:[self getNSDate] isTheSameDayThan:[NSDate date]];
}

@end
