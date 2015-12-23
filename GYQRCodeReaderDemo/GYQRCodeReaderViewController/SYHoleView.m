//
//  SYHoleView.m
//  Draw
//
//  Created by sy on 14-8-28.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "SYHoleView.h"

@implementation SYHoleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, self.backgroundColor.CGColor );
    CGContextFillRect( context, rect );
    CGRect holeRectIntersection = CGRectIntersection(_holdRect, rect );
    
    if( CGRectIntersectsRect( holeRectIntersection, rect ) )
    {
        CGContextClearRect(context, holeRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, holeRectIntersection);
    }
}


@end
