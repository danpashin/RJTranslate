//
//  main.m
//  RJTParser
//
//  Created by Даниил on 02/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJParser.h"
#import "RJPUpdater.h"

#define PRINT_HELP_AND_EXIT(condition) \
    if (!(condition)) { \
        printf("Ошибка: " # condition); \
        printf("\n\n"); \
        printHelp(); \
        return 0;\
    }

void printHelp(void);
NSDictionary <NSString *, NSArray*> *executableArguments(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary <NSString *, NSArray*> *arguments = executableArguments();
        PRINT_HELP_AND_EXIT(arguments.count != 0)
//        NSLog(@"%@", arguments);

        if (arguments[@"--convert-all"]) {
            NSArray *patchesPathArgument = arguments[@"--patches-path"];
            PRINT_HELP_AND_EXIT(patchesPathArgument.count == 1)
            
            NSArray *destinationPathArgument = arguments[@"--destination-path"];
            PRINT_HELP_AND_EXIT(destinationPathArgument.count == 1)
            
            NSString *toolsFolderPath = patchesPathArgument.firstObject;
            NSString *destinationPath = destinationPathArgument.firstObject;
            BOOL allowOverwrite = arguments[@"--allow-overwrite"] ? YES : NO;
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [RJParser parseWithToolsFolder:toolsFolderPath destinationFolder:destinationPath allowOverwrite:allowOverwrite completion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        } else if (arguments[@"--update-single"]) {
            NSArray <NSString *> *plistPathArgument = arguments[@"--plist-path"];
            PRINT_HELP_AND_EXIT(plistPathArgument.count == 1)
            
            NSArray <NSString *> *patchPathArgument = arguments[@"--patch-path"];
            PRINT_HELP_AND_EXIT(patchPathArgument.count == 1)
            
            NSArray <NSString *> *overwriteArguments = arguments[@"--overwrite-plist-arguments"];
            PRINT_HELP_AND_EXIT(overwriteArguments.count > 0)
            
            printf("Выполняю обновление аргументов %s для единичной локализации...\n\n", overwriteArguments.description.UTF8String);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [RJPUpdater updatePlistAtPath:plistPathArgument.firstObject withPatchAtPath:patchPathArgument.firstObject argumentsToOverwrite:overwriteArguments completion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        } else if (arguments[@"--update-all"]) {
            NSArray <NSString *> *plistsPathArgument = arguments[@"--plists-path"];
            PRINT_HELP_AND_EXIT(plistsPathArgument.count == 1)
            
            NSArray <NSString *> *patchesPathArgument = arguments[@"--patches-path"];
            PRINT_HELP_AND_EXIT(patchesPathArgument.count == 1)
            
            NSArray <NSString *> *overwriteArguments = arguments[@"--overwrite-plist-arguments"];
            PRINT_HELP_AND_EXIT(overwriteArguments.count > 0)
            
            printf("Выполняю обновление аргументов %s для всех локализаций...\n\n", overwriteArguments.description.UTF8String);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [RJPUpdater updateAllPlistsAtPath:plistsPathArgument.firstObject withPatchesAtPath:patchesPathArgument.firstObject argumentsToOverwrite:overwriteArguments completion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        } else
            printHelp();
    }
    return 0;
}

void printHelp(void)
{
    printf(
"RJParser v0.2\
\n\n\
Использование:\n\
--convert-all           Выполняет преобразование локализаций твиков/приложений из старого вида (для RJTools) в новый (для RJTranslate). Для данной операции нужные следующие параметры:\n\
    --patches-path          Путь к папке c локализациями в старом виде (RJ1).\n\
    --destination-path      Путь к папке, в которую будут скопированы локализации нового вида.\n\
    --allow-overwrite       Флаг разрашает перезапись уже существующих файлов. По умолчанию не установлен.\
\n\n\
--update-single         Выполняет обновление единичной локализации нового вида из старого.\n\
    --plist-path                    Параметр должен содержать путь до плиста RJTranslate.\n\
    --patch-path                    Путь к папке с локализацией для RJTools.\n\
    --overwrite-plist-arguments     Аргументы нового плиста для обновления. Поддерживаются Executable Path, Displayed Name и Translations. Если аргумент содержит пробел, он должен быть заключен в кавычки. Несколько аргументов разделяются пробелами.\
\n\n\
--update-all            Выполняет обновление всех локализаций нового вида из старого.\n\
    --plists-path                   Параметр должен содержать путь до папки с плистами RJTranslate.\n\
    --patches-path                  Путь к папке с локализациями  для RJTools (RJ1).\n\
    --overwrite-plist-arguments     Аргументы нового плиста для обновления. Поддерживаются Executable Path, Displayed Name и Translations. Если аргумент содержит пробел, он должен быть заключен в кавычки. Несколько аргументов разделяются пробелами.\
\n\n");
}

NSDictionary <NSString *, NSArray*> *executableArguments(void)
{
    NSArray <NSString *> *arguments = [NSProcessInfo processInfo].arguments;
    NSUInteger argumentsCount = arguments.count;
    
    NSMutableDictionary *argumentsDict = [NSMutableDictionary dictionary];
    for (NSUInteger index = 1; index < argumentsCount; index++) {
        NSString *argument = arguments[index];
        
        if ([argument hasPrefix:@"--"]) {
            NSMutableArray <NSString *> *postArguments = [NSMutableArray array];
            for(NSUInteger secondIndex = index + 1; secondIndex < argumentsCount; secondIndex++) {
                NSString *nextArgument = arguments[secondIndex];
                if ([nextArgument hasPrefix:@"--"])
                    break;
                
                [postArguments addObject:nextArgument];
            }
            argumentsDict[argument] = postArguments;
        }
    }
    
    return argumentsDict;
}
