//
//  MainMenu.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "MainMenu.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "UserDetails.h"
#import "UserList.h"
#import "LoginViewController.h"

@interface MainMenu ()

@end

@implementation MainMenu {
    NSString *userType, *userEmail, *userName;
}

@synthesize UserButton, ParametersButton, TransactionsButton, MachineButton, activityIndicator, welcomeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", userName];
    
    if ([userType isEqualToString:@"Standard"]) {
        [UserButton setTitle:@"My Details" forState:UIControlStateNormal];
    }
    
    self.navigationItem.rightBarButtonItem.enabled=YES;
    UserButton.layer.borderWidth=1.0f;
    UserButton.layer.borderColor=[[UIColor blackColor]CGColor];
    ParametersButton.layer.borderWidth=1.0f;
    ParametersButton.layer.borderColor=[[UIColor blackColor]CGColor];
    TransactionsButton.layer.borderWidth=1.0f;
    TransactionsButton.layer.borderColor=[[UIColor blackColor]CGColor];
    MachineButton.layer.borderWidth=1.0f;
    MachineButton.layer.borderColor=[[UIColor blackColor]CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}
- (IBAction)logout:(id)sender {
    //PFUser *currentUser = [PFUser currentUser];
    //[PFUser logOut];
   // [self.navigationController popViewControllerAnimated:YES];
    // this will now be nil
   //  [self performSegueWithIdentifier:@"unwindToLoginSegue" sender:self];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"UserLoginView"];
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
    //NSLog(@"Successfully Logout ");
    }

-(IBAction)UserButtonClick:(id)sender{
    
    if ([userType isEqualToString:@"Admin"]) {
        [self performSegueWithIdentifier:@"MainMenuToUserListSegue" sender:self];
    } else {
        [self.activityIndicator startAnimating];
        
        //Fetch current user object
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"email" equalTo:userEmail];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                self.stdUserObject = [objects objectAtIndex:0];
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"StandardUserMainMenuToUserDetailsSegue" sender:self];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [self.activityIndicator stopAnimating];
                [alertView show];
            }
        }];
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"StandardUserMainMenuToUserDetailsSegue"]) {
         UserDetails *currentUser = segue.destinationViewController;
         currentUser.userObject = self.stdUserObject;
     }
     /*if ([segue.identifier isEqualToString:@"MainMenuToUserListSegue"]) {
         UserList *userListObj = (UserList *)segue.destinationViewController;
        // userdetailsObj.UpdateObjPF = self.stdUserObject;
     }*/     
 }
 
@end
