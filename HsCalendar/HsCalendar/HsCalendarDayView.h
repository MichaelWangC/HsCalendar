//
//  HsCalendarDayView.h
//  HsCalendar
//
//  Created by wangc on 16/4/19.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHsCalendarDaySelected @"kHsCalendarDaySelected"
#define kHsCalendarDayHaveEvent @"kHsCalendarDayHaveEvent"

@interface HsCalendarDayView : UIView

@property (nonatomic, strong) NSDate *currentDate;
@property (assign, nonatomic) BOOL isOtherMonth;
@property (nonatomic, assign) BOOL isWeekMode;

+(void)setSelectedDate:(NSDate *)date;

@end
