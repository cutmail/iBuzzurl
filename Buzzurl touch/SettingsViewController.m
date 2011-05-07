//
//  SettingsViewController.m
//  iBuzzurl
//
//  Created by Tatsuya Arai on 11/05/06.
//  Copyright 2011 genesix, Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SFHFKeychainUtils.h"

@implementation SettingsViewController
@synthesize usernameField;
//@synthesize userMailField;
//@synthesize passwordField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [usernameField release];
//    [userMailField release];
//    [passwordField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
    UITableView *view = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                     style:UITableViewStyleGrouped];
    view.dataSource = self;
    view.delegate   = self;
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"Settings", @"Settings");
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUserInfo)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector
                                              (cancel)] autorelease];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Account", @"Account");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 30)] autorelease];
//        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
//        label.font = [UIFont boldSystemFontOfSize:13];
//        [cell addSubview:label];
        
        if ([indexPath row] == 0) {
            usernameField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 20, 0)];
            usernameField.placeholder = NSLocalizedString(@"Username", @"Username");
            usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            usernameField.keyboardType = UIKeyboardTypeAlphabet;    
            usernameField.returnKeyType = UIReturnKeyDone;
            usernameField.delegate = self;
            usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
            
            [cell  addSubview:usernameField];
//        } else if ([indexPath row] == 1) {            
//            userMailField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 20, 0)];
//            userMailField.placeholder = @"メールアドレス";
//            userMailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            userMailField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            userMailField.returnKeyType = UIReturnKeyNext;
//            userMailField.delegate = self;
//            userMailField.keyboardType = UIKeyboardTypeEmailAddress;
//            userMailField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERMAIL"];
//
//            [cell addSubview:userMailField];
//        } else if ([indexPath row] == 2) {
//            NSError *error;
//            passwordField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 20, 0)];
//            passwordField.placeholder = @"パスワード";
//            passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            passwordField.returnKeyType = UIReturnKeyDone;
//            passwordField.delegate = self;
//            passwordField.secureTextEntry = YES;
//            // ラッパークラスを利用してKeyChainから保存しているパスワードを取得する処理
//            passwordField.text = [SFHFKeychainUtils getPasswordForUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"] andServiceName:@"Test App" error:&error];
//            [cell addSubview:passwordField];
        }
    }
    
    return cell;
}


- (void)saveUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *oldUsername = [defaults objectForKey:@"USERNAME"];
//    NSError *error;
//    if (![oldUsername isEqualToString:usernameField.text]) {
//        // ユーザ名が変更になっていた場合は、古いユーザ名で保存したパスワードを削除
//        [SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:@"Test App" error:&error];
//    }
    
    // ユーザ名はNSUserDefaultsを使って保存
    [defaults setObject:usernameField.text forKey:@"USERNAME"];
//    [defaults setObject:userMailField.text forKey:@"USERMAIL"];
    
    // ラッパークラスを利用してパスワードをKeyChainに保存
//    [SFHFKeychainUtils storeUsername:usernameField.text andPassword:passwordField.text forServiceName:@"Test App" updateExisting:YES error:&error];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Saveボタンを有効にする
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
