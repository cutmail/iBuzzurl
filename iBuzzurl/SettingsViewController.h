//
//  SettingsViewController.h
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 cutmail, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameField;

@end
