//
//  RootViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 cutmail, Inc. All rights reserved.
//

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    dispatch_queue_t main_queue;
    dispatch_queue_t timeline_queue;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleList;

- (BOOL)isLogin;
- (void)showSettings;

@end
