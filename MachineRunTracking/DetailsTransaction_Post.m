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
    [self.activityIndicatorView startAnimating];
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
     [query1 selectKeys:@[@"Name"]];
    [query1 whereKey:@"Type" equalTo:@"Post-Extraction"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
   
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
                   
                    //[activityIndicatorView stopAnimating];
                }
                

                
                
                
                [self.tableView reloadData];
            }
            [self.activityIndicatorView stopAnimating];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
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
            
            cell.parameterLabel.text=[[self.runArrayPost objectAtIndex:0]objectForKey:[self.RunProcessArray objectAtIndex:i]];
            cell.ParameterNameLabel.text = [NSString stringWithFormat:@"%@ :", [self.RunProcessArray objectAtIndex:i]];
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
