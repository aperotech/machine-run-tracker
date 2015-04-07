//
//  UserList.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserList.h"
#import "UserListCell.h"
@implementation UserList
//MainMenuToUserListSegue
//userListTouserDetailsSegue
//userListToAddUserSegue


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query getObjectInBackgroundWithId:@"LwuCtb71E9" block:^(PFObject *User, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
     //   NSString *Name = User[@"Name"];
     //    NSString *password = User[@"Password"];
      //   NSString *UserType = User[@"User_type"];
      //   NSString *email = User[@"User_Email"];
       
       
        
           }];
  }
   /* PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"Name" equalTo:@"Akshay"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
