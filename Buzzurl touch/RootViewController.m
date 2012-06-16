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
#import "Article.h"
#import "Buzzurl.h"
#import "UIColor+NSString.h"

@implementation RootViewController
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
            
//    if ([self isLogin] == YES) {
//        
//    } else {
////        [self showSettings];
//        [self doneLoadingTableViewData];
//        return;
//    }
    
    main_queue = dispatch_get_main_queue();
    timeline_queue = dispatch_queue_create("me.cutmail.buzzurl.timeline", NULL);
    
    dispatch_async(timeline_queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.articleList = [Buzzurl getUserRecentArticle];
        dispatch_async(main_queue, ^{
            if (articleList == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Check your username", @"Check your username") delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
                [alert show];  
                [alert release];
            }
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    if ([self isLogin] == YES) {
        [self loadNewData];        
    } else {
        [self showSettings];
    }
    
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
    
    //    if (!articleTitles) {
    //        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    //        cell.textLabel.text = @"読み込み中...";
    //        cell.textLabel.textColor = [UIColor grayColor];
    //        return cell;
    //    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Article* article = [articleList objectAtIndex:[indexPath row]];
    
    //    cell.textLabel.text = [articleTitles objectAtIndex:[indexPath row]];
    cell.textLabel.text = article.title;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    //    cell.detailTextLabel.text = [articleComments objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = article.comment;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    if ([self isLogin] == YES) {
        _reloading = YES;
        [self loadNewData];        
    } else {
        _reloading = NO;
    }
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
    if ([self isLogin] == YES) {
        [self reloadTableViewDataSource];
    } else {
        //        [self doneLoadingTableViewData];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Please Login", @"Please Login") delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
        [alert show];  
        [alert release]; 
    }
    
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
