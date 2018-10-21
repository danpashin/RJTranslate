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
RJTApplicationEntity *databaseTranslationEntity(void);
NSString *localizedString(NSString *origString);

CHDeclareClass(UILabel);
CHOptimizedMethod(1, self, void, UILabel, setText, NSString *, text)
{
    text = localizedString(text);
    CHSuper(1, UILabel, setText, text);
}


CHConstructor
{
    RJTApplicationEntity *translationEntity = databaseTranslationEntity();
    if (translationEntity) {
        translation = [translationEntity.translation copy];
        
        CHLoadClass(UILabel);
        CHHook(1, UILabel, setText);
    }
}

NSString *localizedString(NSString *origString)
{
    NSString *translatedString = translation[origString];
    if (translatedString)
        return translatedString;
    
    return origString;
}

RJTApplicationEntity *databaseTranslationEntity(void)
{
    NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
    
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bundle_identifier == %@ AND enableTranslation == 1", bundleIdentifier];
    
    NSError *executeError = nil;
    
    RJTDatabase *localDatabase = [RJTDatabase defaultDatabase];
    NSArray <RJTApplicationEntity *> *executeResult = [localDatabase.viewContext executeFetchRequest:fetchRequest error:&executeError];
    if (executeResult.count == 1 && !executeError)
        return executeResult.firstObject;
    
    return nil;
}
