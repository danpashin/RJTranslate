//
//  RJTranslate.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright (c) 2018 Даниил. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>

#import <UIKit/UIKit.h>
#import "RJTDatabase.h"
#import "RJTApplicationEntity.h"


__strong NSDictionary <NSString *, NSString *> *translation;
NSString *localizedString(NSString *origString);

CHDeclareClass(UILabel);
CHOptimizedMethod(1, self, void, UILabel, setText, NSString *, text)
{
    text = localizedString(text);
    CHSuper(1, UILabel, setText, text);
}


CHConstructor
{
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    if (bundleIdentifier.length == 0 ||
        [bundleIdentifier isEqualToString:@"ru.danpashin.RJTranslate"] ||
        [bundleIdentifier isEqualToString:@"com.apple.accessibility.AccessibilityUIServer"] ||
        [bundleIdentifier isEqualToString:@"com.apple.springboard"] ||
        [bundleIdentifier isEqualToString:@"com.apple.PassbookUIService"])
        return;
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier == %@ AND enableTranslation == 1", bundleIdentifier];
    
    RJTDatabase *localDatabase = [RJTDatabase defaultDatabase];
    [localDatabase fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull entities) {
        NSLog(@"[RJTranslate] loaded localizations with result: %@", entities);
        if (entities.count == 1) {
            translation = [entities.firstObject.translation copy];
            
            CHLoadClass(UILabel);
            CHHook(1, UILabel, setText);
        } else if (entities.count > 1) {
            NSLog(@"[RJTranslate] Localization found, but can not load hooks because number of entities more than one.");
        } else {
            NSLog(@"[RJTranslate] Localization was not found.");
        }
    }];
}

NSString *localizedString(NSString *origString)
{
    NSString *translatedString = translation[origString];
    if (translatedString)
        return translatedString;
    
    return origString;
}
