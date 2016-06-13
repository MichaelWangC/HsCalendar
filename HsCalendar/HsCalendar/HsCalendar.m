//
//  HsCanlendar.m
//  HsCalendar
//
//  Created by wangc on 16/4/18.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCalendar.h"
#import "HsCalendarMonthView.h"
#import "HsCalendarDayView.h"

#define NUMBER_PAGES_LOADED 3

@interface HsCalendar ()<UIScrollViewDelegate>{
    NSMutableArray *_visibleViews;//可见的view
    UIScrollView *_calendarView;
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _viewHeightWhenInWeekMode;
    NSInteger _currentIndex;
    
    NSDate *selectedNextOrPreMonthDay;
}

@end

@implementation HsCalendar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
        _currentDate = [NSDate date];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self viewInit];
        _currentDate = [NSDate date];
    }
    return self;
}

-(void) viewInit{
    _calendarView = [[UIScrollView alloc] init];
    [_calendarView setBackgroundColor:COLOR_VIEW_BG];
    [_calendarView setDelegate:self];
    [_calendarView setPagingEnabled:YES];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setShowsHorizontalScrollIndicator:NO];
    [_calendarView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_calendarView];
    
    _visibleViews = [NSMutableArray array];
    
    for (int i = 0; i < NUMBER_PAGES_LOADED ; i++) {
        HsCaledarMonthView *monthView = [[HsCaledarMonthView alloc] init];
        [_visibleViews addObject:monthView];
        [_calendarView addSubview:monthView];
    }
    
    //监听选中事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kHsCalendarDaySelected object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_viewWidth != self.frame.size.width || _viewHeight != self.frame.size.height) {
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        
        int i = 0;
        for(UIView *view in _visibleViews){
            CGRect tempRect = self.bounds;
            tempRect.origin.x = _viewWidth * i;
            tempRect.origin.y = 0;
            view.frame = tempRect;
            i++;
        }
        
        _calendarView.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _calendarView.contentSize = CGSizeMake(_viewWidth * NUMBER_PAGES_LOADED, _viewHeight);
        //滚动到中间页
        int midpage = NUMBER_PAGES_LOADED/2;
        [_calendarView scrollRectToVisible:CGRectMake(_viewWidth * midpage, 0, _viewWidth, _viewHeight) animated:YES];//调用 scrollViewDidEndScrollingAnimation
    }
}

-(void)setCurrentMonthDate:(NSDate *)currentDate{
    if (selectedNextOrPreMonthDay != nil) {
        _currentDate = selectedNextOrPreMonthDay;
        selectedNextOrPreMonthDay = nil;
    }else{
        _currentDate = currentDate;
    }
    
    [HsCalendarDayView setSelectedDate:_currentDate];
    [self delegateDidSelectDate:_currentDate];
    
    int i = 0;
    for(HsCaledarMonthView *view in _visibleViews){
        int midpage = NUMBER_PAGES_LOADED/2;
        NSDateComponents *dayComponent = [NSDateComponents new];
        
        dayComponent.month = i - midpage;
        NSDate *currentDate = [[HsCalendar calendar] dateByAddingComponents:dayComponent toDate:_currentDate options:0];
        
        NSDate *beginMonth = [self beginningOfMonth:currentDate];
        [view setCurrentDate:beginMonth];
        
        i++;
    }
    
    //滚动到中间页
    int midpage = NUMBER_PAGES_LOADED/2;
    [_calendarView scrollRectToVisible:CGRectMake(_viewWidth * midpage, 0, _viewWidth, _viewHeight) animated:NO];
}

#pragma mark 开始月份
- (NSDate *)beginningOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [HsCalendar calendar];
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
}

#pragma mark 显示的第一天和最后一天 日期
-(NSDate *)visibleFirstDate{
    NSDate *firstDate = [self beginningOfMonth:_currentDate];
    firstDate = [self getLocalTimeZoneDate:firstDate];
    return firstDate;
}

-(NSDate *)visibleLastDate{
    NSDate *firstDate = [self beginningOfMonth:_currentDate];
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    NSInteger weekDayNum = 7;
    NSInteger weekViewsNum = 6;
    dayComponent.day = weekViewsNum * weekDayNum - 1;
    
    NSDate *lastDate = [[HsCalendar calendar] dateByAddingComponents:dayComponent toDate:firstDate options:0];
    lastDate = [self getLocalTimeZoneDate:lastDate];
    
    return lastDate;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self showCalendar];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self showCalendar];
}

#pragma mark 显示日历
-(void)showCalendar{
    int currentPage = _calendarView.contentOffset.x/_viewWidth;
    
    int midpage = NUMBER_PAGES_LOADED/2;
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    dayComponent.month = currentPage - midpage;
    NSDate *monthDate = [[HsCalendar calendar] dateByAddingComponents:dayComponent toDate:_currentDate options:0];
    [self setCurrentMonthDate:monthDate];
    [self reloadData];
    
    //delegate
    if ([self.delegate respondsToSelector:@selector(calendarCurrentYear:andMonth:)]) {
        NSDateComponents *componentsCurrentDate = [[HsCalendar calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
        [self.delegate calendarCurrentYear:componentsCurrentDate.year andMonth:componentsCurrentDate.month];
    }
}

#pragma mark 点击选择日期
-(void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    NSInteger currentMonthIndex = [self monthIndexForDate:_currentDate];
    NSInteger calendarMonthIndex = [self monthIndexForDate:dateSelected];
    
    if(currentMonthIndex == calendarMonthIndex+1){
        selectedNextOrPreMonthDay = dateSelected;
        [self loadPreviousMonth];
        return;
    }
    if (currentMonthIndex == calendarMonthIndex-1) {
        selectedNextOrPreMonthDay = dateSelected;
        [self loadNextMonth];
        return;
    }
    //本月 不会滚动，此处需返回已选日期
    _currentDate = dateSelected;
    [self delegateDidSelectDate:dateSelected];
}

-(NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = [HsCalendar calendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

#pragma mark 返回代理方法
-(void)delegateDidSelectDate:(NSDate *)dateSelected{
    if ([self.delegate respondsToSelector:@selector(calendarDidSelectedDate:)]) {
//        NSDate *localeDate = [self getLocalTimeZoneDate:dateSelected];
        [self.delegate calendarDidSelectedDate:dateSelected];
    }
}

#pragma mark 日期显示数据重新加载
- (void)reloadData{
    if ([self.dataSource respondsToSelector:@selector(calendarHaveEvent:)]) {
        NSArray *dates = [self.dataSource calendarHaveEvent:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHsCalendarDayHaveEvent object:dates];
    }
}

#pragma 月份跳转
- (void)loadNextMonth
{
    CGRect frame = self.frame;
    frame.origin.x = _viewWidth * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [_calendarView scrollRectToVisible:frame animated:YES];
}

- (void)loadPreviousMonth
{
    CGRect frame = self.frame;
    frame.origin.x = _viewWidth * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [_calendarView scrollRectToVisible:frame animated:YES];
}

#pragma mark 按周显示的模式下的日历高度
-(CGFloat)calendarHeightWhenInWeekMode{
    _viewHeightWhenInWeekMode = _viewHeight / 7 * 2;
    return _viewHeightWhenInWeekMode;
}

#pragma mark 日历高度
-(CGFloat)calendarHeightWhenInNomelMode{
    return _viewHeight;
}

#pragma mark 转换为当前时区 时间
-(NSDate *)getLocalTimeZoneDate:(NSDate *)date{
    NSTimeZone *zone = [HsCalendar calendar].timeZone;
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

#pragma mark 日历
+(NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

@end
