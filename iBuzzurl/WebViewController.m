//
//  WebViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/07.
//  Copyright 2011 cutmail, Inc. All rights reserved.
//

#import "WebViewController.h"

#import "NJKWebViewProgressView.h"
#import "TUSafariActivity.h"

@interface WebViewController ()
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NJKWebViewProgress *webViewProgress;
@end

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowsePrev.png"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBrowseNext.png"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goForward)];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:_webView action:@selector(reload)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:_webView action:@selector(stopLoading)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    [toolbar setItems:@[flexibleSpace, backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton, flexibleSpace, actionButton, flexibleSpace] animated:NO];
    
    self.webViewProgress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _webViewProgress;
    self.webViewProgress.webViewProxyDelegate = self;
    self.webViewProgress.progressDelegate = self;

    CGFloat progressBarHeight = 2.5f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"WebView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.title = self.pageURL;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)action:(id)sender
{
    NSArray *actItems = @[[NSURL URLWithString:self.pageURL]];
    TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:actItems applicationActivities:@[safariActivity]];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
