//
//  HsCalendarMonthWeekDaysView.h
//  HsCalendar
//
//  Created by wangc on 16/4/19.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HsCalendarWeekView : UIView

@property (nonatomic, strong) NSDate *currentDate;
@property (assign, nonatomic) NSUInteger currentMonthIndex;

@property (nonatomic, strong, readonly) NSDate *weekFirstDate;
@property (nonatomic, strong, readonly) NSDate *weekLastDate;

@property (nonatomic, assign) BOOL isWeekMode;

@end
