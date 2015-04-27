//
//  DetailsTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "DetailsTransaction_Run.h"
#import "SegmentedControlVC.h"
#import "DetailsTransaction_Post.h"
#import "DetailsProcessRunCell.h"
@interface DetailsTransaction_Run ()

@end

@implementation DetailsTransaction_Run
@synthesize DetialsTransaction_RunPF;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (DetialsTransaction_RunPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_RunPF objectForKey:@"Machine_Name"];
    }
    // Do any additional setup after loading the view.
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process_run"];
    NSLog(@"The Query For RunProcess %@",query1);
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types: %ld",(long)objects.count);
        //self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found1");
            }
            else {
                [self.tableView reloadData];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Run_Process"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
    NSLog(@"The Query For loade objecs %@",query2);
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types: %ld",(long)runArray.count);
        self.ObjectCount=runArray.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found2");
            }
            else {
                NSLog(@"The Objecds Are %@",runArray);
                self.runArrayRun=[[NSArray alloc]initWithArray:runArray];
                NSLog(@"The RunArray Pre Are %@",self.runArrayRun);
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
    return self.ObjectCount + 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *simpleTableIdentifier = @"DetailsPostExtractionHeaderCellIdentifier";
        
        DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[DetailsProcessRunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
           
        }
 cell.backgroundColor=[UIColor grayColor];
        cell.IntervalText.text = @"Interval";
        cell.ParametersText.text = @"Parameter_1";
        cell.Parameters1Text.text=@"Parameter_2";
        cell.Parameters2Text.text=@"Parameter_3";
        cell.Parameters3Text.text=@"Parameter_4";
        cell.ValueText.text = @"Value";
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
    else{
    
    static NSString *simpleTableIdentifier = @"DetailsPostExtractionCellIdentifier";
    
    DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DetailsProcessRunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
      //  cell.backgroundColor=[UIColor grayColor];
    }
    //cell.parameterLabel.tag=indexPath.row;
   /* if (indexPath.row==0) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_1"];
        [[self.runArrayRun objectAtIndex:0]objectForKey:@"Parameter_1"];
        NSLog(@"Index Path Row 0 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==1) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_2"];
        [[self.runArrayRun objectAtIndex:0]objectForKey:@"Parameter_2"];
        NSLog(@"Index Path Row 1 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==2) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_3"];
        [[self.runArrayRun objectAtIndex:0]objectForKey:@"Parameter_3"];
        NSLog(@"Index Path Row 2 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==3) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_4"];
        [[self.runArrayPost objectAtIndex:0 ]objectForKey:@"Parameter_4"];
        NSLog(@"Index Path Row 3 %@",cell.parameterLabel.text);
    }*/
    // cell.textLabel.tag=indexPath.row;
    // Configure the cell...
    
        cell.IntervalText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Interval"];
        cell.ParametersText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_1"];
        cell.Parameters1Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_2"];
        cell.Parameters2Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_3"];
        cell.Parameters3Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_4"];
        cell.ValueText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Value"];
    return cell;
    }
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
    if ([segue.identifier isEqualToString:@"DetailsRunToDetailsPostSegue"]){
        DetailsTransaction_Post *DetailsTransaction_PostObj=(DetailsTransaction_Post *)segue.destinationViewController;
        DetailsTransaction_PostObj.DetialsTransaction_PostPF=DetialsTransaction_RunPF;
    }

}


@end
