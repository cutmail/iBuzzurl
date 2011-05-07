//
//  RootViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "RootViewController.h"
#import "SettingsViewController.h"
#import "WebViewController.h"
#import "JSON.h"

#define BUZZURL_URL_RECENT_ARTICLE @"http://api.buzzurl.jp/api/articles/v1/json/cutmail"

@implementation RootViewController
@synthesize articleTitles;
@synthesize articleUrls;
@synthesize articleComments;

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

- (void)getRecentArticle {
    NSString *jsonString = [[[NSString alloc] initWithData:[self getData:BUZZURL_URL_RECENT_ARTICLE]
                                                  encoding:NSUTF8StringEncoding] autorelease];
    NSArray *articles = [jsonString JSONValue];
    
    self.articleTitles = [[NSMutableArray alloc] init];
    self.articleUrls = [[NSMutableArray alloc] init];
    self.articleComments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *article in articles) {
        [articleTitles addObject:[article objectForKey:@"title"]];
        [articleUrls addObject:[article objectForKey:@"url"]];
        NSMutableString *comment = ([article objectForKey:@"comment"] == [NSNull null]) ? @"" : [article objectForKey:@"comment"];
        [articleComments addObject:comment];
    }
}

- (void)loadNewData {
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.buzzurl.timeline", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self getRecentArticle];
        dispatch_async(main_queue, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self doneLoadingTableViewData];
            [self.tableView reloadData];
        });
    });

}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Buzzurl touch";
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    UIBarButtonItem *prefButton = [[[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)] autorelease];
    self.navigationItem.leftBarButtonItem = prefButton;
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    [self loadNewData];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
//    dispatch_release(timeline_queue);
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

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
    return articleTitles ? [articleTitles count] : 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    
    if (!articleTitles) {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.text = @"読み込み中...";
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [articleTitles objectAtIndex:[indexPath row]];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = [articleComments objectAtIndex:[indexPath row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];

    // Configure the cell.
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.pageURL = [articleUrls objectAtIndex:row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [self loadNewData];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {

    return _reloading;
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {

    return [NSDate date];
    
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
    self.articleTitles = nil;
    self.articleUrls = nil;
    self.articleComments = nil;
    [articleTitles release];
    [articleUrls release];
    [articleComments release];
}

- (void)dealloc
{
    _refreshHeaderView = nil;
    [articleTitles release];
    [articleUrls release];
    [articleComments release];
    [super dealloc];
}

@end
