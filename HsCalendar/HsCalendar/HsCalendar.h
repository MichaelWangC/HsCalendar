//
//  HsCanlendar.h
//  HsCalendar
//
//  Created by wangc on 16/4/18.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HsCalendarDelegate;
@protocol HsCalendarDataSource;
@interface HsCalendar : UIView

@property (nonatomic, assign) id<HsCalendarDelegate> delegate;
@property (nonatomic, assign) id<HsCalendarDataSource> dataSource;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong, readonly) NSDate *visibleFirstDate;
@property (nonatomic, strong, readonly) NSDate *visibleLastDate;
@property (nonatomic, assign) BOOL isSliderWeekMode;

//日期数据重新加载
- (void)reloadData;

- (void)loadNextMonth;
- (void)loadPreviousMonth;

-(CGFloat)calendarHeightWhenInWeekMode;
-(CGFloat)calendarHeightWhenInNomelMode;

+(NSCalendar *)calendar;

@end


@protocol HsCalendarDelegate <NSObject>

@optional
-(void)calendarDidSelectedDate:(NSDate *)selectedDate;
-(void)calendarCurrentYear:(NSUInteger)year andMonth:(NSUInteger)month;

@end

@protocol HsCalendarDataSource <NSObject>

@optional
-(NSArray<NSDate*> *)calendarHaveEvent:(HsCalendar *)calendar;

@end