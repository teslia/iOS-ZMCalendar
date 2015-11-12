//
//  ZMCalendarMonthView
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "NSDate+ZMExtension.h"
#import "ZMCalendarMonthView.h"
#import "ZMDayCell.h"
#import "ZMDateModel.h"

@interface ZMCalendarMonthView ()

@property (nonatomic,assign) CGFloat cellWidth;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSMutableArray *dayViews;

@end

@implementation ZMCalendarMonthView


-(instancetype)initWithFrame:(CGRect)frame dateModel:(ZMDateModel *) dateModel{
    if (self = [super initWithFrame:frame]) {
        _model = dateModel;
        [self performSelector:@selector(initView) withObject:self afterDelay:0.1];
    }
    return self;
}

-(void)initView{
    [self loadDefaultConfig];
    [self loadCalendarView];
}

-(void)loadDefaultConfig {
    
    self.dayViews = [NSMutableArray array];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.padding = 1;
    self.cellWidth = self.frame.size.width / 7;
    self.cellHeight = self.frame.size.height / 6;
    
}

-(void)loadCalendarView{
    
    typeof(self) wself = self;

    // 清理原有数据
    for (UIView *view in wself.dayViews) {
        [view removeFromSuperview];
    }
    [wself.dayViews removeAllObjects];
    
    // 获取可用天数
    NSDate *currentDate = [wself.model getNSDate];
    NSInteger numberOfDaysInCurrentMonth = [currentDate numberOfDaysInCurrentMonth];
    // 获取上个月可用天数
    NSInteger numberOfDaysInPreviousMonth = [[currentDate dayInThePreviousMonth] numberOfDaysInCurrentMonth];
    
    // 获取当前月第一天是星期几
    NSInteger weeklyOrdinality = [currentDate weeklyOrdinality];
    
    NSInteger dayIndex = 0;
    
    for (int i = 0; i < 6; i++) {
        
        for (int j = 0; j < 7; j++) {
            
            CGRect cellFrame = CGRectMake(_cellWidth * j , _cellHeight * i, _cellWidth - _padding , _cellHeight - _padding);
            ZMDayCell *dayCell = [[ZMDayCell alloc]initWithFrame:cellFrame];
            
            ZMDateModel *dayInfo = [[ZMDateModel alloc]init];
            dayInfo.year = wself.model.year;
            dayInfo.month = wself.model.month;
            dayInfo.weekDay = j;
            dayInfo.isInCurrentMonth = NO;
            dayInfo.isEventDay = NO;
            dayInfo.isSelected = NO;
            
            if ((weeklyOrdinality <= j || i > 0)&& dayIndex < numberOfDaysInCurrentMonth) {
                //正常可用天
                dayIndex++;
                
                dayInfo.day = [NSString stringWithFormat:@"%ld",(long)dayIndex];
                dayInfo.isInCurrentMonth = YES;
            
            }else if(i == 0){
                //上月
                if (dayInfo.month.integerValue == 1) {
                    dayInfo.year = [NSString stringWithFormat:@"%ld", (wself.model.year.integerValue - 1)];
                    dayInfo.month = @"12";
                }else{
                    NSInteger month = wself.model.month.integerValue - 1;
                    dayInfo.month = [NSString stringWithFormat:@"%ld", (long)month];
                }
                
                NSInteger overflow = numberOfDaysInPreviousMonth - (weeklyOrdinality - j - 1);
                dayInfo.day = [NSString stringWithFormat:@"%ld",(long)overflow];
   
                
            }else if(dayIndex >= numberOfDaysInCurrentMonth){
                NSInteger overflow = (j + i * 7) - numberOfDaysInCurrentMonth + 1;
                
                if (dayInfo.month.integerValue == 12) {
                    dayInfo.year = [NSString stringWithFormat:@"%ld", (wself.model.year.integerValue + 1)];
                    dayInfo.month = @"1";
                }else{
                    NSInteger month = wself.model.month.integerValue + 1;
                    dayInfo.month = [NSString stringWithFormat:@"%ld", (long)month];
                }
                
                dayInfo.day = [NSString stringWithFormat:@"%ld",(long)overflow];
                
            }
            
            //Load datasouce
            [wself loadDayInfo:dayInfo dayCell:dayCell];
            dayCell.model = dayInfo;
            [dayCell addTarget:wself action:@selector(dayCellDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            [wself addSubview:dayCell];
            [wself.dayViews addObject:dayCell];
        }
        
    }

}



-(void)removeAllSelected{
    for (ZMDayCell *cell in _dayViews) {
            cell.model.isSelected = NO;
            [cell reload];
    }
}

-(void)reloadAll{
    for (ZMDayCell *cell in _dayViews) {
        cell.model.isEventDay = NO;
        cell.model.isSelected = NO;
        [self loadDayInfo:cell.model dayCell:cell];
        [cell reload];
    }
}

#pragma mark - Delegate
-(void)dayCellDidSelect:(ZMDayCell *)dayCell{
    if (self.delegate && dayCell.model.isInCurrentMonth) {
        
        [self removeAllSelected];
        
        dayCell.model.isSelected = YES;
        [dayCell reload];
        
        [self.delegate calendarDayDidSelected:dayCell.model dayCell:dayCell];
    }
}

#pragma mark - Datasouce
-(void)loadDayInfo:(ZMDateModel *)dayInfo dayCell:(ZMDayCell *)dayCell {
    if (self.dataSource) {
        [self.dataSource calendarLoadDayCell:dayCell dateModel:dayInfo];
    }
}

#pragma mark - Property 
-(void)setModel:(ZMDateModel *)model {
    _model = model;
    [self loadCalendarView];
}

@end
