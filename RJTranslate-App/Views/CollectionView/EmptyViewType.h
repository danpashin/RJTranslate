//
//  EmptyViewType.h
//  RJTranslate
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

typedef enum EmptyViewType : NSInteger EmptyViewType; 
enum __attribute__((enum_extensibility(closed))) EmptyViewType : NSInteger {
    EmptyViewTypeLoading = 0,
    EmptyViewTypeNoSearchResults = 1,
    EmptyViewTypeNoData = 2,
};
