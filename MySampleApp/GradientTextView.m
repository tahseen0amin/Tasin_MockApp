//
//  GradientTextView.m
//  MDAFS
//
//  Created by Taseen Amin on 16/05/2014.
//  Copyright (c) 2014 Taazuh. All rights reserved.
//

#import "GradientTextView.h"

@implementation GradientTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    
}

-(UIColor *)GradientTopColor
{
    return [UIColor colorWithRed:.294f green:.435f blue:.564f alpha:1];
    
}

-(UIColor *)GradientBottomColor
{
    return [UIColor colorWithRed:.250f green:.364f blue:.450f alpha:1];
}

-(void)drawInnerGlow
{
    CALayer *innerGlow = [CALayer layer];
    innerGlow.borderWidth = 1;
    innerGlow.borderColor = [[UIColor whiteColor] CGColor];
    innerGlow.opacity = 0.5;
    
    [self.layer insertSublayer:innerGlow atIndex:2];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // no rounded rect
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12.0]; // NOT ROUNDED CORNERES
    [[UIColor clearColor] setStroke];
    [roundRect stroke];
    
    //draw Shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //
    UIColor *shadowColor = [UIColor colorWithRed:0.250 green:0.250 blue:0.254 alpha:1.0];
    CGSize shadowOffset = CGSizeMake(1.04, 1.04);
    CGFloat shadowBlurRadius = 1.04;
    
    //
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    //Clip the drawing to this rect
    [roundRect addClip];
    
    
    
    // Draw Gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.3, 1.0 };
    UIColor *colorTop = self.GradientTopColor; //[UIColor colorWithRed:.294f green:.435f blue:.564f alpha:1]; //
    UIColor *colorBot = self.GradientBottomColor;  //[UIColor colorWithRed:.250f green:.364f blue:.450f alpha:1]; //
    NSArray *colors = [NSArray arrayWithObjects:(id)[colorTop CGColor], (id)[colorBot CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    
    
    //inner glow
    UIColor *innerGlow = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIBezierPath *innerGlowRect = [UIBezierPath  bezierPathWithRoundedRect: rect cornerRadius: 10.0];
    [innerGlow setStroke];
    //innerGlowRect.lineWidth = 1;
    [innerGlowRect stroke];
    
    
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
}


@end
