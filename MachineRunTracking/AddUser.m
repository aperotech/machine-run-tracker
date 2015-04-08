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
      //  newUser.usertype = type;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }

}

-(IBAction)cancel:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
