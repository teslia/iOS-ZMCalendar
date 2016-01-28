//
//  ZMCalendarViewController.m
//  ZMCalendar
//
//  Created by Teslia Akatsuki on 2015/11/10.
//  Copyright © 2015年 http://xloli.net  All rights reserved.
//

#import "ZMCalendarViewController.h"
#import "UIView+ZMExtension.h"
#import "NSDate+ZMExtension.h"
#import "ZMDayCell.h"
#import "ZMCalendarMonthView.h"
#import "ZMDateModel.h"

@interface ZMCalendarViewController () <UIScrollViewDelegate,ZMCalendarMonthViewDataSource,ZMCalendarMonthViewDelegate>

//// Menu ///////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//// Calendar //////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIScrollView *calendarScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actibityIndicator;
@property (strong, nonatomic) ZMCalendarMonthView *leftCalendarView;
@property (strong, nonatomic) ZMCalendarMonthView *centerCalendarView;
@property (strong, nonatomic) ZMCalendarMonthView *rightCalendarView;
///////////////////////////////////////////////////////////////
@property (strong, nonatomic) NSDate *currentDate;

@property (assign,nonatomic) CGFloat beforeOffset;

@end

@implementation ZMCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCurrentDate];
    [self loadStyle];
    
    [self performSelector:@selector(viewWillLoad) withObject:self afterDelay:0.001];
}

-(void)viewWillLoad {
    [self initView];
}

- (void)loadStyle{
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.layer.cornerRadius = _dateLabel.height / 2;
}

- (void)initView{
    
    [self.view layoutIfNeeded];
    
    self.calendarScrollView.contentSize = CGSizeMake(self.view.width * 3, _calendarScrollView.height);
    
    // Make calendar view //////////////
    
    self.leftCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(0, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                            dateModel:[ZMDateModel dateModelWithNSDate:[_currentDate dayInThePreviousMonth]]];
    self.leftCalendarView.disableToday = _disableToday;
    self.leftCalendarView.delegate = self;
    self.leftCalendarView.dataSource = self;
    [self.leftCalendarView initView];
    
    self.centerCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(self.view.width, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                              dateModel:[ZMDateModel dateModelWithNSDate:_currentDate]];
    self.centerCalendarView.disableToday = _disableToday;
    self.centerCalendarView.delegate = self;
    self.centerCalendarView.dataSource = self;
    [self.centerCalendarView initView];
    
    self.rightCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(self.view.width * 2, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                             dateModel:[ZMDateModel dateModelWithNSDate:[_currentDate dayInTheFollowingMonth]]];
    self.rightCalendarView.disableToday = _disableToday;
    self.rightCalendarView.delegate = self;
    self.rightCalendarView.dataSource = self;
    [self.rightCalendarView initView];
    
    //////////////////////////////////
    
    if (self.minDate && [NSDate date:[self.minDate getNSDate] isTheSameMonthThan:_currentDate]) {
        // 回滚到最左
        self.leftCalendarView.model = [ZMDateModel dateModelWithNSDate:_currentDate];
        self.centerCalendarView.model = [ZMDateModel dateModelWithNSDate:[_currentDate dayInTheFollowingMonth]];
    }else{
        // 设定初始位置到中央
        [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width, 0)];
    }

    [self.calendarScrollView addSubview:_leftCalendarView];
    [self.calendarScrollView addSubview:_centerCalendarView];
    [self.calendarScrollView addSubview:_rightCalendarView];
    
    
    self.beforeOffset = self.calendarScrollView.contentOffset.x;
    [self.actibityIndicator removeFromSuperview];
}

- (void)nextMonth{
    // 位置交换
    CGRect rightFrame = _rightCalendarView.frame;
    _rightCalendarView.frame = _centerCalendarView.frame;
    _centerCalendarView.frame = rightFrame;
    
    // 变量交换
    ZMCalendarMonthView *tempView = _centerCalendarView;
    self.centerCalendarView = _rightCalendarView;
    self.rightCalendarView = tempView;
    
    // 更新当前选中日期
    self.currentDate = [_currentDate dayInTheFollowingMonth];
    
    //更新左右两侧数据
    [self refrashCalendarData];
}

-(void)previousMonth{
    // 位置交换
    CGRect leftFrame = _leftCalendarView.frame;
    _leftCalendarView.frame = _centerCalendarView.frame;
    _centerCalendarView.frame = leftFrame;
    
    // 变量交换
    ZMCalendarMonthView *tempView = _centerCalendarView;
    self.centerCalendarView = _leftCalendarView;
    self.leftCalendarView = tempView;
    
    // 更新当前选中日期
    self.currentDate = [_currentDate dayInThePreviousMonth];
    
    //更新左右两侧数据
    [self refrashCalendarData];
}

-(void)refrashCurrentCalendarData{
    self.centerCalendarView.model = [ZMDateModel dateModelWithNSDate:_currentDate];
}

-(void)refrashCalendarData{
    self.leftCalendarView.model = [ZMDateModel dateModelWithNSDate:[_currentDate dayInThePreviousMonth]];
    self.rightCalendarView.model = [ZMDateModel dateModelWithNSDate:[_currentDate dayInTheFollowingMonth]];
}


-(void)initCurrentDate{
    NSDate *today = [NSDate date];
    
    if (self.minDate && [NSDate date:today isEqualOrBefore:[self.minDate getNSDate]]) {
        
        self.currentDate = [self.minDate getNSDate];
    }else if (self.maxDate && [NSDate date:today isEqualOrAfter:[self.maxDate getNSDate]]){
        
        self.currentDate = [self.maxDate getNSDate];
    }else{
        
        self.currentDate = today;
    }
    
    [self loadDateLabel];
    [self calendarMonthDidChanged];
}

