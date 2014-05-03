//
//  RootViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface RootViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
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
