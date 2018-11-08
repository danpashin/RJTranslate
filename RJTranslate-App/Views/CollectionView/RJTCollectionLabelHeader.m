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
        
        self.separatorView = [UIView new];
        self.separatorView.layer.cornerRadius = 1.5f;
        self.separatorView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:230/255.0f alpha:1.0f];
        [self addSubview:self.separatorView];
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.separatorView.heightAnchor constraintEqualToConstant:3.0f].active = YES;
        [self.separatorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-3.0f].active = YES;
        [self.separatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0f].active = YES;
        [self.separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0f].active = YES;
        
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.label.leadingAnchor constraintEqualToAnchor:self.separatorView.leadingAnchor].active = YES;
        [self.label.bottomAnchor constraintEqualToAnchor:self.separatorView.topAnchor constant:0.0f].active = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.label.text = nil;
}

@end
