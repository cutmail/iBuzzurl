//
//  RootViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "RecentArticleViewController.h"
#import "SettingsViewController.h"
#import "WebViewController.h"
#import "JSON.h"
#import "Article.h"
#import "Buzzurl.h"
#import "TDBadgedCell.h"
#import "UIColor+NSString.h"

@implementation RecentArticleViewController
@synthesize _tableView;
@synthesize articleList;

#pragma mark -
#pragma mark Buzzurl access

- (NSData *)getData:(NSString *)url; {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLResponse *response;
    NSError       *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response error:&error];
    
    if (result == nil) {
        NSLog(@"NSURLConnection error %@", error);
    }
    
    return result;
}

- (void)loadNewData {
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.buzzurl.timeline", NULL);
        
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.articleList = [Buzzurl getRecentArticle];
        dispatch_async(main_queue, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self doneLoadingTableViewData];
            [self._tableView reloadData];
        });
    });
    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"iBuzzurl";
    //    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    UIBarButtonItem *prefButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)] autorelease];
    self.navigationItem.leftBarButtonItem = prefButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"BD312B"];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, 320.0f, self._tableView.bounds.size.height)];
        view.delegate = self;
        [self._tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    self.articleList = [[NSMutableArray alloc] init];
    
    [self loadNewData];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)isLogin {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    return (![username isEqualToString:@""] && username != nil);
}

- (void)showSettings {
    SettingsViewController *settingView = [[SettingsViewController alloc] init];
    UINavigationController* navCon = [[UINavigationController alloc]
                                      initWithRootViewController:settingView];
    //    navCon.navigationBar.tintColor = [UIColor redColor];
	[self.navigationController presentModalViewController:navCon animated:YES];
	[navCon release];
}


#pragma mark -
#pragma mark TableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return articleTitles ? [articleTitles count] : 0;
    return articleList ? [articleList count] : 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Article* article = [articleList objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = article.title;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = article.comment;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.badgeString = article.userNum;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Article* article = [articleList objectAtIndex:[indexPath row]];
    
    WebViewController *controller = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.pageURL = article.url;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [self loadNewData];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    
    return _reloading;
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    
    return [NSDate date];
    
}

-(UIViewController*)currentViewControllerForAd { 
    return self;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _refreshHeaderView = nil;
    self.articleList = nil;
    [articleList release];
}

- (void)dealloc
{
    _refreshHeaderView = nil;
    [articleList release];
    [super dealloc];
}

@end
