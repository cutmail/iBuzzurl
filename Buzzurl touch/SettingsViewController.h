//
//  SettingsViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *usernameField;
//    UITextField *userMailField;
//    UITextField *passwordField;   
}

@property (nonatomic, retain) UITextField *usernameField;
//@property (nonatomic, retain) UITextField *userMailField;
//@property (nonatomic, retain) UITextField *passwordField;

@end
