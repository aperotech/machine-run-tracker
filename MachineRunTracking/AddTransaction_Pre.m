//
//  AddTransaction_Pre.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Pre.h"
//#import "AddTransaction_PreCell.h"
#import "AddTransaction_Run.h"
#import "AddTransaction_Post.h"
#import <Parse/Parse.h>
@interface AddTransaction_Pre ()

@end

@implementation AddTransaction_Pre

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupViewControllers];
  [self setupUI];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationItem.title=@"Pre";
    Pre_extractionFlag=0;
     NSLog(@"AddTransaction_Pre Loaded!");
    // Do any additional setup after loading the view.
   // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parameters"];
    [query whereKey:@"Type" equalTo:@"Post_Extraction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"all types: %ld",objects.count);
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
             //   NSLog(@"objectArray %@",objects);
            }
            
        }
    }];

}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ObjectCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Pre_ExtractionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }


    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Segemented controll
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl*)segmentedControl
{
   // UIViewController *vc;
    //NSLog(@"index: %ld", self.segmentedControl.selectedSegmentIndex);
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
          //   vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Pre_ID"];
          //  [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"Segment Pre selected.");
            //[self performSegueWithIdentifier:@"segmentedLocationToPreExtractionSegue" sender:segmentedControl];
            // BasicTransactionToPreExtrationSegue
            //segmentedLocationToPreExtractionSegue
            break;
        case 1:
            // vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Run_ID"];
            //[self presentViewController:vc animated:NO completion:nil];
            NSLog(@"Segment Run selected.");
           [self performSegueWithIdentifier:@"PreToRunExtractionSegue"  sender:segmentedControl ];
            // PreToRunExtractionSegue
            //segmentedLocationToRunExtractionSegue
            break;
            
        case 2:
            // vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Post_ID"];
            //[self presentViewController:vc animated:NO completion:nil];
            NSLog(@"Segment Post selected.");
            Pre_extractionFlag=1;
            //AddTransaction_Post addTransaction_PostObj=[[AddTransaction_Post alloc]init];
           // addTransaction_PostObj.Pre_
            [self performSegueWithIdentifier:@"PreToPostExtractionSegue" sender:segmentedControl];
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
