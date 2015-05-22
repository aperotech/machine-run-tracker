//
//  UserDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserDetails.h"
#define k_KEYBOARD_OFFSET 80.0

@interface UserDetails ()

@end

@implementation UserDetails {
    NSArray *userType;
    NSString *title, *email, *currentPassword, *newPassword, *newRePassword, *typeUser;
    UIPickerView *userPicker;
    UIToolbar *userPickerToolbar;
}

@synthesize nameTextField, userTypeField, emailTextField, currentPasswordField, updatePasswordField, updateRePasswordField, activeField, scrollView, activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800.0)];
    
    typeUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([typeUser isEqualToString:@"Standard"]) {
        [self.userTypeField setUserInteractionEnabled:FALSE];
    }
    
    // Check to see if note is not nil, which let's us know that the note
    // had already been saved.
    if (self.userObject != nil) {
        self.nameTextField.text = [self.userObject objectForKey:@"name"];
        self.emailTextField.text = [self.userObject objectForKey:@"email"];
        //self.currentPasswordField.text=[self.userObject objectForKey:@"password"];
        self.userTypeField.text=[self.userObject objectForKey:@"userType"];
    }
    
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

- (IBAction)UpdateButton:(id)sender {
    currentPassword = [self.currentPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newPassword = [self.updatePasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newRePassword = [self.updateRePasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([currentPassword length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid current password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([newPassword length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid new password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([newRePassword length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please re-enter valid new password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        if ([newPassword isEqualToString:newRePassword]) {
               [self updateNote];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"New passwords do not match"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)updateNote {
    [self.activityIndicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.userObject objectId] block:^(PFObject *updateUser, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.activityIndicator stopAnimating];
            [alertView show];
        } else {
            if (![self.userTypeField.text isEqualToString:self.userObject[@"userType"]]) {
                updateUser[@"userType"] = self.userTypeField.text;
            }
            updateUser[@"password"] = self.updatePasswordField.text;
            
            [updateUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.activityIndicator stopAnimating];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.activityIndicator stopAnimating];
                    [alertView show];
                }
            }];
        }
    }];
}

#pragma mark - UITextFieldDelegate method implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.currentPasswordField) {
        [self.updatePasswordField becomeFirstResponder];
    } else if (textField == self.updatePasswordField) {
        [self.updateRePasswordField becomeFirstResponder];
    } else if (textField == self.updateRePasswordField) {
        [self.updateRePasswordField resignFirstResponder];
    }
    
    return YES;
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userTypeField) {
        return NO;
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
}

//Method to call when Done is clicked on Age picker drop down
- (void)userPickerDoneClicked {
    if ([self.userTypeField.text isEqualToString:@""]) {
        self.userTypeField.text = [userType objectAtIndex:0];
    }
    [self.userTypeField resignFirstResponder];
}

//methods to check when a field text is edited, accordingly, adjust keyboard
// Implementing picker for age text field
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = textField;
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
