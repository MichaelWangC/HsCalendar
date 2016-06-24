//
//  SliderDemoHeadViewContriller.m
//  HsCalendar
//
//  Created by 王超 on 16/6/22.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "SliderDemoHeadViewContriller.h"
#import "HsCalendar.h"

@interface SliderDemoHeadViewContriller ()<UITableViewDelegate,UITableViewDataSource,HsCalendarDelegate,HsCalendarDataSource>

@end

@implementation SliderDemoHeadViewContriller{
    UITableView *tableview;
    HsCalendar *calendar;
    UIView *contentview;
    NSLayoutConstraint *topConstraint;
    UILabel *textYearAndMonth;
    
    float calendarHeight;
    float tableContentOffsetY;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    calendarHeight = 300;
    
    calendar = [[HsCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, calendarHeight)];
    calendar.delegate = self;
    calendar.dataSource = self;
    calendar.isWeekMode = YES;
    [HsCalendar calendar].firstWeekday = 2;
    [self.view addSubview:calendar];

    tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.contentInset = UIEdgeInsetsMake(calendarHeight - [calendar calendarHeightWhenInWeekMode], 0, 0, 0);
    [self.view addSubview:tableview];
    [self setTableViewConstraint];
    tableContentOffsetY = tableview.contentOffset.y;
    
    textYearAndMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    textYearAndMonth.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:textYearAndMonth];
}

-(NSArray<NSDate *> *)calendarHaveEvent:(HsCalendar *)calendar{
    return @[[NSDate date],[NSDate dateWithTimeIntervalSinceNow:-1*24*60*60],[NSDate dateWithTimeIntervalSinceNow:-8*24*60*60]];
}

-(void)calendarCurrentYear:(NSUInteger)year andMonth:(NSUInteger)month{
    textYearAndMonth.text = [NSString stringWithFormat:@"%d年%d月",year,month];
    //    NSLog(@"%@===%@",calendar.visibleFirstDate,calendar.visibleLastDate);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!calendar.isWeekMode) [self.view bringSubviewToFront:tableview];
    float changeY = tableContentOffsetY-scrollView.contentOffset.y;
    NSLog(@"===%f===%f",scrollView.contentOffset.y,tableContentOffsetY);
    [calendar setCalendarScrollY:changeY];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    if (decelerate) {
        return;
    }
    [self scrollCalendar];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    [self scrollCalendar];
}

-(void)scrollCalendar{
    float changeY = tableContentOffsetY - tableview.contentOffset.y;
//    fabs(changeY) > 40
    if (changeY > 0) {
        //向下滑动
        if (tableview.contentOffset.y > -calendarHeight) {
            tableContentOffsetY = [calendar calendarHeightWhenInWeekMode] - calendarHeight;
            
            [UIView animateWithDuration:0.5 animations:^{
                tableview.contentOffset = CGPointMake(0, tableContentOffsetY);
            } completion:^(BOOL finished) {
                [self.view bringSubviewToFront:calendar];
            }];
            calendar.isWeekMode = NO;
        }
    }else{
        //向上滑动
        if (tableview.contentOffset.y < 0) {
            tableContentOffsetY = 0;
            [UIView animateWithDuration:0.5 animations:^{
                tableview.contentOffset = CGPointMake(0, tableContentOffsetY);
            }];
            calendar.isWeekMode = YES;
        }
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

-(void)setTableViewConstraint{
    [tableview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:[calendar calendarHeightWhenInWeekMode]]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableview
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:0]];
}

@end
