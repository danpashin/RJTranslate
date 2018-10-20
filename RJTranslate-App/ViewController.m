//
//  ViewController.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "ViewController.h"
#import "RJTDatabase.h"
#import "RJTTranslationEntity.h"

@interface ViewController ()

@property (strong, nonatomic) RJTDatabase *localDatabase;

@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.localDatabase = [RJTDatabase defaultDatabase];
    
    
}


@end
