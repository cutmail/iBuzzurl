//
//  Buzzurl.m
//  iBuzzurl
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 cutmail, Inc. All rights reserved.
//

#import "Buzzurl.h"
#import "Article.h"

#define BUZZURL_URL_RECENT_ARTICLE @"http://api.buzzurl.jp/api/articles/recent/v1/json?num=20&threshold=5"
#define BUZZURL_URL_USER_RECENT_ARTICLE @"http://api.buzzurl.jp/api/articles/v1/json/%@"

@implementation Buzzurl

+ (NSData *)getData:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLResponse *response;
    NSError       *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response error:&error];
    
    if (result == nil) {
        NSLog(@"NSURLConnection error %@", error);
    }
    
    return result;
}

+ (NSMutableArray *)getRecentArticle
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *url = BUZZURL_URL_RECENT_ARTICLE;
    
    NSData *data = [self getData:url];
    
    if (!data) {
        return nil;
    }
   
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                 error:&error];
    
    for (NSDictionary *articleDic in json) {
        Article* article = [[Article alloc] initWithDictionary:articleDic];
        [resultList addObject:article];
    }
    return resultList;            
}

+ (NSMutableArray *)getUserRecentArticle
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString *url = [NSString stringWithFormat:BUZZURL_URL_USER_RECENT_ARTICLE, username];
    
    NSData *data = [self getData:url];
    
    if (!data) {
        return nil;
    }
    
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:&error];
    
    for (NSDictionary *articleDic in json) {
        Article* article = [[Article alloc] initWithDictionary:articleDic];
        [resultList addObject:article];
    }
    return resultList;            
}

@end
