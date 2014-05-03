//
//  Article.m
//  Buzzurl touch
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 genesix, Inc. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize title = _title;
@synthesize url = _url;
@synthesize comment = _comment;
@synthesize userNum = _userNum;

//-------------------------------------------------------------------------------------//
#pragma mark -- Initialize --
//-------------------------------------------------------------------------------------//

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _title = dict[@"title"];
    _url = dict[@"url"];
    _comment = (dict[@"comment"] == [NSNull null]) ? @"" : dict[@"comment"];
    _userNum = (dict[@"user_num"] == [NSNull null]) ? @"" : dict[@"user_num"];
    
    return self;
}


@end
