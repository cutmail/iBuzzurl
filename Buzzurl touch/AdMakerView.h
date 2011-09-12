//
//  AdMakerView.h
//
//  Copyright 2011 NOBOT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMakerDelegate.h"

@interface AdMakerView : UIViewController <UIWebViewDelegate> {
	id<AdMakerDelegate> delegate;
}

@property(nonatomic,assign) id <AdMakerDelegate> delegate;

-(void)setAdMakerDelegate:(id)_delegate;
-(void)setFrame:(CGRect)frame;
-(void)start;

- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
