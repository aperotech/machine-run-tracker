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

@implementation parameterDetails {
    NSString *userType;
}

@synthesize nameText,descriptionText,typeText,unitsText, parameterObject, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (parameterObject != nil) {
        nameText.text=[parameterObject objectForKey:@"Name"];
        descriptionText.text=[parameterObject objectForKey:@"Description"];
        typeText.text=[parameterObject objectForKey:@"Type"];
        unitsText.text=[parameterObject objectForKey:@"Units"];
    }
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        [self.descriptionText setUserInteractionEnabled:FALSE];
        [self.unitsText setUserInteractionEnabled:FALSE];
        [self.navigationItem.rightBarButtonItem setEnabled:FALSE];
    }
}

#pragma mark - Textfield delegate

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.typeText ) {
        return NO;
    }
    
    if (textField.text.length >= 40 && range.length == 0)
        return NO;
    // Only characters in the NSCharacterSet you choose will insertable.
     if ([textField isEqual:unitsText]) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/_"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameText) {
        [self.unitsText becomeFirstResponder];
    }else if (textField == self.descriptionText) {
        [self.unitsText becomeFirstResponder];
    } else if (textField == self.unitsText) {
        [self.unitsText resignFirstResponder];
    }
    return YES;
}

- (IBAction)UpdateButton:(id)sender {
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Units = [unitsText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([description length] == 0 ||[Units length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        if (parameterObject != nil) {
            [self updateNote];
        }
    }
}

- (void)updateNote {
    [self.activityIndicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Parameters"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[parameterObject objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.activityIndicator stopAnimating];
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
                    [self.activityIndicator stopAnimating];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.activityIndicator stopAnimating];
                    [alertView show];
                }
            }];
        }
    }];
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
