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

@synthesize UserButton, ParametersButton, TransactionsButton, MachineButton, activityIndicator, welcomeLabel, userLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", userName];
    
    if ([userType isEqualToString:@"Standard"]) {
        userLabel.text = @"My Details";
        [UserButton setImage:[UIImage imageNamed:@"UserProfileButton"] forState:UIControlStateNormal];
    }
    
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
       return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}*/

- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"UserLoginView"];
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
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
