//
//  AddUser.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddUser.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/NSRegularExpression.h>

@interface AddUser ()

@end

@implementation AddUser {
    NSArray *userType;
    UIPickerView *userPicker;
    UIToolbar *userPickerToolbar;
}

@synthesize emailTextField, nameTextField, userTypeField, tempPasswordField, scrollView, activeField, activityIndicator;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden=NO;
    
    //[self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //Initialize user picker
    userType = [NSArray arrayWithObjects:@"Admin",@"Standard",nil];
    
    userPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, self.emailTextField.frame.origin.y, 288, 120)];
    userPicker.delegate = self;
    userPicker.dataSource = self;
    
    [userPicker setBackgroundColor:[UIColor lightTextColor]];
    [userPicker setShowsSelectionIndicator:YES];
    [self.userTypeField setInputView:userPicker];
    
    //Creating a toolbar above picker where Done button can be added
    userPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [userPickerToolbar setBarStyle:UIBarStyleDefault];
    [userPickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userPickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [userPickerToolbar setItems:barItems animated:YES];
    [self.userTypeField setInputAccessoryView:userPickerToolbar];

}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}
#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.userTypeField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.tempPasswordField becomeFirstResponder];
    } else if (textField == self.tempPasswordField) {
        [self.tempPasswordField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender {
   /* PFObject *newUser = [PFObject objectWithClassName:@"user"];
    [newUser setObject:nameTextField.text forKey:@"Name"];
    [newUser setObject:tempPasswordField.text forKey:@"Password"];
    [newUser setObject:userTypeField.text forKey:@"User_type"];
    [newUser setObject:emailTextField.text forKey:@"User_Email"];
    [newUser saveInBackground];*/
    NSString *username = [nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [tempPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *type = [userTypeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0 ||[type length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You have to enter a username, password, and email"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self.activityIndicator startAnimating];
        PFObject *newUser = [PFObject objectWithClassName:@"User"];
        newUser[@"name"] = self.nameTextField.text;
        newUser[@"email"] = self.emailTextField.text;
        newUser[@"password"] = self.tempPasswordField.text;
        newUser[@"userType"] = self.userTypeField.text;
        
        //Save newly created user to Parse
        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Notify table view to reload the user list from Parse cloud
                [self.activityIndicator stopAnimating];
                
                // Dismiss the controller
                //[self.navigationController popViewControllerAnimated:YES];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [self.activityIndicator stopAnimating];
                [alert show];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
}

-(IBAction)cancel:(id)sender {
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ((textField.text.length >= 40 && range.length == 0) | (textField == self.userTypeField))
        return NO;
    
    // Only characters in the NSCharacterSet you choose will insertable.
    if (textField.tag==1) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    if (textField.tag==3) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_@."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark - Picker delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return userType.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [userType objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.userTypeField.text = [userType objectAtIndex:row];
   
    //[[self view] endEditing:YES];
}

//Method to call when Done is clicked on Age picker drop down
- (void)userPickerDoneClicked {
    if ([self.userTypeField.text isEqualToString:@""]) {
        self.userTypeField.text = [userType objectAtIndex:0];
    }
    [self.userTypeField resignFirstResponder];
    [self.emailTextField becomeFirstResponder];
}

//methods to check when a field text is edited, accordingly, adjust keyboard
// Implementing picker for age text field
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

//Methods to take care of UIScrollView when keyboard appears
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (self.activeField.frame.origin.y-kbSize.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
