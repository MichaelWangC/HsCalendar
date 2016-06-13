//
//  HsMonthWeekTitleView.m
//  HsCalendar
//
//  Created by wangc on 16/4/19.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCalendarWeekTitleView.h"
#import "HsCalendar.h"

#define kNumWeekDays 7
#define kTitleColor [UIColor blackColor]

@implementation HsCalendarWeekTitleView{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
}

static NSArray *cacheTitlesOfWeek;

-(instancetype)init{
    self = [super init];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit{
    [self setBackgroundColor:[UIColor clearColor]];
    
    for (int i = 0; i < kNumWeekDays; i++) {
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = kTitleColor;
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];
    }
    
}

- (NSArray *)daysOfWeek
{
    if (cacheTitlesOfWeek) {
        return cacheTitlesOfWeek;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSMutableArray *days = [[dateFormatter veryShortWeekdaySymbols] mutableCopy];
    
    // Redorder days for be conform to calendar
    {
        NSCalendar *calendar = [HsCalendar calendar];
        NSUInteger firstWeekday = (calendar.firstWeekday + 6) % 7; // Sunday == 1, Saturday == 7
        
        for(int i = 0; i < firstWeekday; ++i){
            id day = [days firstObject];
            [days removeObjectAtIndex:0];
            [days addObject:day];
        }
    }
    
    cacheTitlesOfWeek = days;
    return cacheTitlesOfWeek;
}

- (void)layoutSubviews
{
    if (_viewWidth != self.frame.size.width || _viewHeight != self.frame.size.height) {
        CGFloat x = 0;
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        CGFloat width = (float)_viewWidth / kNumWeekDays;
        
        int i = 0;
        for(NSString *day in [self daysOfWeek]){
            UILabel *view = [self.subviews objectAtIndex:i];
            view.text = day;
            view.frame = CGRectMake(x, 0, width, _viewHeight);
            x = CGRectGetMaxX(view.frame);
            i ++;
        }
    }

    [super layoutSubviews];
}


@end
