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
//#import "User.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize userEmailText,passwordText,loginButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    //PFObject *testObject = [PFObject objectWithClassName:@"User"];
   // testObject[@"foo"] = @"Akshay Tested";
   // [testObject saveInBackground];
  //  NSLog(@"SuccessFull");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Login:(id)sender{
    NSString *email = [userEmailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You have to enter a Email and password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (objects.count > 0) {
                
                PFObject *object = [objects objectAtIndex:0];
                NSString *username = [object objectForKey:@"username"];
                [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser* user, NSError* error){
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                            message:[error.userInfo objectForKey:@"error"]
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
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
                        [self performSegueWithIdentifier:@"LoginToMainMenuSegue" sender:self];
                    }
                }];
                
            }
            
            
        }];
    }
   }

- (IBAction)unwindToMainMenu:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.identifier isEqualToString:@"unwindToLoginSegue"]) {
        MainMenu *MainMenuVC = (MainMenu *)unwindSegue.sourceViewController;
        NSLog(@"The came from main menu are ");
    }

    
}

@end
