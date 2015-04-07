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
    PFObject *newUser = [PFObject objectWithClassName:@"User"];
    [newUser setObject:userNameText.text forKey:@"Name"];
    [newUser setObject:passwordText.text forKey:@"Password"];
    [newUser setObject:userTypeText.text forKey:@"User_type"];
    [newUser setObject:userEmailText.text forKey:@"User_Email"];
    [newUser saveInBackground];
    
    //PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
   // newUser[@"Name"] = userNameText.text;
    //newUser[@"Password"] = passwordText.text;
    //newUser[@"User_type"] = userTypeText.text;
   // newUser[@"User_Email"]= userEmailText.text;
  //  [newUser pinInBackground];
}

-(IBAction)cancel:(id)sender{
    [self popoverPresentationController];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
