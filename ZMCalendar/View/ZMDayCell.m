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

    self.dayLabel.text = _model.day;
    
    // Defalut setting
    {
        self.dayLabel.textColor = [UIColor darkGrayColor];
        self.dayLabel.alpha = 1;
        self.dayLabel.layer.masksToBounds = YES;
        self.dayLabel.layer.cornerRadius = 0;
        self.dayLabel.layer.borderWidth = 0;
        self.dayLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.dayLabel.backgroundColor = [UIColor whiteColor];
        //self.dayLabel.clipsToBounds = YES;
    }
    
    // Check weekend
    if (_model.weekDay == 0) {
        // 星期天
        self.dayLabel.textColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1];
    }
    
    if (_model.weekDay == 6) {
        // 星期六
        self.dayLabel.textColor = [UIColor colorWith8BitRed:36 green:176 blue:208 alpha:1];
    }
    
    if (!_model.isInCurrentMonth) {
        self.dayLabel.alpha = 0.2;
    }
    
    if (_model.isInCurrentMonth && _model.isEventDay) {
        self.dayLabel.layer.cornerRadius = self.dayLabel.height / 2;
        self.dayLabel.layer.borderWidth = 1;
        self.dayLabel.layer.borderColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1].CGColor;
    }
    
    if (_model.isInCurrentMonth && ( _model.isSelected || (!self.disableToday && _model.isToday) ) ) {
        self.dayLabel.layer.cornerRadius = self.dayLabel.height / 2;
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.backgroundColor = [UIColor colorWith8BitRed:238 green:41 blue:118 alpha:1];
    }

}


-(UILabel *)dayLabel{
    if (!_dayLabel) {
        
        // Build
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_dayLabel];
        
        // Constraints
        [_dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_dayLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_dayLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:24];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_dayLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:24];
        
        [self addConstraints:[NSArray arrayWithObjects:centerXConstraint,centerYConstraint,widthConstraint,heightConstraint,nil]];
        
        [self layoutIfNeeded];
        
    }
    return _dayLabel;
}

@end
