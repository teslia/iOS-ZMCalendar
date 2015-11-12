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
@property (strong, nonatomic) ZMCalendarMonthView *leftCalendarView;
@property (strong, nonatomic) ZMCalendarMonthView *centerCalendarView;
@property (strong, nonatomic) ZMCalendarMonthView *rightCalendarView;
///////////////////////////////////////////////////////////////
@property (strong, nonatomic) NSDate *currentDate;

@property (assign,nonatomic) CGFloat beforeOffset;
@property (assign,nonatomic) BOOL isFristRun;
@property (assign,nonatomic) BOOL disableTodayFlag;

@end

@implementation ZMCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFristRun = YES;
    self.beforeOffset = self.view.width;
}

-(void)viewWillAppear:(BOOL)animated {
    if (_isFristRun) {
        [self initView];
        [self loadStyle];
        self.isFristRun = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStyle{
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.layer.cornerRadius = _dateLabel.height / 2;
}

- (void)initView{

    [self.view layoutIfNeeded];
    
    self.calendarScrollView.contentSize = CGSizeMake(self.view.width * 3, _calendarScrollView.height);
    
    [self initCurrentDate];
    
    // Make calendar view //////////////
    
    self.leftCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(0, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                                     dateModel:[ZMDateModel dateModelWithNSDate:[_currentDate dayInThePreviousMonth]]];
    self.leftCalendarView.delegate = self;
    self.leftCalendarView.dataSource = self;
    
    self.centerCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(self.view.width, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                            dateModel:[ZMDateModel dateModelWithNSDate:_currentDate]];
    self.centerCalendarView.delegate = self;
    self.centerCalendarView.dataSource = self;
    
    self.rightCalendarView = [[ZMCalendarMonthView alloc]initWithFrame: CGRectMake(self.view.width * 2, 0, self.view.width, _calendarScrollView.height - _bottomPading)
                                                            dateModel:[ZMDateModel dateModelWithNSDate:[_currentDate dayInTheFollowingMonth]]];
    self.rightCalendarView.delegate = self;
    self.rightCalendarView.dataSource = self;
    
    //////////////////////////////////
    
    [self.calendarScrollView addSubview:_leftCalendarView];
    [self.calendarScrollView addSubview:_centerCalendarView];
    [self.calendarScrollView addSubview:_rightCalendarView];
    
    // 设定初始位置到中央
    [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width, 0)];
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



-(void)refrashCalendarData{
    typeof(self)wself = self;

    wself.leftCalendarView.model = [ZMDateModel dateModelWithNSDate:[_currentDate dayInThePreviousMonth]];
    wself.rightCalendarView.model = [ZMDateModel dateModelWithNSDate:[_currentDate dayInTheFollowingMonth]];
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
    self.dateLabel.text = [NSString stringWithFormat:@"%@ 年 %@ 月",dateArr[0],dateArr[1]];
}

-(void)removeSelectedTag{
    [self.leftCalendarView removeAllSelected];
    [self.centerCalendarView removeAllSelected];
    [self.rightCalendarView removeAllSelected];
}

#pragma mark - Actions
- (IBAction)nextButtonAction:(id)sender {
    [self next];
}
- (IBAction)previousButtonAction:(id)sender {
    [self previous];
}

#pragma mark - Public methond

-(void)reload{

    [self.leftCalendarView reloadAll];

    [self.rightCalendarView reloadAll];

    [self.centerCalendarView reloadAll];
}

- (void)next{
    if (!_calendarScrollView.isDecelerating) {
        [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width * 2,0) animated:YES];
    }
}

- (void)previous{
    if (!_calendarScrollView.isDecelerating) {
        [self.calendarScrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)today{
    self.disableTodayFlag = NO;
    [self.calendarScrollView setContentOffset:CGPointMake(_calendarScrollView.width, 0) animated:YES];
    [self removeSelectedTag];
    [self initCurrentDate];
    [self reload];
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
        dateModel.disableToday = _disableTodayFlag;
        [self.dataSource calendarLoadDayCell:dayCell dateModel:dateModel];
    }
}

-(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell{
    // 对应： -(void)calendarDayDidSelected:(ZMDateModel *)dateModel dayCell:(ZMDayCell *)dayCell;
    if (self.delegate) {

        self.disableTodayFlag = YES;
        
        [self.delegate calendarDayDidSelected:dateModel dayCell:dayCell];
        [self reload];
    }
}

-(void)calendarMonthDidChanged{
    if (self.delegate) {
        [self.delegate calendarMonthDidChanged:_currentDate];
    }
}


#pragma mark - ScrollView delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL right = scrollView.contentOffset.x > _beforeOffset;
    BOOL left = scrollView.contentOffset.x < _beforeOffset;
    
    // 滚动到底反弹，不做任何处理。
    if (right == left) {
        scrollView.userInteractionEnabled = YES;
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
        scrollView.userInteractionEnabled = YES;
        _beforeOffset = scrollView.width;
        return;
    }
    
    if (![self _canPrevious:left] ||
        ![self _canNext:right]) {
        
        scrollView.userInteractionEnabled = YES;
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
    
    scrollView.userInteractionEnabled = YES;
    self.beforeOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
