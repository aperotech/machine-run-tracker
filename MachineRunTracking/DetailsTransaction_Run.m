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
    UILabel *headerLabel, *valueLabel;
    NSMutableArray *RunProcessArray, *unitsArray;
    NSArray *runArrayRun;
    int cacheFlag;
}

@synthesize DetialsTransaction_RunPF, activityIndicator, scrollView, tableHeight, tableWidth;

- (void)viewDidLoad {
    [super viewDidLoad];
    cacheFlag = 0;
    
    self.tableHeight.constant = self.view.frame.size.width;
    self.tableWidth.constant = self.view.frame.size.height;
    [self.tableView layoutIfNeeded];
    
    self.navigationController.navigationItem.title=@"Process Run";
    if (DetialsTransaction_RunPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_RunPF objectForKey:@"Machine_Name"];
    }
    
    RunProcessArray = [[NSMutableArray alloc]init];
    runArrayRun = [[NSArray alloc]init];
    unitsArray = [[NSMutableArray alloc]init];
    
    [self.activityIndicator startAnimating];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process Run"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //BOOL isInCache = [query1 hasCachedResult];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error!");
        } else {
            if (cacheFlag == 0) {
                for (int i=0; i < objects.count ;i++) {
                    [RunProcessArray addObject:[[objects objectAtIndex:i]valueForKey:@"Name"]];
                    [unitsArray addObject:[[objects objectAtIndex:i]valueForKey:@"Units"]];
                }
                cacheFlag = 1;
                [self.tableView reloadData];
                [self.activityIndicator stopAnimating];
            }
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Run_Process"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
    [query2 orderByAscending:@"createdAt"];
    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        if(error){

        } else {
            runArrayRun = runArray;
            [self.tableView reloadData];
        }
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 60.0f;
    else
        return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"DetailsProcessRunHeaderCellIdentifier";
    DetailsProcessRunCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        CGRect frameText;
        
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            
            headerLabel = [[UILabel alloc] init]; // 10 px padding between each view
            headerLabel.numberOfLines = 0;
            headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerLabel.textColor = [UIColor whiteColor];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                headerLabel.preferredMaxLayoutWidth = 100;
                headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
                if (i == 0) {
                    frameText = CGRectMake(10, 5, 100, 50);
                } else {
                    frameText=CGRectMake(headerLabel.frame.origin.x+130*i, 5, 100, 50);
                }
            }
            else {
                headerLabel.preferredMaxLayoutWidth = 90;
                headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 5, 90, 40);
                } else {
                    frameText=CGRectMake(headerLabel.frame.origin.x+110*i, 5, 90, 40);
                }
            }
            
            [headerLabel setFrame:frameText];
            headerLabel.tag = i + 1;
            
            NSString* string1 = [RunProcessArray objectAtIndex:i];
            NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            
            headerLabel.text = string2;
            cell.backgroundColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:headerLabel];
        }
    }
    if ((headerLabel.frame.origin.x + headerLabel.frame.size.width) >= self.view.frame.size.height) {
        self.tableWidth.constant = (headerLabel.frame.origin.x + headerLabel.frame.size.width + 10);
    }
    
    if (self.tableView.frame.size.height >= self.scrollView.frame.size.height) {
        self.tableHeight.constant = self.tableView.frame.size.height;
    }
    
    [self.tableView layoutIfNeeded];
     
    [self.scrollView setContentSize:CGSizeMake(self.tableWidth.constant, self.tableHeight.constant)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DetailsProcessRunCellIdentifier";
    
    DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        CGRect frameText;
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            valueLabel = [[UILabel alloc] init];
            valueLabel.numberOfLines = 0;
            valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
            valueLabel.textColor = [UIColor blackColor];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                valueLabel.preferredMaxLayoutWidth = 100;
                valueLabel.font = [UIFont systemFontOfSize:16.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 7, 100, 30);
                } else {
                    frameText=CGRectMake(valueLabel.frame.origin.x+130*i, 7, 100, 30);
                }
            } else {
                valueLabel.font = [UIFont systemFontOfSize:14.0];
                valueLabel.preferredMaxLayoutWidth = 90;
                if (i == 0) {
                    frameText=CGRectMake(10, 7, 90, 30);
                } else {
                    frameText=CGRectMake(valueLabel.frame.origin.x+110*i, 7, 90, 30);
                }
            }
            valueLabel.textAlignment = NSTextAlignmentLeft;
            [valueLabel setFrame:frameText];
            valueLabel.tag = (indexPath.row * RunProcessArray.count)+i+1;
          
            NSString *parameterValue=[[runArrayRun objectAtIndex:indexPath.row]objectForKey:[RunProcessArray objectAtIndex:i]];
            if ([parameterValue isEqualToString:@""] | (parameterValue == NULL)) {
            valueLabel.text = @"N/A";
            } else if ([[RunProcessArray objectAtIndex:i] rangeOfString:@"Time"].location != NSNotFound) {
                valueLabel.text = parameterValue;
            } else {
                valueLabel.text = [NSString stringWithFormat:@"%@ %@", parameterValue, [unitsArray objectAtIndex:i]];
            }
                [cell.contentView addSubview:valueLabel];
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
    if ([segue.identifier isEqualToString:@"DetailsRunToDetailsPostSegue"]){
        DetailsTransaction_Post *DetailsTransaction_PostObj=(DetailsTransaction_Post *)segue.destinationViewController;
        DetailsTransaction_PostObj.DetialsTransaction_PostPF=DetialsTransaction_RunPF;
    }
    
}


@end