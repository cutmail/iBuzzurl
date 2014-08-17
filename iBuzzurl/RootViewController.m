//
//  RootViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 cutmail, Inc. All rights reserved.
//

#import "RootViewController.h"
#import "SettingsViewController.h"
#import "WebViewController.h"
#import "JSON.h"
#import "Article.h"
#import "Buzzurl.h"

@interface RootViewController ()
@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation RootViewController

#pragma mark -
#pragma mark Buzzurl access

- (void)loadNewData
{
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.buzzurl.timeline", NULL);
   
    __weak typeof(self) weakSelf = self;
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.articleList = [Buzzurl getUserRecentArticle];
        dispatch_async(main_queue, ^{
            if (_articleList == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Check your username", @"Check your username") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];  
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [weakSelf.tableView reloadData];
            [weakSelf.refreshControl endRefreshing];
        });
    });
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"自分のブックマーク";
    UIBarButtonItem *prefButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    self.navigationItem.leftBarButtonItem = prefButton;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.alwaysBounceVertical = YES;
    [self.tableView addSubview:_refreshControl];
    
    self.articleList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    if ([self isLogin]) {
        [self loadNewData];
    }
    else {
        [self showSettings];
    }
}

- (BOOL)isLogin
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    return (![username isEqualToString:@""] && username != nil);
}

- (void)showSettings
{
    SettingsViewController *settingView = [[SettingsViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc]
                                      initWithRootViewController:settingView];
    
    [self.navigationController presentViewController:navCon animated:YES completion:nil];
}


#pragma mark -
#pragma mark TableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleList ? _articleList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Article *article = _articleList[indexPath.row];
    
    cell.textLabel.text = article.title;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = article.comment;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Article *article = _articleList[indexPath.row];
    
    WebViewController *controller = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.pageURL = article.url;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end