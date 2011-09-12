//
//  AdMakerDelegate.h
//
//
//  Copyright 2011 NOBOT Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdMakerView;

@protocol AdMakerDelegate<NSObject>

@required

-(NSArray*)adKeyForAdMakerView:(AdMakerView*)view;
-(UIViewController*)currentViewControllerForAdMakerView:(AdMakerView*)view;


@optional

- (void)didLoadAdMakerView:(AdMakerView*)view;

- (void)didFailedLoadAdMakerView:(AdMakerView*)view;


@end
