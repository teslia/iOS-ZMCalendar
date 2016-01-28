//
//  ZMCalendarViewController.h
//  ZMCalendar
//
//  Created by Teslia Akatsuki on 2015/11/10.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMDateModel;
@class ZMDayCell;

@protocol ZMCalendarDataSource <NSObject>

@required
-(void)calendarLoadDayCell:(ZMDayCell *)dayCell dateModel:(ZMDateModel *)dateModel;

@end

@protocol ZMCalendarDelegate <NSObject>

@required
-(void)calendarMonthDidChanged:(NSDate *)date;
-(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell;

@end

@interface ZMCalendarViewController : UIViewController

@property (nonatomic,strong) ZMDateModel *minDate;
@property (nonatomic,strong) ZMDateModel *maxDate;
@property (nonatomic,assign) NSInteger bottomPading;
@property (nonatomic,assign) BOOL isScrolling;
@property (nonatomic,assign) BOOL disableToday;

@property (nonatomic,assign) id <ZMCalendarDataSource> dataSource;
@property (nonatomic,assign) id <ZMCalendarDelegate> delegate;

- (void)reload;
- (void)reloadLeftRight;
- (void)next;
- (void)previous;
- (void)today;

@end
