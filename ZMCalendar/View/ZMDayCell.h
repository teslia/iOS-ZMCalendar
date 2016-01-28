//
//  ZMDayCell.h
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMDateModel;

@interface ZMDayCell : UIControl

@property (strong, nonatomic) ZMDateModel *model;
@property (assign, nonatomic) BOOL disableToday;

-(void)reload;

@end
