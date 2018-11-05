//
//  RJTHud.m
//  RJTranslate
//
//  Created by Даниил on 28/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTHud.h"
#import "RJTHudProgressView.h"

@interface RJTHud ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIVisualEffectView *blurView;

@property (strong, nonatomic) RJTHudProgressView *progressView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) NSLayoutConstraint *textLabelHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *detailTextLabelHeightConstraint;

@property (assign, nonatomic, readonly) CGFloat labelsDefaultHeight;

@end


@implementation RJTHud

static CGFloat const RJTHudContentSize = 140.0f;

+ (instancetype)show
{
    RJTHud *hud = [[RJTHud alloc] init];
    [hud showAnimated:YES];
    hud.progress = 0.75f;
    
    return hud;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _labelsDefaultHeight = 32.0f;
        _blurStyle = UIBlurEffectStyleExtraLight;
        
        self.contentView = [UIView new];
        self.contentView.layer.cornerRadius = 20.0f;
        self.contentView.layer.shadowOpacity = 0.15f;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowRadius = 40.0f;
        self.contentView.layer.shadowOffset = CGSizeZero;
        [self addSubview:self.contentView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurView.layer.masksToBounds = YES;
        self.blurView.layer.cornerRadius = self.contentView.layer.cornerRadius;
        [self.contentView addSubview:self.blurView];
        
        self.progressView = [RJTHudProgressView defaultProgressView];
        self.progressView.tintColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 1;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
        
        self.detailTextLabel = [[UILabel alloc] init];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.progressView, self.textLabel, self.detailTextLabel]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.alignment = UIStackViewAlignmentCenter;
        [self.blurView.contentView addSubview:stackView];
        
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [stackView.centerXAnchor constraintEqualToAnchor:self.blurView.contentView.centerXAnchor].active = YES;
        [stackView.centerYAnchor constraintEqualToAnchor:self.blurView.contentView.centerYAnchor].active = YES;
        
        [self setupConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark Public
#pragma mark -

- (void)showAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        if (animated) {
            self.alpha = 0.0f;
            [keyWindow addSubview:self];
            
            [self animateWithDuration:0.25f animations:^{
                self.alpha = 1.0f;
            } completion:nil];
        } else {
            [keyWindow addSubview:self];
        }
        
        if (self.style == RJTHudStyleSpinner)
            [self.progressView startAnimating];
    });
}

- (void)hideAnimated:(BOOL)animated
{
    [self performOnMainThread:^{
        if (animated) {
            [self animateWithDuration:0.5f animations:^{
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView stopAnimating];
                [self removeFromSuperview];
            }];
        } else {
            [self.progressView stopAnimating];
            [self removeFromSuperview];
        }
    }];
}

- (void)hideAfterDelay:(CGFloat)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAnimated:YES];
    });
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
    
    [self performOnMainThread:^{
        [self.progressView setProgress:progress animated:animated];
    }];
}


#pragma mark -
#pragma mark Private
#pragma mark -

