//
//  HsCircleView.m
//  HsCalendar
//
//  Created by wangc on 16/4/20.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCircleView.h"
#import "HsCircleView.h"

@implementation HsCircleView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
    CGContextFillRect(ctx, rect);
    
    rect = CGRectInset(rect, .5, .5);
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextFillPath(ctx);
}

- (void)setColor:(UIColor *)color
{
    if (!CGColorEqualToColor(_color.CGColor, color.CGColor)) {
        _color = color;
        [self setNeedsDisplay];
    }
}

@end
