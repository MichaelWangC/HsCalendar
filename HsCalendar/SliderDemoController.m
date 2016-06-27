//
//  SliderDemoController.m
//  HsCalendar
//
//  Created by hundsun_mobile on 16/4/20.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "SliderDemoController.h"
#import "HsCalendar.h"

@interface SliderDemoController ()<UITableViewDataSource,UITableViewDelegate,HsCalendarDelegate,HsCalendarDataSource>{
    UITableView *tableview;
    UIView *contentview;
    NSLayoutConstraint *topConstraint;
    HsCalendar *calendar;
    UILabel *textYearAndMonth;
    
    float topValue;
    float currentTopConstraintConstant;
    float tableScrollDownOffsetY;
    float isTableScrollDownChange;
}

@end

@implementation SliderDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    topValue = 300;
    currentTopConstraintConstant = topValue;//tableview 距离顶部的高度
    tableScrollDownOffsetY = 0;
    
    calendar = [[HsCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topValue)];
    calendar.delegate = self;
    calendar.dataSource = self;
    calendar.isWeekMode = YES;
    [HsCalendar calendar].firstWeekday = 2;
    [self.view addSubview:calendar];
    
    contentview = [[UIView alloc] init];
    [contentview setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:contentview];
    [self setViewConstraint:contentview];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    [contentview addSubview:tableview];
    [self setTableViewConstraint];
    
    UIPanGestureRecognizer* scrollPanGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    scrollPanGR.maximumNumberOfTouches=1;
    scrollPanGR.minimumNumberOfTouches=1;
    [contentview addGestureRecognizer:scrollPanGR];
    
    textYearAndMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    textYearAndMonth.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:textYearAndMonth];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view layoutIfNeeded];
}

-(NSArray<NSDate *> *)calendarHaveEvent:(HsCalendar *)calendar{
    return @[[NSDate date],[NSDate dateWithTimeIntervalSinceNow:-1*24*60*60],[NSDate dateWithTimeIntervalSinceNow:-8*24*60*60]];
}

-(void)calendarCurrentYear:(NSUInteger)year andMonth:(NSUInteger)month{
    textYearAndMonth.text = [NSString stringWithFormat:@"%d年%d月",year,month];
//    NSLog(@"%@===%@",calendar.visibleFirstDate,calendar.visibleLastDate);
}

-(void)handlePan:(UIPanGestureRecognizer*)gesRec{
    CGPoint offset = [gesRec translationInView:contentview];
    NSLog(@"===%f===",offset.y);
    [calendar setCalendarScrollY:offset.y];
    
    if (gesRec.state == UIGestureRecognizerStateChanged) {
        topConstraint.constant = currentTopConstraintConstant + offset.y;
        [self.view layoutIfNeeded];
        
        if (topConstraint.constant < [calendar calendarHeightWhenInWeekMode]) {//两个日历week的高度  周模式下的日历高度
            topConstraint.constant = [calendar calendarHeightWhenInWeekMode];
            tableview.scrollEnabled = YES;
        }
        if (topConstraint.constant > topValue) {
            topConstraint.constant = topValue;
            tableview.scrollEnabled = NO;
            [tableview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    if (gesRec.state == UIGestureRecognizerStateEnded) {
        [self.view setNeedsLayout];
        BOOL isScrollUp = topConstraint.constant-currentTopConstraintConstant<0?YES:NO;
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat toTopConstant = 30;//kHeadViewHeight - (kHeadViewHeight - [_calendar calendarHeightWhenInWeekMode])/3;
            if (isScrollUp) {
                //月切换周
                if (topConstraint.constant < topValue-toTopConstant) {
                    topConstraint.constant = [calendar calendarHeightWhenInWeekMode];
                    tableview.scrollEnabled = YES;
                    [calendar setIsWeekMode:YES];
                }else{
                    topConstraint.constant = topValue;
                    tableview.scrollEnabled = NO;
                    [tableview setContentOffset:CGPointMake(0, 0) animated:YES];
                    [calendar setIsWeekMode:NO];
                }
            }else{
                //周切换月
                if (topConstraint.constant > topValue-[calendar calendarHeightWhenInWeekMode]-toTopConstant) {
                    topConstraint.constant = topValue;
                    tableview.scrollEnabled = NO;
                    [tableview setContentOffset:CGPointMake(0, 0) animated:YES];
                    [calendar setIsWeekMode:NO];
                }else{
                    topConstraint.constant = [calendar calendarHeightWhenInWeekMode];
                    tableview.scrollEnabled = YES;
                    [calendar setIsWeekMode:YES];
                }
            }
            [self.view layoutIfNeeded];
        }];
        currentTopConstraintConstant = topConstraint.constant;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        isTableScrollDownChange = YES;
        tableScrollDownOffsetY += scrollView.contentOffset.y;
        [calendar setCalendarScrollY:-tableScrollDownOffsetY];
        topConstraint.constant -= scrollView.contentOffset.y;
        [self.view layoutIfNeeded];
        if (topConstraint.constant > topValue) {
            topConstraint.constant = topValue;
            tableview.scrollEnabled = NO;
            [tableview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) return;
    [self scrollChangeCalendarMode];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollChangeCalendarMode];
}

-(void)scrollChangeCalendarMode{
    if (isTableScrollDownChange) {
        tableScrollDownOffsetY = 0;
        isTableScrollDownChange = NO;
        
        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.4 animations:^{
            //周切换月
            CGFloat toTopConstant = 30;
            if (topConstraint.constant > topValue-[calendar calendarHeightWhenInWeekMode]-toTopConstant) {
                topConstraint.constant = topValue;
                tableview.scrollEnabled = NO;
                [tableview setContentOffset:CGPointMake(0, 0) animated:YES];
                [calendar setIsWeekMode:NO];
            }else{
                topConstraint.constant = [calendar calendarHeightWhenInWeekMode];
                tableview.scrollEnabled = YES;
                [calendar setIsWeekMode:YES];
            }
            [self.view layoutIfNeeded];
        }];
        currentTopConstraintConstant = topConstraint.constant;
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setViewConstraint:(UIView *)view{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1.0
                                                  constant:[calendar calendarHeightWhenInWeekMode]];
    [self.view addConstraint:topConstraint];
    currentTopConstraintConstant = topConstraint.constant;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}

-(void)setTableViewConstraint{
    [tableview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentview addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentview
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [contentview addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentview
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [contentview addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [contentview addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}


@end
