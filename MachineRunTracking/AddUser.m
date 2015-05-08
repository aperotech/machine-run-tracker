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
#define k_KEYBOARD_OFFSET 80.0

@implementation AddUser {
    NSArray *userType;
    UIPickerView *userPicker;
    UIToolbar *userPickerToolbar;
}

@synthesize userEmailText, userNameText, userTypeText, passwordText, scrollView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden=NO;
    
    //[self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    //Initialize user picker
    userType = [NSArray arrayWithObjects:@"Admin",@"Standard",nil];
    
    userPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, self.userEmailText.frame.origin.y, 288, 120)];
    userPicker.delegate = self;
    userPicker.dataSource = self;
    
    [userPicker setBackgroundColor:[UIColor lightTextColor]];
    [userPicker setShowsSelectionIndicator:YES];
    [self.userTypeText setInputView:userPicker];
    
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
    [self.userTypeText setInputAccessoryView:userPickerToolbar];

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

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameText) {
        [self.userTypeText becomeFirstResponder];
    } else if (textField == self.userEmailText) {
        [self.passwordText becomeFirstResponder];
    } else if (textField == self.passwordText) {
        [self.passwordText resignFirstResponder];
    }
    
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender {
    [self.activityIndicatorView startAnimating];
   /* PFObject *newUser = [PFObject objectWithClassName:@"user"];
    [newUser setObject:userNameText.text forKey:@"Name"];
    [newUser setObject:passwordText.text forKey:@"Password"];
    [newUser setObject:userTypeText.text forKey:@"User_type"];
    [newUser setObject:userEmailText.text forKey:@"User_Email"];
    [newUser saveInBackground];*/
    NSString *username = [userNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [userEmailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *type = [userTypeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0 ||[type length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You have to enter a username, password, and email"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.activityIndicatorView stopAnimating];
    }
    else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        newUser[@"usertype"]=type;
      //  newUser.usertype = type;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                [self.activityIndicatorView stopAnimating];
                // Dismiss the controller
                //[self dismissViewControllerAnimated:YES completion:nil];
               [self dismissViewControllerAnimated:YES completion:nil];
               //[self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

-(IBAction)cancel:(id)sender {
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range      replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    if (textField == self.userNameText)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
        NSRegularExpression *regex = [ NSRegularExpressionregularExpressionWithPattern:expression
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;        
    }
    return YES;
}
*/
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= 20 && range.length == 0)
        return NO;
    // Only characters in the NSCharacterSet you choose will insertable.
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}
*/

//Method to disable any user input for the user type text field
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userTypeText) {
        return NO;
    }
    return YES;
}*/

#pragma mark- UIPicker View
/*- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker {
    picker.delegate = self;
    picker.dataSource = self;
    textField.delegate = self;
    textField.inputView = picker;
}

-(void)loadItemData {
    self.pickerArray  = [[NSArray alloc] initWithArray:self.myArray];
 
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:self.userTypeText :self.picker];
}*/

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
    self.userTypeText.text = [userType objectAtIndex:row];
   
    //[[self view] endEditing:YES];
}

//Method to call when Done is clicked on Age picker drop down
- (void)userPickerDoneClicked {
    if ([self.userTypeText.text isEqualToString:@""]) {
        self.userTypeText.text = [userType objectAtIndex:0];
    }
    [self.userTypeText resignFirstResponder];
    [self.userEmailText becomeFirstResponder];
}

/*#pragma mark - Keyboard delegate stuff

// let tapping on the background (off the input field) close the thing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [userTypeText resignFirstResponder];
    
}*/

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


/*- (void)textFieldDidBeginEditing:(UITextField *)textField {
 
 self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
 }*/

/*#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -30; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIScrollView setAnimationBeginsFromCurrentState: YES];
    [UIScrollView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIScrollView commitAnimations];
}*/

@end
