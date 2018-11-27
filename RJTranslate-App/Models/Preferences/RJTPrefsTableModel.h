//
//  RJTPrefsTableModel.h
//  RJTranslate-App
//
//  Created by Даниил on 13/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJTPrefsTableModel;
@protocol RJTPrefsTableModelDelegate <NSObject>

- (void)userDidSetPreferenceValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJTPrefsTableModel : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic, readonly) UITableView *tableView;
@property (weak, nonatomic, readonly) id <RJTPrefsTableModelDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id <RJTPrefsTableModelDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
