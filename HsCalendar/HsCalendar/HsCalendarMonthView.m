//
//  HsCalendarMonthView.m
//  HsCalendar
//
//  Created by wangc on 16/4/18.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCalendarMonthView.h"
#import "HsCalendarWeekView.h"
#import "HsCalendarWeekTitleView.h"
#import "HsCalendar.h"

#define WEEKS_TO_DISPLAY 6

@implementation HsCaledarMonthView{
    NSArray *weeksViews;
    HsCalendarWeekTitleView *weektitleView;
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:COLOR_VIEW_BG];
        [self viewInit];
    }
    
    return  self;
}

-(void) viewInit{
    NSMutableArray *views = [NSMutableArray new];
    
    for(int i = 0; i < WEEKS_TO_DISPLAY; ++i){
        UIView *view = [HsCalendarWeekView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    weeksViews = views;
    
    weektitleView = [HsCalendarWeekTitleView new];
    [self addSubview:weektitleView];
}

-(void)layoutSubviews{
    [self configureConstraintsForSubviews];
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    if (_viewWidth != self.frame.size.width || _viewHeight != self.frame.size.height) {
        CGFloat weeksToDisplay;
        
        weeksToDisplay = (CGFloat)(WEEKS_TO_DISPLAY + 1); // + 1 for weekTitle
        
        CGFloat y = 0;
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        CGFloat height = self.frame.size.height / weeksToDisplay;
        
        weektitleView.frame = CGRectMake(0, y, _viewWidth, height);
        
        y = CGRectGetMaxY(weektitleView.frame);
        for (UIView *view in weeksViews) {
            view.frame = CGRectMake(0, y, _viewWidth, height);
            y = CGRectGetMaxY(view.frame);
        }
    }
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    
    NSCalendar *calendar = [HsCalendar calendar];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSUInteger currentMonthIndex = comps.month;
    
    // Hack
    if(comps.day > 7){
        currentMonthIndex = (currentMonthIndex % 12) + 1;
    }
    
    for (HsCalendarWeekView *weekView in weeksViews) {
        [weekView setIsWeekMode:_isWeekMode];
        [weekView setCurrentMonthIndex:currentMonthIndex];
        [weekView setCurrentDate:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        
    }
}

-(NSArray *)weekViews{
    return weeksViews;
}

@end
