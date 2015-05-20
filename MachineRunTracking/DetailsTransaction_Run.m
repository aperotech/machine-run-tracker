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

@implementation DetailsTransaction_Run {
    UITextField *valueTextField;
    UILabel *headerLabel, *valueLabel;
    NSMutableArray *RunProcessArray;
    NSArray *runArrayRun;
}

@synthesize DetialsTransaction_RunPF;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicatorView startAnimating];
    
    self.navigationController.navigationItem.title=@"Process Run";
    if (DetialsTransaction_RunPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_RunPF objectForKey:@"Machine_Name"];
    }
    
    RunProcessArray = [[NSMutableArray alloc]init];
    runArrayRun = [[NSArray alloc]init];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process Run"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error!");
        } else {
            for (int i=0; i < objects.count ;i++) {
                [RunProcessArray addObject:[[objects objectAtIndex:i]valueForKey:@"Name"]];
            }
            [self.tableView reloadData];
            [self.activityIndicatorView stopAnimating];
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Run_Process"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        if(error){
            NSLog(@"Error!");
        } else {
            runArrayRun = runArray;
        //[[NSArray alloc]initWithArray:runArray];
//[self.tableView reloadData];
        }
NSLog(@"the run array run is %@",runArrayRun);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return YES ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return runArrayRun.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"DetailsPostExtractionHeaderCellIdentifier";
    DetailsProcessRunCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    //cell.backgroundColor=[UIColor lightGrayColor];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        CGRect frameText;
        
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            
            headerLabel = [[UILabel alloc] init]; // 10 px padding between each view
            headerLabel.preferredMaxLayoutWidth = 80;
            headerLabel.numberOfLines = 1;
            headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerLabel.textColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
            
            if (i == 0) {
                frameText=CGRectMake(10, 5, 80, 17);
            } else {
                frameText=CGRectMake(headerLabel.frame.origin.x+105*i, 5, 80, 17);
            }
            
            [headerLabel setFrame:frameText];
            headerLabel.tag = i + 1;
            
            headerLabel.text = [RunProcessArray objectAtIndex:i];
            
            //headerLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:headerLabel];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DetailsPostExtractionCellIdentifier";
    
    DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        CGRect frameText;
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            valueLabel = [[UILabel alloc] init];
            valueLabel.preferredMaxLayoutWidth = 80;
            valueLabel.numberOfLines = 0;
            valueLabel.lineBreakMode = NSLineBreakByCharWrapping;
            valueLabel.textColor = [UIColor blackColor];
            valueLabel.font = [UIFont systemFontOfSize:14.0];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                frameText=CGRectMake(10, 14, 80, 17);
            } else {
                frameText=CGRectMake(headerLabel.frame.origin.x+105*i, 14, 80, 17);
            }
            
            [valueLabel setFrame:frameText];
            valueLabel.tag = (indexPath.row * RunProcessArray.count)+i+1;
          
            valueLabel.text =[[runArrayRun objectAtIndex:indexPath.row]objectForKey:[RunProcessArray objectAtIndex:i]];
//NSLog(@"value label tag is %ld & the Value Text Is %@ & indexpath.row is %ld",valueLabel.tag,valueLabel.text,indexPath.row);
                [cell.contentView addSubview:valueLabel];
        }
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    //Change as per your table header hight
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
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