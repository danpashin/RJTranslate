//
//  RJTCollectionLabelHeader.m
//  RJTranslate-App
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionLabelHeader.h"


@interface RJTCollectionLabelHeader ()
@property (strong, nonatomic) UIView *separatorView;
@end

@implementation RJTCollectionLabelHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        self.label.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        self.label.font = [UIFont systemFontOfSize:[UIFont labelFontSize] + 4.0f weight:UIFontWeightBlack];
        [self addSubview:self.label];
        
        [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:230/255.0f alpha:1.0f];
        [self addSubview:self.separatorView];
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        self.separatorView.layer.cornerRadius = 1.5f;
        [self.separatorView.heightAnchor constraintEqualToConstant:3.0f].active = YES;
        [self.separatorView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:3.0f].active = YES;
        [self.separatorView.leadingAnchor constraintEqualToAnchor:self.label.leadingAnchor].active = YES;
        [self.separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0f].active = YES;
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.label] && [keyPath isEqualToString:@"text"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.label sizeToFit];
            
            CGRect labelFrame = self.label.frame;
            labelFrame.origin.x = 8.0f;
            self.label.frame = labelFrame;
        });
    }
}

- (void)dealloc
{
    [self.label removeObserver:self forKeyPath:@"text"];
}

- (CGSize)intrinsicContentSize
{
    CGSize origSize = [super intrinsicContentSize];
    return CGSizeMake(origSize.width - 32.0f, origSize.height);
}

@end
