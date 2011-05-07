//
//  RootViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface RootViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    EGORefreshTableHeaderView   *_refreshHeaderView;
    BOOL                       _reloading;
    
    NSMutableArray *articleTitles;
    NSMutableArray *articleUrls;
    NSMutableArray *articleComments;
    
    dispatch_queue_t main_queue;
    dispatch_queue_t timeline_queue;
}

@property (nonatomic, retain) NSMutableArray *articleTitles;
@property (nonatomic, retain) NSMutableArray *articleUrls;
@property (nonatomic, retain) NSMutableArray *articleComments;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
