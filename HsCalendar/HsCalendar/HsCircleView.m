//
//  HsCircleView.m
//  HsCalendar
//
//  Created by wangc on 16/4/20.
//  Copyright © 2016年 hundsun_mobile. All rights reserved.
//

#import "HsCircleView.h"

@implementation HsCircleView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor clearColor];
    self.circleMargin = 0;
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    //绘制圆形 rect设置
    CGRect tmpRect = rect;
    float paddingW = _circleMargin;
    tmpRect.origin.x += paddingW;
    tmpRect.origin.y += paddingW;
    tmpRect.size.height -= paddingW * 2;
    tmpRect.size.width -= paddingW * 2;
    CGContextAddEllipseInRect(ctx, tmpRect);
    
    if (_isStroke) {
        CGContextSetLineWidth(ctx, 1.0);
        CGContextStrokePath(ctx);
    }else{
        CGContextFillPath(ctx);
    }
}

- (void)setColor:(UIColor *)color
{
    if (!CGColorEqualToColor(_color.CGColor, color.CGColor)) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (void)setIsStroke:(BOOL)isStroke{
    if (_isStroke != isStroke) {
        _isStroke = isStroke;
        [self setNeedsDisplay];
    }
}

@end
