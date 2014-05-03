//
//  WebViewController.h
//  Buzzurl touch
//
//  Created by Tatsuya Arai on 11/05/07.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NJKWebViewProgress.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, NJKWebViewProgressDelegate> {
    UIWebView *web;
    UILabel   *titleView;
    
    UIActionSheet *sheet;
}

@property (nonatomic, strong) NSString *pageURL;

@end
