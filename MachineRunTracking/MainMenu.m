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
@implementation MainMenu

@synthesize UserButton,ParametersButton,TransactionsButton,MachineButton;

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)logout:(id)sender {
    [PFUser logOut];
   // PFUser *currentUser = [PFUser currentUser]; // this will now be nil
     //[self performSegueWithIdentifier:@"unwindToLoginSegue" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"Successfully Logout ");
    }
@end
