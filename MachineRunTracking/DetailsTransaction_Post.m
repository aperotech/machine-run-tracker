//
//  DetailsTransaction_Post.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "DetailsTransaction_Post.h"
#import "DetailsPostCell.h"
#import "SegmentedControlVC.h"

@interface DetailsTransaction_Post ()

@end

@implementation DetailsTransaction_Post
@synthesize DetialsTransaction_PostPF;
- (void)viewDidLoad {
    [super viewDidLoad];
  //  NSLog(@"The Post Loaded");
     //self.navigationController.navigationBar.topItem.title=@"";
     self.navigationController.navigationItem.title=@"Post-extraction";
    // Do any additional setup after loading the view.
    if (DetialsTransaction_PostPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_PostPF objectForKey:@"Machine_Name"];
    }
    // Do any additional setup after loading the view.
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Post_Extraction"];
   // NSLog(@"The Query For Post_Extraction %@",query1);
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
     //   NSLog(@"all types 1: %ld",(long)objects.count);
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
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Post_Extraction"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
   // NSLog(@"The Query For loade objecs %@",query2);
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
     //   NSLog(@"all types: %ld",(long)runArray.count);
        //self.ObjectCount=runArray.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found");
            }
            else {
          //      NSLog(@"The Objecds Are %@",runArray);
                self.runArrayPost=[[NSArray alloc]initWithArray:runArray];
         //       NSLog(@"The RunArray Post Are %@",self.runArrayPost);
                [self.tableView reloadData];
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
    }];
    
    

}
-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ //NSLog(@"The No Of ROws %ld",self.ObjectCount);
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    return self.ObjectCount ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DetailsPostExtractionCellIdentifier";
    
    DetailsPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DetailsPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor=[UIColor grayColor];
    }
    cell.parameterLabel.tag=indexPath.row;
    if (indexPath.row==0) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_1"];
        [[self.runArrayPost objectAtIndex:0]objectForKey:@"Parameter_1"];
        cell.ParameterNameLabel.text=@"Parameter_1 :";
        //NSLog(@"Index Path Row 0 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==1) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_2"];
        [[self.runArrayPost objectAtIndex:0]objectForKey:@"Parameter_2"];
        cell.ParameterNameLabel.text=@"Parameter_2 :";
        //NSLog(@"Index Path Row 1 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==2) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_3"];
        [[self.runArrayPost objectAtIndex:0]objectForKey:@"Parameter_3"];
        cell.ParameterNameLabel.text=@"Parameter_3 :";
       // NSLog(@"Index Path Row 2 %@",cell.parameterLabel.text);
    }
    if (indexPath.row==3) {
        cell.parameterLabel.text=//[[PFObject objectWithClassName:@"Pre_Extraction"] objectForKey:@"Parameter_4"];
        [[self.runArrayPost objectAtIndex:0 ]objectForKey:@"Parameter_4"];
        cell.ParameterNameLabel.text=@"Parameter_4 :";
       // NSLog(@"Index Path Row 3 %@",cell.parameterLabel.text);
    }
    // cell.textLabel.tag=indexPath.row;
    // Configure the cell...
    
    
    return cell;
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
