//
//  ZMDayCell.m
//  ZMCalendar
//
//  Created by Teslia Akatsuki (Zmsky) on 15/11/11.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "ZMDayCell.h"
#import "ZMDateModel.h"
#import "UIColor+ZMExtension.h"
#import "UIView+ZMExtension.h"

@interface ZMDayCell ()

@property (strong, nonatomic) UILabel *dayLabel;

@end

@implementation ZMDayCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Fix Performance Issues
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
    }
    return self;
}

-(void)setModel:(ZMDateModel *)model {
    _model = model;
    
    [self reload];
}

-(void)reload{
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(),^{
        
        wself.dayLabel.text = _model.day;
        
        // Defalut setting
        {
            wself.dayLabel.textColor = [UIColor darkGrayColor];
            wself.dayLabel.alpha = 1;
            wself.dayLabel.layer.masksToBounds = YES;
            wself.dayLabel.layer.cornerRadius = 0;
            wself.dayLabel.layer.borderWidth = 1;
            wself.dayLabel.layer.borderColor = [UIColor clearColor].CGColor;
            wself.dayLabel.backgroundColor = [UIColor whiteColor];
            NSInteger size = 30;
            if (self.height <= 30) {
                size = self.height - 2;
            }
            wself.dayLabel.frame = CGRectMake(self.width / 2 - size / 2, self.height / 2 - size / 2, size, size);
        }
        
        // Check weekend
        if (_model.weekDay == 0) {
            // 星期天
            wself.dayLabel.textColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1];
        }
        
        if (_model.weekDay == 6) {
            // 星期六
            wself.dayLabel.textColor = [UIColor colorWith8BitRed:36 green:176 blue:208 alpha:1];
        }
        
        if (!_model.isInCurrentMonth) {
            wself.dayLabel.alpha = 0.5;
        }
        
        if (_model.isInCurrentMonth && _model.isEventDay) {
            wself.dayLabel.layer.cornerRadius = wself.dayLabel.height / 2;
            wself.dayLabel.layer.borderColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1].CGColor;
        }
        
        if (_model.isInCurrentMonth && ((_model.isSelected || _forceSelected) || (!_model.disableToday  && _model.isToday) ) ) {
            wself.dayLabel.layer.cornerRadius = wself.dayLabel.height / 2;
            wself.dayLabel.textColor = [UIColor whiteColor];
            wself.dayLabel.backgroundColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1];
        }
    });
}

-(UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - 15, self.height / 2 - 15, 30, 30)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_dayLabel];
    }
    return _dayLabel;
}

@end
