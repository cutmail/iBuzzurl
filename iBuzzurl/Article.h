//
//  Article.h
//  iBuzzurl
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 genesix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSString *userNum;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
