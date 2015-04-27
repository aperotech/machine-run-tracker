//
//  DetailsTransaction_Pre.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "DetailsTransaction_Pre.h"
#import "DetailsPreCell.h"
#import "DetailsTransaction_Post.h"
#import "DetailsTransaction_Run.h"
#import "SegmentedControlVC.h"
@interface DetailsTransaction_Pre ()

@end

@implementation DetailsTransaction_Pre
@synthesize Run_noLabel,RunDateLabel,RunDurationLabel,MachineNameLabel;

@synthesize DetialsTransaction_PrePF;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (DetialsTransaction_PrePF !=NULL) {
        Run_noLabel.text=[DetialsTransaction_PrePF objectForKey:@"Run_No"];
        RunDateLabel.text=[DetialsTransaction_PrePF objectForKey:@"Run_Date"];
        RunDurationLabel.text=[DetialsTransaction_PrePF objectForKey:@"Run_Duration"];
        MachineNameLabel.text=[DetialsTransaction_PrePF objectForKey:@"Machine_Name"];
    }
    // Do any additional setup after loading the view.
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Pre_Extraction"];
    NSLog(@"The Query For Pre_Extraction %@",query1);
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types1: %ld",(long)objects.count);
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
                [self.tableView reloadData];
                }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
    }];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Pre_Extraction"];
    [query2 whereKey:@"Run_No" equalTo:Run_noLabel.text];
    NSLog(@"The Query For loade objecs %@",query2);
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types2: %ld",(long)runArray.count);
        //self.ObjectCount=runArray.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found");
            }
            else {
                NSLog(@"The Objecds Are %@",runArray);
                self.runArrayPre=[[NSArray alloc]initWithArray:runArray];
                NSLog(@"The RunArray Pre Are %@",self.runArrayPre);
                [self.tableView reloadData];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
    }];


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ NSLog(@"The No Of ROws %ld",self.ObjectCount);
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    return self.ObjectCount ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Pre_ExtractionCellIdentifier";
    
    DetailsPreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DetailsPreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor=[UIColor grayColor];
    }
    cell.parameterLabel.tag=indexPath.row;
    if (indexPath.row==0) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_1"];
       [[self.runArrayPre objectAtIndex:0]objectForKey:@"Parameter_1"];
        NSLog(@"Index Path Row 0 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==1) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_2"];
        [[self.runArrayPre objectAtIndex:0]objectForKey:@"Parameter_2"];
        NSLog(@"Index Path Row 1 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==2) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_3"];
        [[self.runArrayPre objectAtIndex:0]objectForKey:@"Parameter_3"];
        NSLog(@"Index Path Row 2 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==3) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_4"];
        [[self.runArrayPre objectAtIndex:0 ]objectForKey:@"Parameter_4"];
        NSLog(@"Index Path Row 3 %@",cell.parameterLabel.text);
    }
   // cell.textLabel.tag=indexPath.row;
    // Configure the cell...
    
    
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"DetailsPreToDetailsRunSegue"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      //  PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        DetailsTransaction_Run *DetailsTransaction_RunObj = (DetailsTransaction_Run *)segue.destinationViewController;
        DetailsTransaction_RunObj.DetialsTransaction_RunPF = DetialsTransaction_PrePF;
    }
    else if ([segue.identifier isEqualToString:@"DetailsTransactionPreToPostSegue"]){
        DetailsTransaction_Post *DetailsTransaction_PostObj=(DetailsTransaction_Post *)segue.destinationViewController;
        DetailsTransaction_PostObj.DetialsTransaction_PostPF=DetialsTransaction_PrePF;
    }
    
}


@end
