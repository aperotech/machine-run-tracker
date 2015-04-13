//
//  MachineDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "MachineDetails.h"
#import <Parse/Parse.h>
@interface MachineDetails ()

@end

@implementation MachineDetails
@synthesize codeText,nameText,descriptionText,trackingFrequencyText,locationText,capacityText,maintanceFrequencyText,lastMaintanceDate;
@synthesize MachineDetailsPF;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    if (MachineDetailsPF != nil) {
    codeText.text=[MachineDetailsPF objectForKey:@"Code"];
    nameText.text=[MachineDetailsPF objectForKey:@"Machine_Name"];
    descriptionText.text=[MachineDetailsPF objectForKey:@"Description"];
    trackingFrequencyText.text=[MachineDetailsPF objectForKey:@"Tracking_Frequency"];
    locationText.text=[MachineDetailsPF objectForKey:@"Location"];
    capacityText.text=[MachineDetailsPF objectForKey:@"Capacity"];
    maintanceFrequencyText.text=[MachineDetailsPF objectForKey:@"Maintenance"];
    lastMaintanceDate.text=[MachineDetailsPF objectForKey:@"LastMaintain_Date"];
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)UpdateButton:(id)sender {
    
    NSString *code = [codeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trackingFrequency = [trackingFrequencyText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *location = [locationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *capacity = [capacityText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *maintainFrequency = [maintanceFrequencyText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *LastMaintainDate = [lastMaintanceDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([code length] == 0 ||[name length] == 0 ||[location length] == 0 ||[capacity length] == 0 ||[description length] == 0 ||[trackingFrequency length] == 0 ||[maintainFrequency length] == 0 ||[LastMaintainDate length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        
            
            if (MachineDetailsPF != nil) {
                [self updateNote];
            }
            else {
                [self saveNote];
            }
        }
    
}

- (void)saveNote
{
    
    PFObject *NewMachine = [PFObject objectWithClassName:@"Machine"];
    
    [NewMachine setObject:codeText.text forKey:@"Code"];
    [NewMachine setObject:nameText.text forKey:@"Machine_Name"];
    [NewMachine setObject:descriptionText.text forKey:@"Description"];
    [NewMachine setObject:trackingFrequencyText.text forKey:@"Tracking_Frequency"];
    [NewMachine setObject:locationText.text forKey:@"Location"];
    [NewMachine setObject:capacityText.text forKey:@"Capacity"];
    [NewMachine setObject:maintanceFrequencyText.text forKey:@"Maintenance"];
    [NewMachine setObject:lastMaintanceDate.text forKey:@"LastMaintain_Date"];

   
   
  //  NewMachine[@"Machine"] = [PFUser currentUser];
    
    [NewMachine saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Machine"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[MachineDetailsPF objectId] block:^(PFObject *UpdateMachine, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            [UpdateMachine setObject:codeText.text forKey:@"Code"];
            [UpdateMachine setObject:nameText.text forKey:@"Machine_Name"];
            [UpdateMachine setObject:descriptionText.text forKey:@"Description"];
            [UpdateMachine setObject:trackingFrequencyText.text forKey:@"Tracking_Frequency"];
            [UpdateMachine setObject:locationText.text forKey:@"Location"];
            [UpdateMachine setObject:capacityText.text forKey:@"Capacity"];
            [UpdateMachine setObject:maintanceFrequencyText.text forKey:@"Maintenance"];
            [UpdateMachine setObject:lastMaintanceDate.text forKey:@"LastMaintain_Date"];
            
            [UpdateMachine saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    [UIScrollView setAnimationBeginsFromCurrentState: YES];
    [UIScrollView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIScrollView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
