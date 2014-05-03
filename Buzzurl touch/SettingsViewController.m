//
//  SettingsViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SFHFKeychainUtils.h"
#import "UIColor+NSString.h"
#import "AAMFeedbackViewController.h"

@implementation SettingsViewController
@synthesize usernameField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)loadView {
    UITableView *view = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                     style:UITableViewStyleGrouped];
    view.dataSource = self;
    view.delegate   = self;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"Settings", @"Settings");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveUserInfo)];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Account", @"Account");        
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];	
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([indexPath row] == 0) {
                usernameField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 20, 0)];
                usernameField.placeholder = NSLocalizedString(@"Username", @"Username");
                usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                usernameField.keyboardType = UIKeyboardTypeAlphabet;    
                usernameField.returnKeyType = UIReturnKeyDone;
                usernameField.delegate = self;
                usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
                
                [cell addSubview:usernameField];
            }
        }
        return cell;
    } else {
        UITableViewCell *cell;
        if (indexPath.row == 0) {
            static NSString *InquiryCellIdentifier = @"InquiryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:InquiryCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InquiryCellIdentifier];
                
                cell.textLabel.text = @"お問い合わせ／ご要望";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }           
        } else {
            static NSString *AboutCellIdentifier = @"AboutCell";
            cell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AboutCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.textLabel.text = @"バージョン";
                cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            }
        }
        return cell;
    }
    
    return nil;
}


- (void)saveUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // ユーザ名はNSUserDefaultsを使って保存
    [defaults setObject:usernameField.text forKey:@"USERNAME"];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Saveボタンを有効にする
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        AAMFeedbackViewController *vc = [[AAMFeedbackViewController alloc]init];
        vc.toRecipients = [NSArray arrayWithObject:@"cutmailapp@gmail.com"];
        vc.ccRecipients = nil;
        vc.bccRecipients = nil;
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
    }
}

@end
