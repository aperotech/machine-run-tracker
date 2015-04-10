//
//  UserDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserDetails.h"
#define k_KEYBOARD_OFFSET 80.0
@implementation UserDetails
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userNameUpdateText.delegate=self;
    self.userTypeUpdateText.delegate=self;
    self.userEmailUpdateText.delegate=self;
    self.NewPassText.delegate=self;
    self.OldPassText.delegate=self;
    self.ReTypePassText.delegate=self;

    // Check to see if note is not nil, which let's us know that the note
    // had already been saved.
    if (self.UpdateObjPF != nil) {
        self.userNameUpdateText.text = [self.UpdateObjPF objectForKey:@"username"];
        self.userEmailUpdateText.text = [self.UpdateObjPF objectForKey:@"email"];
        self.OldPassText.text=[self.UpdateObjPF objectForKey:@"password"];
        self.userTypeUpdateText.text=[self.UpdateObjPF objectForKey:@"usertype"];
    }
    NSLog(@"password is %@",self.OldPassText.text);
}

- (IBAction)UpdateButton:(id)sender {
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*#pragma mark- Keyboard text field move up
- (void)registerForKeyboardNotifications {
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification
     
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
    
}



- (void)deregisterFromKeyboardNotifications {
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:UIKeyboardDidHideNotification
     
                                                  object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:UIKeyboardWillHideNotification
     
                                                  object:nil];
    
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    
    
    [super viewWillAppear:animated];
    
    
    
    [self registerForKeyboardNotifications];
    
    
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    
    [self deregisterFromKeyboardNotifications];
    
    
    
    [super viewWillDisappear:animated];
    
    
    
}
- (void)keyboardWasShown:(NSNotification *)notification {
    
    
    
    NSDictionary* info = [notification userInfo];
    
    
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    CGPoint buttonOrigin = self.ReTypePassText.frame.origin;
    
    
    
    CGFloat buttonHeight = self.ReTypePassText.frame.size.height;
    
    
    
    CGRect visibleRect = self.view.frame;
    
    
    
    visibleRect.size.height -= keyboardSize.height;
    
    
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        
        
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
        
        
    }
    
    
    
}



- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    
    
}
*/
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
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}




@end
