//
//  HsCalendarMonthWeekDaysView.m
//  HsCalendar
//
//  Created by wangc on 16/4/19.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCalendarWeekView.h"
#import "HsCalendar.h"
#import "HsCalendarDayView.h"

@implementation HsCalendarWeekView{
    NSArray *daysViews;
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit{
    NSMutableArray *views = [NSMutableArray new];
    
    for(int i = 0; i < 7; ++i){
        UIView *view = [HsCalendarDayView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    daysViews = views;
}

- (void)layoutSubviews
{
    if (_viewWidth != self.frame.size.width || _viewHeight != self.frame.size.height) {
        CGFloat x = 0;
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        CGFloat width = _viewWidth / 7.;
        
        for(UIView *view in self.subviews){
            view.frame = CGRectMake(x, 0, width, _viewHeight);
            x = CGRectGetMaxX(view.frame);
        }
    }
    
    [super layoutSubviews];
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    for (HsCalendarDayView *dayview in daysViews) {
        NSDateComponents *comps = [[HsCalendar calendar] components:NSCalendarUnitMonth fromDate:currentDate];
        NSInteger monthIndex = comps.month;
        
        dayview.isOtherMonth = monthIndex!=self.currentMonthIndex;
        [dayview setCurrentDate:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 1;
        currentDate = [[HsCalendar calendar] dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
}

@end
