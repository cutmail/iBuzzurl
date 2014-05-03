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

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) NSString* userNum;

- (id) initWithDictionary:(NSDictionary *)dict;

@end
