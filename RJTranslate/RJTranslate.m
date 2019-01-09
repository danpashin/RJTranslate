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
#import "RJTDatabaseFacade.h"
#import "RJTApplicationEntity.h"


NS_ASSUME_NONNULL_BEGIN

__strong NSMutableDictionary <NSString *, NSString *> *localizations;
BOOL localizeString(NSString **origString);

CHDeclareClass(UILabel);
CHOptimizedMethod(1, self, void, UILabel, setText, NSString *, text)
{
    localizeString(&text);
    CHSuper(1, UILabel, setText, text);
}

CHDeclareClass(NSBundle);
CHOptimizedMethod(3, self, NSString *, NSBundle, localizedStringForKey, NSString *, key, value, NSString *, value, table, NSString *, table)
{
    if (localizeString(&key))
        return key;
    
    return CHSuper(3, NSBundle, localizedStringForKey, key, value, value, table, table);
}


CHConstructor
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bundleIdentifier = mainBundle.bundleIdentifier;
    if (bundleIdentifier.length == 0 ||
        [bundleIdentifier isEqualToString:@"ru.danpashin.RJTranslate"])
        return;
    
    localizations = [NSMutableDictionary dictionary];
    
    NSString *executableName = mainBundle.executablePath.lastPathComponent;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bundleIdentifier == %@ OR executableName == %@) AND enableTranslation == 1", bundleIdentifier, executableName];
    
    RJTDatabaseFacade *localDatabase = [RJTDatabaseFacade new];
    [localDatabase fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull entities) {
        RJTLog(@"Found localzations: %@ for bundleIdentifier: %@", entities, bundleIdentifier);
        if (entities.count >= 1) {
            BOOL forceLocalize = NO;
            for(RJTApplicationEntity *entity in entities) {
                if (entity.forceLocalize)
                    forceLocalize = YES;
                
                [localizations addEntriesFromDictionary:entity.translation];
            }
            
            if (forceLocalize) {
                CHLoadClass(UILabel);
                CHHook(1, UILabel, setText);
            } else {
                CHLoadClass(NSBundle);
                CHHook(3, NSBundle, localizedStringForKey, value, table);
            }
            
        }
    }];
}


BOOL localizeString(NSString **origString)
{
    if (!*origString)
        return NO;
    
    NSString *translatedString = localizations[*origString];
    if (translatedString) {
        *origString = translatedString;
        return YES;
    }
    
    return NO;
}

NS_ASSUME_NONNULL_END
