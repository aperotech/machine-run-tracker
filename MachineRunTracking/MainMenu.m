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
    
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
@end
