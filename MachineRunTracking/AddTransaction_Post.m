//
//  AddTransaction_Post.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Post.h"

@interface AddTransaction_Post ()

@end

@implementation AddTransaction_Post

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma Segemented controll
-(IBAction) segmentedControlIndexChanged
{
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
            
            NSLog(@"Segment Pre selected.");
            break;
        case 1:
            NSLog(@"Segment Run selected.");
            break;
            
        case 2:
            NSLog(@"Segment Post selected.");
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
