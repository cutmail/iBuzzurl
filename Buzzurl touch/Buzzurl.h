//
//  Buzzurl.h
//  Buzzurl touch
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 genesix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Buzzurl : NSObject {
    
}

+ (NSData *)getData:(NSString *)url;
+ (NSMutableArray *)getRecentArticle;
+ (NSMutableArray *)getUserRecentArticle;

@end
