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

@implementation DetailsTransaction_Pre {
    NSArray *runArrayPre, *preExtractionArray, *unitsArray;
    NSMutableArray *RunProcessArray;
    NSInteger ObjectCount;
}

@synthesize Run_noLabel,RunDateLabel,RunDurationLabel,MachineNameLabel, preTransobject, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.activityIndicator startAnimating];
   
    if (preTransobject !=NULL) {
        Run_noLabel.text=[preTransobject objectForKey:@"Run_No"];
        RunDateLabel.text=[preTransobject objectForKey:@"Run_Date"];
        RunDurationLabel.text=[preTransobject objectForKey:@"Run_Duration"];
        MachineNameLabel.text=[preTransobject objectForKey:@"Machine_Name"];
    }
   
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 selectKeys:@[@"Name"]];
    [query1 whereKey:@"Type" equalTo:@"Pre-Extraction"];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
   
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Parameters For Pre Extraction"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                preExtractionArray=[[NSArray alloc]initWithArray:objects];
               
                RunProcessArray=[[NSMutableArray alloc]init];
                
                for (int i=0;i<[preExtractionArray count];i++) {
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [RunProcessArray addObject:newString];

                }
                [self.tableView reloadData];
                }
            
        }
        [self.activityIndicator stopAnimating];
    }];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Pre_Extraction"];
    [query2 whereKey:@"Run_No" equalTo:Run_noLabel.text];
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
  
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        [self.activityIndicator startAnimating];
        
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found");
            }
            else {
                    runArrayPre=[[NSArray alloc]initWithArray:runArray];

                [self.tableView reloadData];
            }
           
        }
        [self.activityIndicator stopAnimating];
    }];
    
    PFQuery *unitsQuery = [PFQuery queryWithClassName:@"Parameters"];
    [unitsQuery selectKeys:@[@"Units"]];
    [unitsQuery whereKey:@"Type" equalTo:@"Pre-Extraction"];
    unitsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [unitsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.activityIndicator startAnimating];
        if(error){
            NSLog(@"Error!");
        }
        else {
            unitsArray = [[NSArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return ObjectCount;
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
    
    for (int i=0; i<RunProcessArray.count;i++) {
        if (indexPath.row==i) {
            NSString *parameterValue=[[runArrayPre objectAtIndex:0]objectForKey:[RunProcessArray objectAtIndex:i]];
            if ([parameterValue isEqualToString:@""] | (parameterValue == NULL)) {
                cell.parameterLabel.text=@"N/A";
            } else if ([[RunProcessArray objectAtIndex:i] rangeOfString:@"Time"].location != NSNotFound) {
                cell.parameterLabel.text = parameterValue;
            } else {
                cell.parameterLabel.text = [NSString stringWithFormat:@"%@ %@", parameterValue, [[unitsArray objectAtIndex:i] objectForKey:@"Units"]];
            }
        
            NSString* string1 =[NSString stringWithFormat:@"%@ :",[RunProcessArray objectAtIndex:i]];
            NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            cell.ParameterNameLabel.text =string2;
        
        }
        
    }
    
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
        DetailsTransaction_RunObj.DetialsTransaction_RunPF = preTransobject;
    }
    else if ([segue.identifier isEqualToString:@"DetailsTransactionPreToPostSegue"]){
        DetailsTransaction_Post *DetailsTransaction_PostObj=(DetailsTransaction_Post *)segue.destinationViewController;
        DetailsTransaction_PostObj.DetialsTransaction_PostPF=preTransobject;
    }
    
}


@end
