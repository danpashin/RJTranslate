//
//  RJTCollectionHeaderView.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionHeaderView : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *detailedText;

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
