//
//  RJTCollectionHeaderView.m
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionHeaderView.h"

@interface RJTCollectionHeaderView ()
@property (weak, nonatomic) UICollectionView *collectionView;
@end

@implementation RJTCollectionHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 8.0f;
}

- (void)hide:(BOOL)animated
{
    [self setHeight:0.0f animated:animated];
}

- (void)show:(BOOL)animated
{
    [self setHeight:72.0f animated:animated];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightConstraint.constant = height;
        
        if (animated) {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.superview layoutIfNeeded];
            } completion:nil];
        }
    });
}

@end
