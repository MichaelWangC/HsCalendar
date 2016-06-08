//
//  NormalController.m
//  HsCalendar
//
//  Created by hundsun_mobile on 16/4/20.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "NormalController.h"
#import "HsCalendar.h"

@interface NormalController ()<HsCalendarDelegate,HsCalendarDataSource>{
    HsCalendar *calendar;
    UILabel *textYearAndMonth;
}

@end

@implementation NormalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    calendar = [[HsCalendar alloc] init];
    calendar.delegate = self;
    calendar.dataSource = self;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [calendar setCurrentDate:[formatter dateFromString:@"2016-4-14"]];
    [HsCalendar calendar].firstWeekday = 2;
    [self.view addSubview:calendar];
    [self setViewConstraint];
    
    textYearAndMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    textYearAndMonth.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:textYearAndMonth];
}

-(NSArray<NSDate *> *)calendarHaveEvent:(HsCalendar *)calendar{
    return @[[NSDate date],[NSDate dateWithTimeIntervalSinceNow:-1*24*60*60],[NSDate dateWithTimeIntervalSinceNow:-8*24*60*60]];
}

-(void)calendarCurrentYear:(NSUInteger)year andMonth:(NSUInteger)month{
    textYearAndMonth.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    
}

-(void)calendarDidSelectedDate:(NSDate *)selectedDate{
    NSLog(@"%@",selectedDate);
}

-(void)setViewConstraint{
    [calendar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendar
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendar
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:300]];
}

@end
