//
//  circleView.m
//  Igothere
//
//  Created by CRW on 9/30/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "circleView.h"

@implementation circleView
@synthesize canDraw;

- (void)drawRect:(CGRect)rect {
    if (canDraw == YES) {
        // The color is by this line CGContextSetRGBFillColor( context , red , green , blue , alpha);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        // Draw a circle (filled)
        CGContextFillEllipseInRect(contextRef, CGRectMake(0, 0, 25, 25));
        CGContextSetRGBFillColor(contextRef, 0, 0, 255, 1.0);
        
        // Draw a circle (border only)
     //   CGContextStrokeEllipseInRect(contextRef, CGRectMake(100, 200, 25, 25));
     //   CGContextSetRGBFillColor(contextRef, 0, 0, 255, 1.0);
    }
}

@end
