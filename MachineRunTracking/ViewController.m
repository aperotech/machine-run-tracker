//
//  ViewController.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ViewController.h"
#import "MainMenu.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize emailTextField, passwordTextField, loginButton, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    //PFObject *testObject = [PFObject objectWithClassName:@"User"];
   // testObject[@"foo"] = @"Akshay Tested";
   // [testObject saveInBackground];
  //  NSLog(@"SuccessFull");
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *existingUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"userEmail"];
    if (![existingUser isEqualToString:@""]) {
        self.emailTextField.text = existingUser;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= 20 && range.length == 0)
        return NO;
    // Only characters in the NSCharacterSet you choose will insertable.
        if (textField ==emailTextField) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_@."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)Login:(id)sender{
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You have to enter a Email and password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self.activityIndicator startAnimating];
        
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"email" equalTo:self.emailTextField.text];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                PFObject *object = [objects objectAtIndex:0];
                if ([object[@"password"] isEqualToString:password]) {
                    //Saving username and email in NSUSerDefaults
                    [userData setObject:self.emailTextField.text forKey:@"userEmail"];
                    [userData setObject:object[@"userType"] forKey:@"userType"];
                    [userData setBool:YES forKey:@"userLoggedIn"];
                    [self.activityIndicator stopAnimating];
                    [self performSegueWithIdentifier:@"LoginToMainMenuSegue" sender:self];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                        message:@"Entered password is incorrect"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.activityIndicator stopAnimating];
                    [alertView show];
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [self.activityIndicator stopAnimating];
                [alertView show];
            }
        }];
        
        /*PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (objects.count > 0) {
                
                PFObject *object = [objects objectAtIndex:0];
                NSString *password = [object objectForKey:@"password"];
                [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser* user, NSError* error){
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                            message:[error.userInfo objectForKey:@"error"]
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        [self.activityIndicatorView stopAnimating];
                        [self performSegueWithIdentifier:@"LoginToMainMenuSegue" sender:self];
                    }
                }];
            }else{
                [PFUser logInWithUsernameInBackground: email password:password block:^(PFUser* user, NSError* error){
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                            message:[error.userInfo objectForKey:@"error"]
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        [self.activityIndicatorView stopAnimating];
                        [self performSegueWithIdentifier:@"LoginToMainMenuSegue" sender:self];
                    }
                }];
                
            }
            
            
        }];*/
    }
   }

/*- (IBAction)unwindToMainMenu:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.identifier isEqualToString:@"unwindToLoginSegue"]) {
        //MainMenu *MainMenuVC = (MainMenu *)unwindSegue.sourceViewController;
        NSLog(@"The came from main menu are ");
    }

    
}*/

@end
