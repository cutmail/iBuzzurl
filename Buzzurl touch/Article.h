//
//  Article.h
//  Buzzurl touch
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 genesix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject {
    NSString* _title;
    NSString* _url;
    NSString* _comment;
    NSString* _userNum;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* comment;
@property (nonatomic, retain) NSString* userNum;

- (id) initWithDictionary:(NSDictionary *)dict;

@end
