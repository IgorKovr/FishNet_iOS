//
//  DrawView.m
//  Fish2D
//
//  Created by Igor Kovrizhkin on 5/28/13.
//  Copyright (c) 2013 kovrizhkin. All rights reserved.
//

#import "DrawView.h"

#define GateBarWidth 20

@implementation DrawView

#pragma mark - Drawing

- (void)drawNet {
    int i, k;
    for(i=0;i<YDots;i++){          // Draw Horizontal Lines
		for(k=0;k<XDots-1;k++){
            [self drawLineFrom:g_DotNet[k][i] to:g_DotNet[k+1][i]];
        }
	}
    
    for(i=0;i<YDots-1;i++){          // Draw Vertical Lines
		for(k=0;k<XDots;k++){
            [self drawLineFrom:g_DotNet[k][i] to:g_DotNet[k][i+1]];
        }
    }
    
    for(i=0;i<YDots;i++){          // Draw Points
		for(k=0;k<XDots;k++){
            [self drawPointAt:g_DotNet[k][i]];
        }
    }
}

# pragma - mark Context Graphic Methods

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0);
    curCGcontext = context;
    [self drawNet];
}

#pragma mark - Quartz Functions

- (void)addLineToPoint:(CGPoint)line {
    CGContextAddLineToPoint(curCGcontext, line.x, line.y);
}

- (void)commitLineDraw {
    CGContextStrokePath(curCGcontext);
}

- (void)DrawGateRect:(CGRect)gateRect {
    gateRect = CGRectMake(150, 20, 500, 400);
    
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 1.0, 0.0 };
    CGFloat components[8] =	{ 0.2, 0.2, 0.2, 1.0,    1.0, 1.0, 1.0, 1.0 };
    
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    
    CGPoint myStartPoint;
    
    myStartPoint.x = gateRect.origin.x;
    myStartPoint.y = gateRect.origin.y;
    //Top  Bar
    CGRect topBarRect = CGRectMake(gateRect.origin.x, gateRect.origin.y, gateRect.size.width, GateBarWidth);
    //Left Bar
    CGRect leftBarRect = CGRectMake(gateRect.origin.x, gateRect.origin.y, GateBarWidth, gateRect.size.height);
    //Right Bar
    CGRect rightBarRect = CGRectMake(gateRect.origin.x+gateRect.size.width-GateBarWidth, gateRect.origin.y, GateBarWidth, gateRect.size.height);
    
    CGContextSaveGState(curCGcontext);
    CGContextAddRect(curCGcontext, leftBarRect);
    CGContextClip(curCGcontext);
    CGContextDrawLinearGradient (curCGcontext, myGradient, myStartPoint, CGPointMake(myStartPoint.x+GateBarWidth, myStartPoint.y), kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(curCGcontext);
    
    
    CGContextSaveGState(curCGcontext);
    CGContextAddRect(curCGcontext, topBarRect);
    CGContextClip(curCGcontext);
    CGContextDrawLinearGradient (curCGcontext, myGradient, myStartPoint, CGPointMake(myStartPoint.x, myStartPoint.y+GateBarWidth), kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(curCGcontext);

    CGContextSaveGState(curCGcontext);
    CGContextAddRect(curCGcontext, rightBarRect);
    CGContextClip(curCGcontext);
    CGContextDrawLinearGradient (curCGcontext, myGradient, CGPointMake(gateRect.origin.x+gateRect.size.width-GateBarWidth, gateRect.origin.y), CGPointMake(gateRect.origin.x+gateRect.size.width, gateRect.origin.y), kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(curCGcontext);
}

- (void)drawLineFrom:(CGPoint)line1 to:(CGPoint)line2 {
    // Set Shadow
    CGSize          myShadowOffset = CGSizeMake (-15,  20);// 2
    CGContextSaveGState(curCGcontext);// 6
    CGContextSetShadow (curCGcontext, myShadowOffset, 5); // 7
    //   Shadow
    CGContextSetRGBStrokeColor(curCGcontext, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(curCGcontext, 2.0);
	CGContextMoveToPoint(curCGcontext, line1.x, line1.y);
	CGContextAddLineToPoint(curCGcontext, line2.x, line2.y);
	CGContextStrokePath(curCGcontext);
    // Shadow
     CGContextRestoreGState(curCGcontext);
}

- (void)drawPointAt:(CGPoint)point {
    CGContextSetRGBStrokeColor(curCGcontext, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(curCGcontext, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(curCGcontext, 3.0);
	CGContextMoveToPoint(curCGcontext, point.x, point.y);
    CGContextStrokeEllipseInRect(curCGcontext, CGRectMake(point.x-2, point.y-2, 4, 4));
	CGContextStrokePath(curCGcontext);
}

- (void)drawSequences {
    CGContextRef context=curCGcontext;
    // Draw a connected sequence of line segments
	CGPoint addLines[] =
	{
		CGPointMake(10.0, 90.0),
		CGPointMake(70.0, 60.0),
		CGPointMake(130.0, 90.0),
		CGPointMake(190.0, 60.0),
		CGPointMake(250.0, 90.0),
		CGPointMake(310.0, 60.0),
	};
	// Bulk call to add lines to the current path.
	// Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
	CGContextStrokePath(context);
	
	// Draw a series of line segments. Each pair of points is a segment
	CGPoint strokeSegments[] =
	{
		CGPointMake(10.0, 150.0),
		CGPointMake(70.0, 120.0),
		CGPointMake(130.0, 150.0),
		CGPointMake(190.0, 120.0),
		CGPointMake(250.0, 150.0),
		CGPointMake(310.0, 120.0),
	};
	// Bulk call to stroke a sequence of line segments.
	// Equivalent to for(i=0; i<count; i+=2) { MoveToPoint(point[i]); AddLineToPoint(point[i+1]); StrokePath(); }
	CGContextStrokeLineSegments(context, strokeSegments, sizeof(strokeSegments)/sizeof(strokeSegments[0]));
}

@end
