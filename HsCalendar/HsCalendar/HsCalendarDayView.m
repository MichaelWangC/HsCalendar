//
//  HsCalendarDayView.m
//  HsCalendar
//
//  Created by wangc on 16/4/19.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCalendarDayView.h"
#import "HsCalendar.h"
#import "HsCircleView.h"

#define kDayCircleColor [UIColor clearColor]
#define kDayCircleColorToday [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5]
#define kDayCircleColorSelected [UIColor redColor]

#define kDayTextColor [UIColor blackColor]
#define kDayTextColorToday [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5]
#define kDayTextColorSelected [UIColor whiteColor]
#define kDayTextColorOtherMonth [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.]

#define kDotViewColor [UIColor colorWithRed:43./256. green:88./256. blue:134./256. alpha:1.]
#define kDotViewColorToday [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5]
#define kDotViewColorSelected [UIColor whiteColor]
#define kDotViewColorOhterMonth [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.]

static NSDate *selectedDate;

@implementation HsCalendarDayView{
    UILabel *textLabel;
    HsCircleView *circleView;
    HsCircleView *dotView;
    
    BOOL isSelected;
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:COLOR_VIEW_BG];
        [self viewInit];
    }
    return self;
}

-(void)viewInit{
    circleView = [HsCircleView new];
    [self addSubview:circleView];
    
    textLabel = [[UILabel alloc] init];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    
    dotView = [[HsCircleView alloc] init];
    dotView.hidden = YES;
    [self addSubview:dotView];
    
    //点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
    //选中后 通知HsCalendar选中日期 和 取消其他已选中dayView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kHsCalendarDaySelected object:nil];
    //日期存在事件 显示隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHaveEvent:) name:kHsCalendarDayHaveEvent object:nil];
}

-(void)layoutSubviews{
    if (_viewWidth != self.frame.size.width || _viewHeight != self.frame.size.height) {
        _viewWidth = self.frame.size.width;
        _viewHeight = self.frame.size.height;
        textLabel.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        
        CGFloat sizeCircle = MIN(_viewWidth, _viewHeight);
        sizeCircle = roundf(sizeCircle);
        circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
        circleView.center = CGPointMake(_viewWidth / 2., _viewHeight / 2.);
        circleView.layer.cornerRadius = sizeCircle / 2.;
        
        CGFloat sizeDot = MIN(_viewWidth, _viewHeight)/9.0;
        sizeDot = roundf(sizeDot);
        dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
        dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sizeDot * 2.5);
        dotView.layer.cornerRadius = sizeDot / 2.;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    
    NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [HsCalendar calendar].timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    textLabel.text = [dateFormatter stringFromDate:currentDate];
    
    if([self isSameDate:selectedDate withOhterDate:self.currentDate]){
        if(!isSelected){
            [self setSelected:YES animated:NO];
        }
    }else if(isSelected){
        [self setSelected:NO animated:NO];
    }else{
        [self setDayViewColor];
    }
}

#pragma mark 样式、颜色设置
-(void)setDayViewColor{
    if ([self isToday]) {
        [circleView setIsStroke:YES];
        [circleView setColor:kDayCircleColorToday];
        [textLabel setTextColor:kDayTextColorToday];
        [dotView setColor:kDotViewColorToday];
    }else if (_isOtherMonth && !_isWeekMode){
        [circleView setColor:kDayCircleColor];
        [textLabel setTextColor:kDayTextColorOtherMonth];
        [dotView setColor:kDotViewColorOhterMonth];
    }else{
        [circleView setColor:kDayCircleColor];
        [textLabel setTextColor:kDayTextColor];
        [dotView setColor:kDotViewColor];
    }
    if (isSelected && (!_isOtherMonth || _isWeekMode)) {
        [circleView setIsStroke:NO];
        [circleView setColor:kDayCircleColorSelected];
        [textLabel setTextColor:kDayTextColorSelected];
        [dotView setColor:kDotViewColorSelected];
    }
}

#pragma mark 点击事件
-(void)didTouch{
    [self setSelected:YES animated:YES];
    selectedDate = _currentDate;
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kHsCalendarDaySelected object:self.currentDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (isSelected == selected) animated = NO;
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    [self setDayViewColor];
    if(selected){
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}

#pragma mark
-(void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected withOhterDate:self.currentDate]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

-(void)didHaveEvent:(NSNotification *)notification{
    NSArray<NSDate *> *dates = [notification object];
    BOOL haveEvent = NO;
    for (NSDate *date in dates) {
        if ([self isSameDate:date withOhterDate:_currentDate]) {
            haveEvent = YES;
            break;
        }
    }
    if (haveEvent) {
        dotView.hidden = NO;
    }else{
        dotView.hidden = YES;
    }
}

-(BOOL)isToday
{
    if([self isSameDate:[NSDate date] withOhterDate:self.currentDate]){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isSameDate:(NSDate *)date withOhterDate:(NSDate *)otherdate
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [HsCalendar calendar].timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    NSString *dateText = [dateFormatter stringFromDate:otherdate];
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([dateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

+(void)setSelectedDate:(NSDate *)date{
    selectedDate = date;
}

@end
