//
//  WebViewController.m
//  Buzzurl touch
//
//  Created by Tatsuya Arai on 11/05/07.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "WebViewController.h"
#import "UIColor+NSString.h"

@implementation WebViewController
@synthesize pageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
    [contentView release];
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    web.delegate = self;
    web.scalesPageToFit = YES;
    [contentView addSubview:web];
    [web release];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    toolbar.tintColor = [UIColor colorWithHexString:@"BD312B"];
    [contentView addSubview:toolbar];
    [toolbar release];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowsePrev.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowseNext.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goForward)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:web action:@selector(reload)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:web action:@selector(stopLoading)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton, flexibleSpace, actionButton, flexibleSpace, nil] animated:NO];
    
    [flexibleSpace release];
    [backButton release];
    [forwardButton release];
    [reloadButton release];
    [actionButton release];
    [stopButton release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 200.0f, 36.0f)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0.0f, -1.0f);
    titleView.font = [UIFont boldSystemFontOfSize:14.0f];
    titleView.numberOfLines = 2;
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    titleView.text = self.pageURL;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    titleView.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title;"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != -999) {
    }
}

- (void)action:(id)sender {
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                          destructiveButtonTitle:nil 
                               otherButtonTitles:NSLocalizedString(@"Open with Safari", @"Open with Safari"), nil];
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark -
#pragma mark ActionSeet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pageURL]];
    }    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    sheet = nil;
}

- (void)applicationDidEnterBackground:(NSNotification *)note {
//    [alert dismissWithClickedButtonIndex:0 animated:NO];
//    alert = nil;
//    
    if (sheet) {
        [sheet dismissWithClickedButtonIndex:2 animated:NO];
        sheet = nil;
    }
    
    if (self.modalViewController) {
        [self.modalViewController dismissModalViewControllerAnimated:NO];
    }
}

@end
