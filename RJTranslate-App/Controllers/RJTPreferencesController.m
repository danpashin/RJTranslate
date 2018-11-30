//
//  RJTPreferencesController.m
//  RJTranslate-App
//
//  Created by Даниил on 13/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTPreferencesController.h"
#import "RJTranslate-Swift.h"

@interface RJTPreferencesController () <PrefsTableModelDelegate>
@property (strong, nonatomic) RJTPrefsTableModel *model;
@end

@implementation RJTPreferencesController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.model = [[RJTPrefsTableModel alloc] initWithTableView:self.tableView delegate:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"preferences", @"");
}


#pragma mark -
#pragma mark RJTPrefsTableModelDelegate
#pragma mark -

- (void)userDidSetPreferenceValue:(id _Nullable)value forKey:(NSString * _Nonnull)key
{
    RJTAppDelegate *appDelegate = [UIApplication sharedApplication].appDelegate;
    
    if ([key isEqualToString:@"send_statistics"]) {
        [appDelegate enableTracker:[value boolValue]];
    }
}


@end
