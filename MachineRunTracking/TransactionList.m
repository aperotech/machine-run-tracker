//
//  TransactionList.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "TransactionList.h"
#import "TransactionListCell.h"
#import "AddTransaction_Basic.h"
#import "DetailsTransaction_Pre.h"
#import "AddTransaction_Post.h"
#import "SegmentedControlVC.h"
#import "AddTransaction_Pre.h"
#import "AddTransaction_Run.h"
#import "MainMenu.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface TransactionList ()

@end

@implementation TransactionList {
    NSString *userType;
    int flag, machineCount, parameterCount;
    UIView *cellView;
    UILabel *runNoLabel, *machineNameLabel, *runDateLabel;
    NSMutableArray *transactions;
}

@synthesize activityIndicatorView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Transaction";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = 0;
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        flag = 1;
     }
    
    //Run queries to check if machines & parameters exist. This is to decide whether a new transaction can be created or not.
    PFQuery *machineQuery = [PFQuery queryWithClassName:@"Machine"];
    [machineQuery selectKeys:@[@"Machine_Name"]];
    machineQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [machineQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error)
            machineCount = count;
        else {
            NSLog(@"Error is %@", error.description);
        }
    }];
    
    PFQuery *parameterQuery = [PFQuery queryWithClassName:@"Parameters"];
    [parameterQuery selectKeys:@[@"Name"]];
    parameterQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [parameterQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error)
            parameterCount = count;
        else {
            NSLog(@"Error is %@", error.description);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [self refreshTable:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable:(NSNotification *) notification {
    [self loadObjects];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByAscending:@"Run_No"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

- (void) objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [error localizedDescription];

    if (self.objects.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction List Empty" message:@"You can create a new transaction by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    } else {
        transactions = [[NSMutableArray alloc] initWithArray:self.objects];
        [self.tableView reloadData];
    }
}

/*- (BOOL)shouldAutorotate {
BOOL allowRotation = YES;
    
    if ([self isKindOfClass:[self.navigationController class]])
    {
        allowRotation = NO;
    }
    if ([self isKindOfClass:[self.childViewControllers class]])
    {
        allowRotation = YES;
    }
    return allowRotation;
 
    return YES;
}- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        return UIInterfaceOrientationPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 45.0f;
    else
        return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"TransactionListHeaderCellIdentifier";
    TransactionListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    } else {
        cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];
        
        runNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,11,61,17)];
        runNoLabel.text=@"Run #";
        runNoLabel.preferredMaxLayoutWidth = 61;
        runNoLabel.numberOfLines = 1;
        runNoLabel.textColor = [UIColor blackColor];
        runNoLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:runNoLabel];
        
        machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(81,11,100,17)];
        machineNameLabel.text=@"Machine";
        machineNameLabel.preferredMaxLayoutWidth = 100;
        machineNameLabel.numberOfLines = 1;
        machineNameLabel.textColor = [UIColor blackColor];
        machineNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:machineNameLabel];
        
        runDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(191,11,110,17)];
        runDateLabel.text=@"Run Date";
        runDateLabel.preferredMaxLayoutWidth = 110;
        runDateLabel.numberOfLines = 1;
        runDateLabel.textColor = [UIColor blackColor];
        runDateLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:runDateLabel];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    }
    return cellView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transactions.count;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"TransactionListCellIdentifier";
        
    TransactionListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TransactionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    cell.Run_No.text = [[transactions objectAtIndex:indexPath.row] objectForKey:@"Run_No"];
    cell.Machine_Name.text = [[transactions objectAtIndex:indexPath.row] objectForKey:@"Machine_Name"];
    cell.Run_Date.text = [[transactions objectAtIndex:indexPath.row] objectForKey:@"Run_Date"];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (flag == 1)
        return NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [transactions objectAtIndex:indexPath.row];
    NSString *RunNumber = [object valueForKey:@"Run_No"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [transactions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray *DeletionArray=[NSArray arrayWithObjects:@"Transaction",@"Pre_Extraction",@"Run_Process",@"Post_Extraction", nil];
        for (int i=0;i<DeletionArray.count;i++) {
            NSString *ClassName=[DeletionArray objectAtIndex:i];
            PFQuery *query = [PFQuery queryWithClassName:ClassName];
            [query whereKey:@"Run_No" equalTo:RunNumber];
            query.cachePolicy = kPFCachePolicyNetworkElseCache;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // if (!(objects.count == nil)) {
                    for (PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                } else {
                    [error userInfo];
                }
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   /* if ([segue.identifier isEqualToString:@"TransactionListToBasicTransactionDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        AddTransaction_Basic *AddTransaction_BasicObj = (AddTransaction_Basic *)segue.destinationViewController;
        AddTransaction_BasicObj.BasicTransactionPF = object;
    }
    else*/ if([segue.identifier isEqualToString:@"TransactionListToSegmentedControlSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        SegmentedControlVC *segmentControlVCObj=(SegmentedControlVC *)segue.destinationViewController;
        segmentControlVCObj.SegmentControlPF=object;
    //    DetailsTransaction_Pre *DetailsTransaction_PreObj = (DetailsTransaction_Pre *)segue.destinationViewController;
      //  DetailsTransaction_PreObj.DetialsTransaction_PrePF = object;
    }
}

- (IBAction)unwindToTransactionListViewController:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:@"PostUnwindToTransactionListSegue"]) {
        //AddTransaction_Post *AddPostVC = (AddTransaction_Post *)unwindSegue.sourceViewController;
       // NSLog(@"The Parameter 0 are %@",AddPostVC.Parameter0);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
    else if ([unwindSegue.identifier isEqualToString:@"PreUnwindToTransactionListSegue"]){
        //AddTransaction_Pre *addtransactionPre=(AddTransaction_Pre *)unwindSegue.sourceViewController;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
    else if ([unwindSegue.identifier isEqualToString:@"RunUnwindToTransactionListSegue"]){
        //AddTransaction_Run *addtransactionRun=(AddTransaction_Run *)unwindSegue.sourceViewController;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
}

- (IBAction)addTransaction:(id)sender {
    if (machineCount == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                            message:@"No machines have been added"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if (parameterCount == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                            message:@"No parameters have been added"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self performSegueWithIdentifier:@"TransactionListToBasicTransactionDetailsSegue" sender:self];
    }
}

@end
