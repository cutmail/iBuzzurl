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

- (void)dealloc
{
    [usernameField release];
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
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"BD312B"];
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
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveUserInfo)] autorelease];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Account", @"Account");        
    } else {
        return @"iBuzzurlについて";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
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
        static NSString *AboutCellIdentifier = @"AboutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AboutCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"バージョン";
            cell.detailTextLabel.text = @"1.2.0";
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
