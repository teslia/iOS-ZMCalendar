//
//  ViewController.m
//  ZMCalendar
//
//  Created by Teslia Akatsuki on 2015/11/10.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZMExtension.h"
#import "ZMCalendarViewController.h"
#import "ZMDateModel.h"
#import "NSDate+ZMExtension.h"

@interface ViewController () <ZMCalendarDataSource,ZMCalendarDelegate>

@property (nonatomic,strong) ZMCalendarViewController *zmc;
@property (nonatomic,strong) NSDate *selectedDate;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.zmc = [[ZMCalendarViewController alloc] initWithNibName:@"ZMCalendarViewController" bundle:nil];
    
    [self addChildViewController:_zmc];
    self.zmc.view.frame = CGRectMake(0, 20, self.view.width, self.view.height - 70);
    //self.zmc.minDate = [[ZMDateModel alloc] initWithYear:@"2015" month:@"05"];
    //self.zmc.maxDate = [[ZMDateModel alloc]initWithYear:@"2015" month:@"12"];
    self.zmc.bottomPading = 1;
    self.zmc.delegate = self;
    self.zmc.dataSource = self;
    [self.view addSubview:_zmc.view];
}

#pragma mark - Actions

- (IBAction)reloadAction:(id)sender {
    [self.zmc reload];
}

- (IBAction)todayAction:(id)sender {
    self.selectedDate = nil;
    [self.zmc today];
}

- (IBAction)previousAction:(id)sender {
    [self.zmc previous];
}

- (IBAction)nextAction:(id)sender {
    [self.zmc next];
}

#pragma mark - Delegate / Datasouce

-(void)calendarMonthDidChanged:(NSDate *)date{
    NSLog(@"calendarMonthDidChanged");
}
-(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell{
    // [!] 请一定要存储Selected状态 / Must save 'selected' status!!
    self.selectedDate = [dateModel getNSDate];
    NSLog(@"calendarDayDidSelected");
}
-(void)calendarLoadDayCell:(ZMDayCell *)dayCell dateModel:(ZMDateModel *)dateModel{
    if (_selectedDate && [NSDate date:_selectedDate isTheSameDayThan:[dateModel getNSDate]]) {
        dateModel.isSelected = YES;
    }
    
    NSLog(@"calendarLoadDayCell");
}

@end
