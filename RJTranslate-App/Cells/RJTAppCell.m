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


@implementation RJTAppCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.0f;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 11.0f;
    self.iconView.tintColor = [UIColor colorWithWhite:0.83f alpha:1.0f];
    
    [self updateSelection:NO animated:NO];
}

- (void)setModel:(RJTApplicationModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.displayedName;
    self.iconView.image = self.model.icon.image ?: [UIImage imageNamed:@"icon_template"];
    
    if (model.bundleIdentifier.length > 0 && model.executableName.length > 0) {
        self.identifierLabel.text = [NSString stringWithFormat:@"%@ - %@", model.executableName, model.bundleIdentifier];
    } else if (model.bundleIdentifier.length > 0) {
        self.identifierLabel.text = model.bundleIdentifier;
    } else {
        self.identifierLabel.text = model.executableName;
    }
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
