//
//  ZMCalendarMonthView
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMDateModel;
@class ZMDayCell;

@protocol ZMCalendarMonthViewDataSource <NSObject>

@required
-(void)calendarLoadDayCell:(ZMDayCell *)dayCell dateModel:(ZMDateModel *)dateModel;

@end

@protocol ZMCalendarMonthViewDelegate <NSObject>

@required
-(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell;

@end



@interface ZMCalendarMonthView : UIView

@property (nonatomic,assign) NSInteger padding;
@property (nonatomic,strong) ZMDateModel* model;

@property (nonatomic,assign) id <ZMCalendarMonthViewDataSource> dataSource;
@property (nonatomic,assign) id <ZMCalendarMonthViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame dateModel:(ZMDateModel *) dateModel;
-(void)removeAllSelected;
-(void)reloadAll;

@end
