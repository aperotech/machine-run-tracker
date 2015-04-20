//
//  AddTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Run.h"

@interface AddTransaction_Run ()

@end

@implementation AddTransaction_Run

@synthesize Parameter0,Parameter1,Parameter2;
- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"AddTransaction_Run Loaded!");
    
    // Do any additional setup after loading the view.
}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)SaveAndForward:(id)sender {
    [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
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
