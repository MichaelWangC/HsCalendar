//
//  HsCalendarMonthView.h
//  HsCalendar
//
//  Created by wangc on 16/4/18.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HsCaledarMonthView : UIView

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) float scrollOffsetY;
@property (nonatomic, assign) BOOL isWeekMode;

-(NSArray *)weekViews;

@end
