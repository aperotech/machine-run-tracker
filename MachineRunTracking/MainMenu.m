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

@implementation MainMenu

@synthesize UserButton,ParametersButton,TransactionsButton,MachineButton;
@synthesize activityIndicatorView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    UserButton.layer.borderWidth=1.0f;
    UserButton.layer.borderColor=[[UIColor blackColor]CGColor];
    ParametersButton.layer.borderWidth=1.0f;
    ParametersButton.layer.borderColor=[[UIColor blackColor]CGColor];
    TransactionsButton.layer.borderWidth=1.0f;
    TransactionsButton.layer.borderColor=[[UIColor blackColor]CGColor];
    MachineButton.layer.borderWidth=1.0f;
    MachineButton.layer.borderColor=[[UIColor blackColor]CGColor];
    
    [[PFUser currentUser] fetchInBackgroundWithBlock:nil];
    self.CurrentUser = [PFUser currentUser];
    [activityIndicatorView stopAnimating];
   // StandardUserMainMenuToUserDetailsSegue
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    //PFUser *currentUser = [PFUser currentUser];
    [PFUser logOut];
   // [self.navigationController popViewControllerAnimated:YES];
    // this will now be nil
   //  [self performSegueWithIdentifier:@"unwindToLoginSegue" sender:self];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    ViewController *add =
    [storyboard instantiateViewControllerWithIdentifier:@"UserLoginView"];
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
    //NSLog(@"Successfully Logout ");
    }

-(IBAction)UserButtonClick:(id)sender{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"usertype" equalTo:@"Standard"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!object) {
            
            self.PermissionFlag = TRUE;
            //NSLog(@"The Transaction Currenet User Is %@ ",object );
            [self performSegueWithIdentifier:@"MainMenuToUserListSegue" sender:self];
            // Did not find any UserStats for the current user
        } else {
           
            self.MainMenuObjPF=object;
            self.navigationItem.rightBarButtonItem.enabled=FALSE;
            self.PermissionFlag = FALSE;
            [self performSegueWithIdentifier:@"StandardUserMainMenuToUserDetailsSegue" sender:self];
         
        }
    }];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"StandardUserMainMenuToUserDetailsSegue"]) {
         UserDetails *userdetailsObj = (UserDetails *)segue.destinationViewController;
         userdetailsObj.UpdateObjPF = self.MainMenuObjPF;
     }
     /*if ([segue.identifier isEqualToString:@"MainMenuToUserListSegue"]) {
         UserList *userListObj = (UserList *)segue.destinationViewController;
        // userdetailsObj.UpdateObjPF = self.MainMenuObjPF;
     }*/

     
 }
 
@end
