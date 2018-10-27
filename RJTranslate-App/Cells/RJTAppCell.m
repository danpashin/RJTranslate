//
//  RJTAppCell.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCell.h"
#import "RJTApplicationModel.h"
#import "RJTTickView.h"

@interface RJTAppCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet RJTTickView *tickView;

@end

typedef NS_ENUM(NSUInteger, MIIconVariant) {
        // iphone  ipad
    MIIconVariantSmall,            // 29x29   29x29
    MIIconVariantSpotlight,        // 40x40   40x40
    MIIconVariantDefault,          // 62x62   78x78
    MIIconVariantGameCenter,       // 42x42   78x78
    MIIconVariantDocumentFull,     // 37x48   37x48
    MIIconVariantDocumentSmall,    // 37x48   37z48
    MIIconVariantSquareBig,        // 82x82   128x128
    MIIconVariantSquareDefault,    // 62x62   78x78
    MIIconVariantTiny,             // 20x20   20x20
    MIIconVariantDocument,         // 37x48   247x320
    MIIconVariantDocumentLarge,    // 37x48   247x320
    MIIconVariantUnknownGradient,  // 300x150 300x150
    MIIconVariantSquareGameCenter, // 42x42   42x42
    MIIconVariantUnknownDefault,   // 62x62   78x78
};

@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(MIIconVariant)format scale:(CGFloat)scale;
@end

@implementation RJTAppCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.0f;
    self.iconView.layer.cornerRadius = 12.0f;
    self.iconView.tintColor = [UIColor colorWithWhite:0.83f alpha:1.0f];
    
    [self updateSelection:NO animated:NO];
}

- (void)setModel:(RJTApplicationModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.displayedName;
    self.identifierLabel.text = model.bundleIdentifier;
    
    self.iconView.image = [UIImage _applicationIconImageForBundleIdentifier:model.bundleIdentifier 
                                                                     format:MIIconVariantDefault 
                                                                      scale:[UIScreen mainScreen].scale];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.model = nil;
    [self updateSelection:NO animated:NO];
}

- (void)updateSelection:(BOOL)selected animated:(BOOL)animated
{
    [self.tickView setEnabled:selected animated:animated];
}

@end
