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
    
    _title = [dict objectForKey:@"title"];
    _url = [dict objectForKey:@"url"];
    _comment = ([dict objectForKey:@"comment"] == [NSNull null]) ? @"" : [dict objectForKey:@"comment"];
    _userNum = ([dict objectForKey:@"user_num"] == [NSNull null]) ? @"" : [dict objectForKey:@"user_num"];
    
    return self;
}


@end
