//
//  UserDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check to see if note is not nil, which let's us know that the note
    // had already been saved.
    if (self.UpdateObjPF != nil) {
        self.userNameUpdateText.text = [self.UpdateObjPF objectForKey:@"username"];
        self.userEmailUpdateText.text = [self.UpdateObjPF objectForKey:@"email"];
        self.OldPassText.text=[self.UpdateObjPF objectForKey:@"password"];
    }
}

- (IBAction)UpdateButton:(id)sender {
    
    NSString *title = [self.userNameUpdateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *email = [self.userEmailUpdateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *pass = [self.OldPassText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([title length] == 0 ||[email length] == 0 ||[pass length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must at least enter a username"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        if (self.UpdateObjPF != nil) {
            [self updateNote];
        }
        else {
            [self saveNote];
        }
    }
    
}

- (void)saveNote
{
    
    PFObject *NewUser = [PFObject objectWithClassName:@"User"];
    NewUser[@"username"] = self.userNameUpdateText.text;
    NewUser[@"email"] = self.userEmailUpdateText.text;
    NewUser[@"password"] = self.OldPassText.text;
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
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
            UpdateUser[@"password"] = self.OldPassText.text;

            
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



@end
