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


__strong NSMutableDictionary <NSString *, NSString *> *localizations;
NSString *localizedString(NSString *origString);

CHDeclareClass(UILabel);
CHOptimizedMethod(1, self, void, UILabel, setText, NSString *, text)
{
    text = localizedString(text);
    CHSuper(1, UILabel, setText, text);
}


CHConstructor
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bundleIdentifier = mainBundle.bundleIdentifier;
    if (bundleIdentifier.length == 0 ||
        [bundleIdentifier isEqualToString:@"ru.danpashin.RJTranslate"] ||
        [bundleIdentifier isEqualToString:@"com.apple.accessibility.AccessibilityUIServer"] ||
//        [bundleIdentifier isEqualToString:@"com.apple.springboard"] ||
        [bundleIdentifier isEqualToString:@"com.apple.PassbookUIService"])
        return;
    
    localizations = [NSMutableDictionary dictionary];
    
    NSString *executableName = mainBundle.executablePath.lastPathComponent;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bundleIdentifier == %@ OR executableName == %@) AND enableTranslation == 1", bundleIdentifier, executableName];
    
    RJTDatabase *localDatabase = [RJTDatabase defaultDatabase];
    [localDatabase fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull entities) {
        RJTLog(@"Loaded localizations with result: %@", entities);
        if (entities.count >= 1) {
            for(RJTApplicationEntity *entity in entities) {
                [localizations addEntriesFromDictionary:entity.translation];
            }
            
            CHLoadClass(UILabel);
            CHHook(1, UILabel, setText);
        } else {
            RJTLog(@"Localizations were not found.");
        }
    }];
}

NSString *localizedString(NSString *origString)
{
    NSString *translatedString = localizations[origString];
    if (translatedString)
        return translatedString;
    
    return origString;
}
