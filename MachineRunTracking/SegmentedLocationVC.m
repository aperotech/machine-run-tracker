//
//  SegmentedLocationVC.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 15/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "SegmentedLocationVC.h"
#import "ContainerViewController.h"
#import "AddTransaction_Pre.h"
#import "AddTransaction_Post.h"
#import "AddTransaction_Run.h"
@interface SegmentedLocationVC ()

@property (nonatomic, weak) ContainerViewController *containerViewController;

@property(nonatomic,strong)AddTransaction_Pre *AddTransaction_Pre;
@property (nonatomic,strong)AddTransaction_Run *AddTransaction_Run;
@property (nonatomic,strong)AddTransaction_Post *AddTransaction_Post;

@end

@implementation SegmentedLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self setupUI];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Segemented controll
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"SegementedToViewControllerSegue"]) {
        self.containerViewController = segue.destinationViewController;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl
{
    
    //NSLog(@"index: %ld", self.segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self.containerViewController swapViewControllers];
            NSLog(@"Segment Pre selected.");
         //   vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Pre_ID"];
           //  [self presentViewController:vc animated:NO completion:nil];
          //  [self.containerViewController swapViewControllers];
          //  [self performSegueWithIdentifier:@"segmentedLocationToPreExtractionSegue" sender:segmentedControl];
            // BasicTransactionToPreExtrationSegue
            //segmentedLocationToPreExtractionSegue
            break;
        case 1:
             [self.containerViewController swapViewControllers];
            //vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Run_ID"];
             // [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"Segment Run selected.");
           // [self performSegueWithIdentifier:@"SegementedToViewControllerSegue" sender:segmentedControl];
            // PreToRunExtractionSegue
            //segmentedLocationToRunExtractionSegue
            break;
            
        case 2:
            NSLog(@"Segment Post selected.");
            [self.containerViewController swapViewControllers];
           // vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Post_ID"];
          //   [self presentViewController:vc animated:NO completion:nil];
           //  [self.containerViewController swapViewControllers];
           // [self performSegueWithIdentifier:@"segmentedLocationToPostExtractionSegue" sender:segmentedControl];
            //PreToPostExtractionSegue
            //segmentedLocationToPostExtractionSegue
        default:
            break;
    }
    
}

/*- (void)setupViewControllers
 {
 AddTransaction_Run *AddTransaction_RunVC = [[AddTransaction_Run alloc] init];
 AddTransaction_Post *AddTransaction_PostVC = [[AddTransaction_Post alloc] init];
 AddTransaction_Pre *AddTransaction_PreVC=[AddTransaction_Pre self];
 self.viewControllers = [NSArray arrayWithObjects:AddTransaction_PreVC,AddTransaction_RunVC,AddTransaction_PostVC, nil];
 }*/

- (void)setupUI
{
    [self.segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
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
