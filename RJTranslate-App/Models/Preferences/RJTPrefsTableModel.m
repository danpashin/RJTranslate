//
//  RJTPrefsTableModel.m
//  RJTranslate-App
//
//  Created by Даниил on 13/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTPrefsTableModel.h"
#import "RJTSwitchCell.h"
#import "RJTPrefsSectionOption.h"

@interface RJTPrefsTableModel ()
@property (nonatomic, readonly) NSArray <RJTPrefsSectionOption *> *options;
@end

@implementation RJTPrefsTableModel
@synthesize options = _options;

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id <RJTPrefsTableModelDelegate>)delegate
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _delegate = delegate;
    }
    return self;
}


- (NSArray <RJTPrefsSectionOption *> *)options
{
    if (_options)
        return _options;
    
    RJTPrefsOption *sendStatsRow = [RJTPrefsOption switchOptionWithTitle:NSLocalizedString(@"send_statistics", @"")
                                                                     key:@"send_statistics" defaultValue:@YES];
    RJTPrefsOption *sendCrashRow = [RJTPrefsOption switchOptionWithTitle:NSLocalizedString(@"send_crashlogs", @"")
                                                                     key:@"send_crashlogs" defaultValue:@YES];
    _options = @[
                 [self oneRowSectionWithTitle:@"statistics" footer:@"send_statistics_footer" :sendStatsRow],
                 [self oneRowSectionWithTitle:@"" footer:@"send_crashlogs_footer" :sendCrashRow]
                 ];
    
    return _options;
}

- (RJTPrefsSectionOption *)oneRowSectionWithTitle:(NSString *)title footer:(NSString *)footer
                                              :(RJTPrefsOption *)rowOption
{
    rowOption.prefsTableModel = self;
    return [RJTPrefsSectionOption sectionWithHeaderTitle:NSLocalizedString(title, @"")
                                              footerText:NSLocalizedString(footer, @"")
                                                    rows:@[rowOption]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.options.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RJTPrefsOption *option = self.options[indexPath.section].rows[indexPath.row];
    
    UITableViewCell *cell = nil;
    if (option.type == RJTPrefsOptionTypeStaticText) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"staticTextCell"];
    } else if (option.type == RJTPrefsOptionTypeSwitch) {
        RJTSwitchCell *switchCell = [[RJTSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"switchCell"];
        switchCell.model = option;
        cell = switchCell;
    }
    
    cell.textLabel.text = option.title;
    cell.detailTextLabel.text = option.subtitle;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.options[section].title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.options[section].footerText;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