- (void)setupConstraints
{
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    self.widthConstraint = [self.contentView.widthAnchor constraintEqualToConstant:RJTHudContentSize];
    self.widthConstraint.active = YES;
    
    self.heightConstraint = [self.contentView.heightAnchor constraintEqualToConstant:RJTHudContentSize];
    self.heightConstraint.active = YES;
    
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.blurView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.blurView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.blurView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.blurView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    
    self.textLabelHeightConstraint = [self.textLabel.heightAnchor constraintEqualToConstant:0.0];
    self.textLabelHeightConstraint.active = YES;
    
    self.detailTextLabelHeightConstraint = [self.detailTextLabel.heightAnchor constraintEqualToConstant:0.0];
    self.detailTextLabelHeightConstraint.active = YES;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
        [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
        [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
        [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self processText:text forLabel:self.textLabel heightConstraint:self.textLabelHeightConstraint];
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    [self processText:detailText forLabel:self.detailTextLabel heightConstraint:self.detailTextLabelHeightConstraint];
}

- (void)setBlurStyle:(UIBlurEffectStyle)blurStyle
{
    _blurStyle = blurStyle;
    
    [self performOnMainThread:^{
        self.blurView.effect = [UIBlurEffect effectWithStyle:blurStyle];
    }];
}

- (void)setStyle:(RJTHudStyle)style
{
    _style = style;
    
    [self performOnMainThread:^{
        BOOL isSpinnerStyle = (style == RJTHudStyleSpinner);
        
        if (isSpinnerStyle) {
            [self.progressView startAnimating];
            
            self.progressView.heightConstraint.constant = self.progressView.cachedHeight;
            [self updateHudSizeWithCompletion:^{
                [self animateWithDuration:0.2f animations:^{
                    self.progressView.alpha = 1.0f;
                } completion:nil];
            }];
        } else {
            [self animateWithDuration:0.2f animations:^{
                self.progressView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView stopAnimating];
                self.progressView.heightConstraint.constant = 0.0f;
                [self updateHudSizeWithCompletion:nil];
            }];
        }
    }];
}



#pragma mark -

- (void)processText:(NSString *)text forLabel:(UILabel *)label heightConstraint:(NSLayoutConstraint *)heightConstraint
{
    [self performOnMainThread:^{
        CATransition *textTransition = [CATransition animation];
        textTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        textTransition.type = kCATransitionFade;
        textTransition.duration = 0.5f;
        [label.layer addAnimation:textTransition forKey:@"textChangeAnimation"];
        label.text = text;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateHudSizeWithCompletion:nil];
        });
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self updateHudSizeWithCompletion:nil];
}

- (void)updateHudSizeWithCompletion:(void(^)(void))completion
{
    CGSize textSize = [self sizeForText:self.textLabel.text label:self.textLabel];
    CGSize detailTextSize = [self sizeForText:self.detailTextLabel.text label:self.detailTextLabel];
    
    CGFloat width = 32.0f;
    if (textSize.width > RJTHudContentSize || detailTextSize.width > RJTHudContentSize) {
        width += MAX(textSize.width, detailTextSize.width);
    } else {
        width = RJTHudContentSize;
    }
    self.widthConstraint.constant = width;
    
    
    CGFloat progressViewHeight = self.progressView.heightConstraint.constant;
    CGFloat minLabelHeight = self.labelsDefaultHeight;
    
    CGFloat height = progressViewHeight + MAX(textSize.height, minLabelHeight) + MAX(detailTextSize.height, minLabelHeight);
    if (height > RJTHudContentSize)
        height += 32.0;
    
    self.heightConstraint.constant = height;
    self.textLabelHeightConstraint.constant = textSize.height;
    self.detailTextLabelHeightConstraint.constant = detailTextSize.height;
    
    CGRect newFrame = CGRectMake(0.0f, 0.0f, width, height);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:newFrame
                                                          cornerRadius:self.contentView.layer.cornerRadius];
    self.contentView.layer.shadowPath = shadowPath.CGPath;
    
    [self animateWithDuration:0.3f animations:^{
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)animateWithDuration:(NSTimeInterval)duration animations:(void(^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
{
    NSAssert([NSThread isMainThread], @"%s must be called only from the main thread!", __FUNCTION__);
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction animations:animations completion:completion];
}

- (void)performOnMainThread:(void(^)(void))block
{
    [NSThread isMainThread] ? block() : dispatch_sync(dispatch_get_main_queue(), block);
}

- (CGSize)sizeForText:(NSString *)text label:(UILabel *)label
{
    NSUInteger linesCount = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]].count + 1;
    
    CGSize boundingSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), self.labelsDefaultHeight);
    CGSize textSize = [text boundingRectWithSize:boundingSize
                                         options:0 attributes:@{NSFontAttributeName:label.font} context:nil].size;
    textSize.height *= (CGFloat)linesCount;
    
    return textSize;
}

@end
