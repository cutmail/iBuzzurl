//
//  RecentArticleViewController.h
//  Buzzurl touch
//
//  Created by 荒井 達哉 on 11/09/12.
//  Copyright (c) 2011年 genesix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface RecentArticleViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITableView                 *_tableView;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    BOOL                       _reloading;
    
    NSMutableArray *articleList;;
    
    dispatch_queue_t main_queue;
    dispatch_queue_t timeline_queue;
}

@property (nonatomic, strong) IBOutlet UITableView *_tableView;
@property (nonatomic, strong) NSMutableArray *articleList;

- (BOOL)isLogin;
- (void)showSettings;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

