//
//  WebViewController.m
//  Buzzurl touch
//
//  Created by Tatsuya Arai on 11/05/07.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "WebViewController.h"

#import "UIColor+NSString.h"
#import "NJKWebViewProgressView.h"
#import "TUSafariActivity.h"

@implementation WebViewController
{
    NJKWebViewProgressView *_progressView;
}

@synthesize pageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    web.scalesPageToFit = YES;
    [contentView addSubview:web];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [contentView addSubview:toolbar];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowsePrev.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowseNext.png"] style:UIBarButtonItemStylePlain target:web action:@selector(goForward)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:web action:@selector(reload)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:web action:@selector(stopLoading)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton, flexibleSpace, actionButton, flexibleSpace, nil] animated:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 200.0f, 36.0f)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textAlignment = NSTextAlignmentCenter;
//    titleView.textColor = [UIColor whiteColor];
    titleView.textColor = [UIColor darkGrayColor];
//    titleView.shadowColor = [UIColor darkGrayColor];
//    titleView.shadowOffset = CGSizeMake(0.0f, -1.0f);
    titleView.font = [UIFont systemFontOfSize:14.0f];
    titleView.numberOfLines = 1;
    self.navigationItem.titleView = titleView;
    
    NJKWebViewProgress *progressProxy = [[NJKWebViewProgress alloc] init];
    web.delegate = progressProxy;
    progressProxy.webViewProxyDelegate = self;
    progressProxy.progressDelegate = self;

    CGFloat progressBarHeight = 2.5f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_progressView removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    titleView.text = self.pageURL;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    titleView.text = [[[webView request] URL] absoluteString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != -999) {
    }
}

- (void)action:(id)sender {
    NSArray *actItems = [NSArray arrayWithObjects:[NSURL URLWithString:self.pageURL], nil];
    TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:actItems applicationActivities:@[safariActivity]];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