-(void)loadDateLabel{
    NSString *dateStr = [_currentDate stringFromDate:_currentDate];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ 年 %ld 月",dateArr[0],((NSString *)dateArr[1]).integerValue];
}

-(void)removeSelectedTag{
    [self.leftCalendarView removeAllSelected];
    [self.centerCalendarView removeAllSelected];
    [self.rightCalendarView removeAllSelected];
}

-(void)setCanDisplayToday:(BOOL)canDisplay{
    self.leftCalendarView.disableToday = !canDisplay;
    self.centerCalendarView.disableToday = !canDisplay;
    self.rightCalendarView.disableToday = !canDisplay;
}

#pragma mark - Actions
- (IBAction)nextButtonAction:(id)sender {
    [self lockButton];
    [self next];
}
- (IBAction)previousButtonAction:(id)sender {
    [self lockButton];
    [self previous];
}

#pragma mark - Public methond

-(void)reload{
    [self.centerCalendarView reloadAll];
}

- (void)reloadLeftRight{
    [self.rightCalendarView reloadAll];
    [self.leftCalendarView reloadAll];
}

- (void)next{
    if (!_calendarScrollView.isDecelerating) {
        [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width * 2,0) animated:NO];
        [self scrollViewDidEndDecelerating:_calendarScrollView];
    }
}

- (void)previous{
    if (!_calendarScrollView.isDecelerating) {
        [self.calendarScrollView setContentOffset:CGPointZero animated:NO];
        [self scrollViewDidEndDecelerating:_calendarScrollView];
    }
}

- (void)today{
    [self setCanDisplayToday:YES];
    [self removeSelectedTag];
    [self initCurrentDate];
    [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width, 0) animated:YES];
    [self refrashCurrentCalendarData];
    [self refrashCalendarData];
}

-(void)lockButton{
    self.preButton.enabled = NO;
    self.nextButton.enabled = NO;
    [self performSelector:@selector(unlockButton) withObject:self afterDelay:0.3];
}

-(void)unlockButton{
    self.preButton.enabled = YES;
    self.nextButton.enabled = YES;
}

#pragma mark - Private

// Check min date
-(BOOL)_canPrevious:(BOOL)isLeft{
    if (self.minDate &&
        isLeft &
        [NSDate date:[_currentDate dayInThePreviousMonth] isEqualOrBefore:[self.minDate getNSDate]]){
        
        self.currentDate = [self.minDate getNSDate];
        
        return NO;
    }
    return YES;
}

// Check max date
-(BOOL)_canNext:(BOOL)isRight{
    if (self.maxDate &&
        isRight&&
        [NSDate date:[_currentDate dayInTheFollowingMonth] isEqualOrAfter:[self.maxDate getNSDate]]){
        
        self.currentDate = [self.maxDate getNSDate];
        
        return NO;
    }
    return YES;
}

#pragma mark - Datasouce / Delegate

-(void)calendarLoadDayCell:(ZMDayCell *)dayCell dateModel:(ZMDateModel *)dateModel{
    // 对应： -(void)calendarLoadDayCell:(ZMDayCell *)dayCell dateModel:(ZMDateModel *)dateModel;
    if (self.dataSource) {
        [self.dataSource calendarLoadDayCell:dayCell dateModel:dateModel];
    }
}

-(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell{
    // 对应： -(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell;
    [self setCanDisplayToday:NO];
    if (self.delegate) {
        [self.delegate calendarDayDidSelected:dateModel dayCell:dayCell];
        [self.centerCalendarView reloadAll];
    }
}

-(void)calendarMonthDidChanged{
    if (self.delegate) {
        [self.delegate calendarMonthDidChanged:_currentDate];
    }
}


#pragma mark - ScrollView delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isScrolling = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_isScrolling) {
        scrollView.contentOffset = CGPointMake(_beforeOffset, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL right = scrollView.contentOffset.x > _beforeOffset;
    BOOL left = scrollView.contentOffset.x < _beforeOffset;
    
    // 滚动到底反弹，不做任何处理。
    if (right == left) {
        self.isScrolling = NO;
        return;
    }
    
    // 从最大或者最小值滚动，仅更新DateLabel。
    if (_beforeOffset == scrollView.width * 2 ||
        _beforeOffset == 0) {
        
        if (right) {
            self.currentDate = [_currentDate dayInTheFollowingMonth];
        }
        
        if (left) {
            self.currentDate = [_currentDate dayInThePreviousMonth];
        }
        
        [self loadDateLabel];
        [_centerCalendarView reloadAll];
        self.isScrolling = NO;
        _beforeOffset = scrollView.width;
        return;
    }
    
    if (![self _canPrevious:left] ||
        ![self _canNext:right]) {
        
        self.isScrolling = NO;
        self.beforeOffset = scrollView.contentOffset.x;
        [self loadDateLabel];
        [self reload];
        [self calendarMonthDidChanged];
        return;
    }
    
    if (right) {
        [self nextMonth];
    }else if (left){
        [self previousMonth];
    }
    
    
    [scrollView setContentOffset:CGPointMake(scrollView.width, 0)];
    
    [self loadDateLabel];
    [self calendarMonthDidChanged];
    
    self.isScrolling = NO;
    self.beforeOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
