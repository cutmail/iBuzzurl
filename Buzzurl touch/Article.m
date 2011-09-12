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
    [_title retain];
    _url = [dict objectForKey:@"url"];
    [_url retain];
    _comment = ([dict objectForKey:@"comment"] == [NSNull null]) ? @"" : [dict objectForKey:@"comment"];
    [_comment retain];
    _userNum = ([dict objectForKey:@"user_num"] == [NSNull null]) ? @"" : [dict objectForKey:@"user_num"];
    [_userNum retain];
    
    return self;
}

- (void) dealloc 
{
    [_title release];
    [_url release];
    [_comment release];
    [_userNum release];
    
    [super dealloc];
}

@end
