//
//  MainMenu.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "MainMenu.h"
#import <Parse/Parse.h>
@implementation MainMenu
- (void)viewDidLoad {
    [super viewDidLoad];
  /*  PFObject *dynamicclassobj=[PFObject  objectWithClassName:@"CustomClass" ];
    
    if([dynamicclassobj save]) {
       NSLog(@"Successfully Created");
        PFObject *gameScore = [PFObject objectWithClassName:@"CustomClass"];
        gameScore[@"score"] = @1337;
         gameScore[@"myNumber"] = @"someValue";
        gameScore[@"ScoreName"] = @123123;
    gameScore[@"First_Name"] = @"Akshay";
    gameScore[@"Last_Name"] = @"Shrirao";
    gameScore[@"Nick_Name"] = @"Bunty";
    gameScore[@"Company_Name"] = @"Apero Technologies";
        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The object has been saved");
                // The object has been saved.
            } else {
                NSLog(@"here was a problem, check error.description");
                // There was a problem, check error.description
            }
        }];
       
      //  class created;
    
    }*/
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
    NSLog(@"Successfully Logout ");
    }
@end
