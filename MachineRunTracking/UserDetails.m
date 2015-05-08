//
//  UserDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserDetails.h"
#define k_KEYBOARD_OFFSET 80.0

@implementation UserDetails {
    NSArray *userType;
    UIPickerView *userPicker;
    UIToolbar *userPickerToolbar;
}

@synthesize activeField, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800.0)];
    
    // Check to see if note is not nil, which let's us know that the note
    // had already been saved.
    if (self.UpdateObjPF != nil) {
        self.userNameUpdateText.text = [self.UpdateObjPF objectForKey:@"username"];
        self.userEmailUpdateText.text = [self.UpdateObjPF objectForKey:@"email"];
        self.OldPassText.text=[self.UpdateObjPF objectForKey:@"password"];
        self.userTypeUpdateText.text=[self.UpdateObjPF objectForKey:@"usertype"];
    }
    //NSLog(@"password is %@",self.OldPassText.text);
    
    //Initialize user picker
    userType = [NSArray arrayWithObjects:@"Admin",@"Standard",nil];
    
    userPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, self.userEmailText.frame.origin.y, 288, 120)];
    userPicker.delegate = self;
    userPicker.dataSource = self;
    
    [userPicker setBackgroundColor:[UIColor lightTextColor]];
    [userPicker setShowsSelectionIndicator:YES];
    [self.userTypeUpdateText setInputView:userPicker];
    
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
    [self.userTypeUpdateText setInputAccessoryView:userPickerToolbar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    [super viewDidDisappear:animated];
}

- (IBAction)UpdateButton:(id)sender {
    [self.activityIndicatorView startAnimating];
    NSString *title = [self.userNameUpdateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *email = [self.userEmailUpdateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *pass = [self.OldPassText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *NewPassword = [self.NewPassText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *reEnterPassword = [self.ReTypePassText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([title length] == 0 ||[email length] == 0 ||[pass length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        if (self.UpdateObjPF != nil) {
            if ([NewPassword isEqualToString:reEnterPassword]) {
               [self updateNote];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:@"Password does not match!"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
        }
        else {
            [self saveNote];
        }
    }
}

- (void)saveNote
{
    
    PFObject *NewUser = [PFObject objectWithClassName:@"_User"];
    NewUser[@"username"] = self.userNameUpdateText.text;
    NewUser[@"email"] = self.userEmailUpdateText.text;
    NewUser[@"password"] = self.NewPassText.text;
    NewUser[@"User"] = [PFUser currentUser];
    
    [NewUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [self.activityIndicatorView stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (void)updateNote
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.UpdateObjPF objectId] block:^(PFObject *UpdateUser, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
        UpdateUser[@"username"] = self.userNameUpdateText.text;
            UpdateUser[@"email"] = self.userEmailUpdateText.text;
             UpdateUser[@"usertype"] = self.userTypeUpdateText.text;
            UpdateUser[@"password"] = self.NewPassText.text;
            [PFUser requestPasswordResetForEmailInBackground:self.userEmailUpdateText.text];
            
            [UpdateUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    [self.activityIndicatorView stopAnimating];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
        
    }];
    
}
#pragma mark - UITextFieldDelegate method implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.OldPassText) {
        [self.NewPassText becomeFirstResponder];
    } else if (textField == self.NewPassText) {
        [self.ReTypePassText becomeFirstResponder];
    } else if (textField == self.ReTypePassText) {
        [self.ReTypePassText resignFirstResponder];
    }
    
    return YES;
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userTypeUpdateText) {
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
    self.userTypeUpdateText.text = [userType objectAtIndex:row];
}

//Method to call when Done is clicked on Age picker drop down
- (void)userPickerDoneClicked {
    if ([self.userTypeUpdateText.text isEqualToString:@""]) {
        self.userTypeUpdateText.text = [userType objectAtIndex:0];
    }
    [self.userTypeUpdateText resignFirstResponder];
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
