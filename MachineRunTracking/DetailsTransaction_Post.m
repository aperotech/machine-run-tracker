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

@implementation DetailsTransaction_Post {
    NSArray *unitsArray;
}

@synthesize DetialsTransaction_PostPF, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationItem.title = @"Post-Extraction";
    // Do any additional setup after loading the view.
    if (DetialsTransaction_PostPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_PostPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_PostPF objectForKey:@"Machine_Name"];
    }
    
    [self.activityIndicator startAnimating];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
     [query1 selectKeys:@[@"Name"]];
    [query1 whereKey:@"Type" equalTo:@"Post-Extraction"];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
   
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Parameters Found"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                self.PostExtractionArray=[[NSArray alloc]initWithArray:objects];
                
                self.RunProcessArray=[[NSMutableArray alloc]init];
                
                for (int i=0;i<[self.PostExtractionArray count];i++) {
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [self.RunProcessArray addObject:newString];
                   
                    //[activityIndicator stopAnimating];
                }                
                [self.tableView reloadData];
            }
            [self.activityIndicator stopAnimating];
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Post_Extraction"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
   
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
       
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found");
               
            }
            else {
          
                self.runArrayPost=[[NSArray alloc]initWithArray:runArray];
         
                [self.tableView reloadData];
            }
            
        }
    }];
    
    PFQuery *unitsQuery = [PFQuery queryWithClassName:@"Parameters"];
    [unitsQuery selectKeys:@[@"Units"]];
    [unitsQuery whereKey:@"Type" equalTo:@"Post-Extraction"];
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

-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    for (int i=0; i<self.RunProcessArray.count;i++) {
        if (indexPath.row==i) {
            NSString *parameterValue=[[self.runArrayPost objectAtIndex:0]objectForKey:[self.RunProcessArray objectAtIndex:i]];
            if ([parameterValue isEqualToString:@""] | (parameterValue == NULL)) {
                cell.parameterLabel.text=@"N/A";
            } else if ([[self.RunProcessArray objectAtIndex:i] rangeOfString:@"Time"].location != NSNotFound) {
                cell.parameterLabel.text = parameterValue;
            } else {
                cell.parameterLabel.text = [NSString stringWithFormat:@"%@ %@", parameterValue, [[unitsArray objectAtIndex:i] objectForKey:@"Units"]];
            }
            
            NSString* string1 =[NSString stringWithFormat:@"%@ :", [self.RunProcessArray objectAtIndex:i]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
