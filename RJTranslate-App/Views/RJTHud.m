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
@property (strong, nonatomic) UIVisualEffectView *blurView;

@property (strong, nonatomic) RJTHudProgressView *progressView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) NSLayoutConstraint *textLabelHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *detailTextLabelHeightConstraint;

@property (assign, nonatomic, readonly) CGFloat labelsDefaultHeight;

@property (assign, nonatomic) BOOL usesExtendedWidth;
@property (assign, nonatomic) BOOL usesExtendedHeight;
@end


@implementation RJTHud

static CGFloat const RJTHudBackgroundSize = 130.0f;

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
        _blurStyle = UIBlurEffectStyleLight;
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        self.layer.cornerRadius = 20.0f;
        self.layer.masksToBounds = YES;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurStyle];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:self.blurView];
        
        self.progressView = [RJTHudProgressView defaultProgressView];
        self.progressView.tintColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 1;
        self.textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        
        self.detailTextLabel = [[UILabel alloc] init];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        
        
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
    });
}

- (void)hideAnimated:(BOOL)animated
{
    [self performOnMainThread:^{
        if (animated) {
            [self animateWithDuration:0.25f animations:^{
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
    [self performOnMainThread:^{
        [self.progressView setProgress:progress animated:animated];
    }];
}

- (CGFloat)progress
{
    return self.progressView.progress;
}



#pragma mark -
#pragma mark Private
#pragma mark -

- (void)setupConstraints
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.widthConstraint = [self.widthAnchor constraintEqualToConstant:RJTHudBackgroundSize];
    self.widthConstraint.active = YES;
    
    self.heightConstraint = [self.heightAnchor constraintEqualToConstant:RJTHudBackgroundSize];
    self.heightConstraint.active = YES;
    
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.blurView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    self.textLabelHeightConstraint = [self.textLabel.heightAnchor constraintEqualToConstant:self.labelsDefaultHeight];
    self.textLabelHeightConstraint.active = YES;
    
    self.detailTextLabelHeightConstraint = [self.detailTextLabel.heightAnchor constraintEqualToConstant:self.labelsDefaultHeight];
    self.detailTextLabelHeightConstraint.active = YES;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview) {
        [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
        [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self.progressView startAnimating];
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


#pragma mark -

- (void)processText:(NSString *)text forLabel:(UILabel *)label heightConstraint:(NSLayoutConstraint *)heightConstraint
{
    [self performOnMainThread:^{
        if (text.length > 0) {
            label.alpha = 1.0f;
            label.text = text;
            heightConstraint.constant = self.labelsDefaultHeight;
            
            [self animateWithDuration:0.3f animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self updateHudSize];
            }];
        } else {
            heightConstraint.constant = 0.0f;
            
            [self animateWithDuration:0.3f animations:^{
                label.alpha = 0.0f;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                label.text = nil;
                [self updateHudSize];
            }];
        }
    }];
}

- (void)updateHudSize
{
    CGSize textSize = [self sizeForText:self.textLabel.text label:self.textLabel];
    CGSize detailTextSize = [self sizeForText:self.detailTextLabel.text label:self.detailTextLabel];
    
    if (textSize.width > RJTHudBackgroundSize || detailTextSize.width > RJTHudBackgroundSize) {
        self.usesExtendedWidth = YES;
        self.widthConstraint.constant = MAX(textSize.width, detailTextSize.width) + 16.0f;
    } else {
        self.usesExtendedWidth = NO;
        self.widthConstraint.constant = RJTHudBackgroundSize;
    }
    
    if (textSize.height > RJTHudBackgroundSize || detailTextSize.height > RJTHudBackgroundSize) {
        self.usesExtendedHeight = YES;
        self.heightConstraint.constant = MAX(textSize.height, detailTextSize.height) + 16.0f;
    } else {
        self.usesExtendedHeight = NO;
        self.heightConstraint.constant = RJTHudBackgroundSize;
    }
    
    [self animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    } completion:nil];
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
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), self.labelsDefaultHeight) 
                                         options:0 attributes:@{NSFontAttributeName:label.font} context:nil];
    
    return textRect.size;
}

@end
