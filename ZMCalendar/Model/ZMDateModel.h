//
//  ZMDateModel.h
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDateModel : NSObject

@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,assign) NSInteger weekDay;
@property (nonatomic,assign) BOOL isInCurrentMonth;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isEventDay;
@property (nonatomic,assign) BOOL isToday;
@property (nonatomic,assign) BOOL disableToday;

+(instancetype)dateModelWithNSDate:(NSDate *)date;
-(instancetype)initWithYear:(NSString *)year month:(NSString *)month;
-(instancetype)initWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

-(NSString *)getDateString;
-(NSDate *)getNSDate;

-(NSDateFormatter *)_dateFormatter;

@end
