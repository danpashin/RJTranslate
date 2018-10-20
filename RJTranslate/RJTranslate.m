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
#import "RJTTranslationEntity.h"


__strong NSDictionary <NSString *, NSString *> *translation;
RJTTranslationEntity *databaseTranslationEntity(void);

CHDeclareClass(UILabel);
CHOptimizedMethod(1, self, void, UILabel, setText, NSString *, text)
{
    text = localizedString(text);
    CHSuper(1, UILabel, setText, text);
}


NSString *localizedString(NSString *origString)
{
    NSString *translatedString = translation[origString];
    if (translatedString)
        return translatedString;
    
    return origString;
}


CHConstructor
{
    RJTTranslationEntity *databaseTranslationEntity = databaseTranslationEntity();
    if (databaseTranslationEntity) {
        translation = databaseTranslationEntity.translation;
        
        CHLoadClass(UILabel);
        CHHook(1, UILabel, setText);
    }
}

RJTTranslationEntity *databaseTranslationEntity(void)
{
    NSFetchRequest *fetchRequest = [RJTTranslationEntity fetchRequest];
    
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bundle_identifier == %@ AND enableTranslation == 1", bundleIdentifier];
    
    NSError *executeError = nil;
    
    RJTDatabase *localDatabase = [RJTDatabase defaultDatabase];
    NSArray <RJTTranslationEntity *> *executeResult = [localDatabase.viewContext executeFetchRequest:fetchRequest error:&executeError];
    if (executeResult.count == 1 && !executeError)
        return executeResult.firstObject;
    
    return nil;
}
