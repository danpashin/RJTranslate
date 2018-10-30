//
//  RJTDatabaseUpdate.m
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabaseUpdate.h"

@interface RJTDatabaseUpdate ()

@property (strong, nonatomic, readwrite) NSString *hashSum;
@property (strong, nonatomic, readwrite) NSString *archiveURL;

@property (assign, nonatomic, readwrite) BOOL canUpdate;

@end

@implementation RJTDatabaseUpdate

+ (instancetype)from:(NSDictionary *)response
{
    RJTDatabaseUpdate *update = [RJTDatabaseUpdate new];
    update.hashSum = response[@"hash_sum"];
    update.archiveURL = response[@"archive"];
    update.canUpdate = YES;
    
    return update;
}

- (void)setHashSum:(NSString *)hashSum
{
    _hashSum = hashSum;
    
//    NSString *savedHash = [[NSUserDefaults standardUserDefaults] stringForKey:@"latestDatabaseUpdateHash"];
//    if (hashSum.length > 0 && savedHash.length > 0)
//        self.canUpdate = ![hashSum isEqualToString:savedHash];
//    else
//        self.canUpdate = NO;
}

- (void)saveUpdate
{
    [[NSUserDefaults standardUserDefaults] setObject:self.hashSum forKey:@"latestDatabaseUpdateHash"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> url: '%@'; hash sum: '%@'", NSStringFromClass([self class]), self, self.archiveURL, self.hashSum];
}

@end
