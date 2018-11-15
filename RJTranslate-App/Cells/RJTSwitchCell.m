//
//  RJTSwitchCell.m
//  RJTranslate-App
//
//  Created by Даниил on 13/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTSwitchCell.h"
#import "RJTPrefsOption.h"

@interface RJTSwitchCell ()
@property (strong, nonatomic) UISwitch *switchView;
@end

@implementation RJTSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    self.switchView = [UISwitch new];
    [self.switchView addTarget:self action:@selector(switchTrigerred:) forControlEvents:UIControlEventValueChanged];
    self.switchView.onTintColor = RJTColors.navTintColor;
    self.accessoryView = self.switchView;
}

- (void)switchTrigerred:(UISwitch *)switchView
{
    [self.model saveValue:@(switchView.on)];
}

- (void)setModel:(RJTPrefsOption *)model
{
    _model = model;
    
    __weak typeof(self) weakSelf = self;
    [model performOnBackground:^{
        BOOL switchEnabled = [model.savedValue boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.switchView.on = switchEnabled;
        });
    }];
}

@end
