//
//  RJTCollectionViewUpdateCell.m
//  RJTranslate-App
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewUpdateCell.h"

@implementation RJTCollectionViewUpdateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8.0f;
    self.backgroundColor = [UIColor orangeColor];
    
    _textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    _detailedTextLabel = [UILabel new];
    self.detailedTextLabel.textColor = [UIColor whiteColor];
    self.detailedTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.textLabel, self.detailedTextLabel]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0f;
    [self addSubview:stackView];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

@end
