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

@implementation AddUser
@synthesize userEmailText,userNameText,userTypeText,passwordText;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userNameText.delegate = self;
    userTypeText.delegate = self;
    userEmailText.delegate = self;
    passwordText.delegate=self;
    self.myArray = [NSArray arrayWithObjects:@"Admin",@"Standard",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender
{
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
               [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }

}

-(IBAction)cancel:(id)sender{
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- UIPicker View
- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker{
    picker.delegate = self;
    picker.dataSource = self;
    textField.delegate = self;
    textField.inputView = picker;
}

-(void)loadItemData {
        self.pickerArray  = [[NSArray alloc] initWithArray:self.myArray];
    
   
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:self.userTypeText :self.picker];
    
    
}



#pragma mark - Keyboard delegate stuff

// let tapping on the background (off the input field) close the thing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userTypeText resignFirstResponder];
  
}

#pragma mark - Picker delegate stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return self.pickerArray.count;
    }
       return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return [self.pickerArray objectAtIndex:row];
    }
   
    
    return @"???";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        self.userTypeText.text = [self.pickerArray objectAtIndex:row];
        
    }
    
    [[self view] endEditing:YES];
}









#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Keyboard text field move up
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
    
    
    
    CGPoint buttonOrigin = passwordText.frame.origin;
    
    
    
    CGFloat buttonHeight = passwordText.frame.size.height;
    
    
    
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

@end
