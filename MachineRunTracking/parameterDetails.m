//
//  parameterDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "parameterDetails.h"

@interface parameterDetails ()

@end

@implementation parameterDetails
@synthesize nameText,descriptionText,typeText,unitsText;
@synthesize parameterDetailsPF;
- (void)viewDidLoad {
    [super viewDidLoad];
   //  self.navigationController.navigationBar.topItem.title=@"";
    
    if (parameterDetailsPF != nil) {
        nameText.text=[parameterDetailsPF objectForKey:@"Name"];
       
        descriptionText.text=[parameterDetailsPF objectForKey:@"Description"];
        typeText.text=[parameterDetailsPF objectForKey:@"Type"];
        unitsText.text=[parameterDetailsPF objectForKey:@"Units"];
        
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)UpdateButton:(id)sender {
    
    NSString *name = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *type = [typeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Units = [unitsText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([name length] == 0 ||[description length] == 0 ||[type length] == 0 ||[Units length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        
        
        if (parameterDetailsPF != nil) {
            [self updateNote];
        }
        else {
            [self saveNote];
        }
    }
    
}

- (void)saveNote
{
    
    PFObject *NewParameter = [PFObject objectWithClassName:@"Parameters"];
    
    
    [NewParameter setObject:nameText.text forKey:@"Name"];
    [NewParameter setObject:descriptionText.text forKey:@"Description"];
    [NewParameter setObject:typeText.text forKey:@"Type"];
    [NewParameter setObject:unitsText.text forKey:@"Units"];
    
    
    
    
    //  NewMachine[@"Machine"] = [PFUser currentUser];
    
    [NewParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parameters"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[parameterDetailsPF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            [UpdateParameter setObject:nameText.text forKey:@"Name"];
            [UpdateParameter setObject:descriptionText.text forKey:@"Description"];
            [UpdateParameter setObject:typeText.text forKey:@"Type"];
            [UpdateParameter setObject:unitsText.text forKey:@"Units"];
            
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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
