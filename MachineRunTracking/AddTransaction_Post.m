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
     self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationItem.title=@"Post";
    [self setupUI];
     NSLog(@"AddTransaction_POst Loaded!");
    // Do any additional setup after loading the view.
}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma Segemented controll
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl
{
  //  UIViewController *vc;
    //NSLog(@"index: %ld", self.segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            if (Pre_ExtractionPostFlag==0) {
                 [self.navigationController popViewControllerAnimated:YES];
               // vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Pre_ID"];
                 // [self presentViewController:vc animated:NO completion:nil];
            } else {
               //  [self.navigationController popViewControllerAnimated:YES];
            }
            NSLog(@"Segment Pre selected.");
          // vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Pre_ID"];
          //  [self presentViewController:vc animated:NO completion:nil];
            //  [self performSegueWithIdentifier:@"segmentedLocationToPreExtractionSegue" sender:segmentedControl];
            // BasicTransactionToPreExtrationSegue
            //segmentedLocationToPreExtractionSegue
            break;
        case 1:
           //  vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Run_ID"];
           // [self presentViewController:vc animated:NO completion:nil];
             [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"Segment Run selected.");
           // [self performSegueWithIdentifier:@"segmentedLocationToRunExtractionSegue" sender:segmentedControl];
            // PreToRunExtractionSegue
            //segmentedLocationToRunExtractionSegue
            break;
            
        case 2:
           //  vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Post_ID"];
          //  [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"Segment Post selected.");
           // [self performSegueWithIdentifier:@"segmentedLocationToPostExtractionSegue" sender:segmentedControl];
            //PreToPostExtractionSegue
            //segmentedLocationToPostExtractionSegue
        default:
            break;
    }
    
}
- (void)setupUI
{
    [self.segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
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
