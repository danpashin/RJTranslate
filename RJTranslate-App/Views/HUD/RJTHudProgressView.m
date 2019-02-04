//
//  RJTHudProgressView.m
//  RJTranslate
//
//  Created by Даниил on 28/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTHudProgressView.h"

@interface RJTHudProgressView ()
@property (nonatomic, readonly, strong) CAShapeLayer *layer;
@end

@implementation RJTHudProgressView
@dynamic layer;

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

+ (instancetype)defaultProgressView
{
    return [[RJTHudProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 66.0f, 66.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat size = (CGRectGetWidth(frame) + CGRectGetHeight(frame)) / 2.0f;
    frame.size = CGSizeMake(size, size);
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat center = size / 2.0f;
        
        CGMutablePathRef mutablePath = CGPathCreateMutable();
        CGPathAddArc(mutablePath, NULL, center, center, center - 8.0f, 0.0f, (CGFloat)(2.0f * M_PI), NO);
        
        self.layer.path = mutablePath;
        CGPathRelease(mutablePath);
        
        self.layer.fillColor = [UIColor clearColor].CGColor;
        self.layer.lineCap = kCALineCapRound;
        self.layer.lineWidth = 3.0f;
        self.layer.strokeEnd = 0.0f;
        
        self.progress = 0.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    self.layer.strokeColor = self.tintColor.CGColor;
}

- (void)startAnimating
{
    _animating = YES;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @0.0f;
    rotateAnimation.toValue = @(M_PI * 2.0f);
    rotateAnimation.duration = 1.75f;
    rotateAnimation.repeatCount = INFINITY;
    [self.layer addAnimation:rotateAnimation forKey:@"rotate"];
}

- (void)stopAnimating
{
    _animating = NO;
    [self.layer removeAllAnimations];
}


- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
    
    if (animated) {
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @(self.layer.strokeEnd);
        strokeEndAnimation.toValue = @(progress);
        strokeEndAnimation.duration = 1.0f;
        [self.layer addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
    }
    
    self.layer.strokeEnd = progress;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self.widthAnchor constraintEqualToConstant:CGRectGetWidth(self.frame)].active = YES;
    
    _cachedHeight = CGRectGetHeight(self.frame);
    _heightConstraint = [self.heightAnchor constraintEqualToConstant:self.cachedHeight];
    self.heightConstraint.active = YES;
}


- (void)applicationDidBecomeActive
{
    if (self.animating)
        [self startAnimating];
}

- (void)applicationDidEnterBackground
{
    [self.layer removeAllAnimations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
