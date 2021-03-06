//
//  WebViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/07.
//  Copyright 2011 cutmail, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NJKWebViewProgress.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, NJKWebViewProgressDelegate> {
    UIActionSheet *sheet;
}

@property (nonatomic, strong) NSString *pageURL;

@end
