//
//  RecentArticleViewController.h
//  iBuzzurl
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 cutmail, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentArticleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    dispatch_queue_t main_queue;
    dispatch_queue_t timeline_queue;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleList;

- (BOOL)isLogin;
- (void)showSettings;

@end

