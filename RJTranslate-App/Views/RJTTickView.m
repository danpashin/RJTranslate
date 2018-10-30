//
//  RJTTickView.m
//  RJTranslate
//
//  Created by Даниил on 24/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTTickView.h"
#import "RJTColors.h"

@interface RJTTickView ()
@property(nonatomic,readonly,strong) CAShapeLayer *layer;
@end

@implementation RJTTickView
@dynamic layer;

+ (Class)layerClass
{
    return [CAShapeLayer  class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat maxSide = MAX(frame.size.width, frame.size.height);
    frame.size = CGSizeMake(maxSide, maxSide / 2.0f);
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    self.layer.strokeColor = [RJTColors secondaryColor].CGColor;
    self.layer.fillColor = [UIColor clearColor].CGColor;
    self.layer.strokeEnd = 0.0f;
    self.layer.lineWidth = 2.0f;
    self.layer.lineCap = kCALineCapRound;
    
    CGRect selfRect = self.bounds;
    CGMutablePathRef mutableTickPath = CGPathCreateMutable();
    CGPathMoveToPoint(mutableTickPath, NULL, CGRectGetMaxX(selfRect) / 4.0f, CGRectGetMidY(selfRect));
    CGPathAddLineToPoint(mutableTickPath, NULL, CGRectGetMidX(selfRect), CGRectGetMaxY(selfRect) - 1.0f);
    CGPathAddLineToPoint(mutableTickPath, NULL, CGRectGetMaxX(selfRect) - CGRectGetMidX(selfRect) / 4.0f, CGRectGetMinY(selfRect) + 1.0f);
    self.layer.path = mutableTickPath;
    CGPathRelease(mutableTickPath);
}

- (void)setEnabled:(BOOL)enabled
{
    [self setEnabled:enabled animated:NO];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    if (animated) {
        CABasicAnimation *tickAimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        tickAimation.fromValue = @(self.enabled);
        tickAimation.toValue = @(enabled);
        tickAimation.duration = 0.2f;
        tickAimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.layer addAnimation:tickAimation forKey:@"strokeAnimation"];
        self.layer.strokeEnd = (CGFloat)enabled;
    } else {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.layer.strokeEnd = (CGFloat)enabled;
        [CATransaction commit];
    }
    
    _enabled = enabled;
}

@end
