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
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface TransactionList ()

@end

@implementation TransactionList {
    NSString *userType;
    int flag;
}

@synthesize activityIndicatorView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Transaction";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"Run_No";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
         // self.objectsPerPage = 5;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // flag = 0;
    
   // userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
   // if ([userType isEqualToString:@"Standard"]) {
//self.navigationItem.rightBarButtonItem.enabled = FALSE;
//flag = 1;
//}
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTable:nil];
    
    if (self.objects.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction List Empty" message:@"You can create a new transaction by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert show];
    }
}

- (void)refreshTable:(NSNotification *) notification
{//[activityIndicatorView stopAnimating];
    // Reload the recipes
    [self loadObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}



- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByAscending:@"Run_No"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  //  query.limit=5;
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    //    [query orderByAscending:@"name"];
    
    return query;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"TransactionListHeaderCellIdentifier";
    TransactionListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
   
    UIView *cellView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];
        [cellView addSubview:cell.contentView];
    }
    else
    {
        cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];
        UILabel *runNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,12,80,20)];
        
        runNoLabel.text=@"Run No";
        runNoLabel.preferredMaxLayoutWidth = 80;
        runNoLabel.numberOfLines = 0;
        runNoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        runNoLabel.textColor = [UIColor blackColor];
        runNoLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        [cellView addSubview:runNoLabel];
        
        UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75,12,140,20)];
        machineNameLabel.text=@"Machine";
        machineNameLabel.preferredMaxLayoutWidth = 140;
        machineNameLabel.numberOfLines = 0;
        machineNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        machineNameLabel.textColor = [UIColor blackColor];
        machineNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [machineNameLabel sizeToFit];
        [cellView addSubview:machineNameLabel];
        
        UILabel *runDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(190,12,160,20)];
        runDateLabel.text=@"Run Date";
        runDateLabel.preferredMaxLayoutWidth = 160;
        runDateLabel.numberOfLines = 0;
        runDateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        runDateLabel.textColor = [UIColor blackColor];
        runDateLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [runDateLabel sizeToFit];
        
        [cellView addSubview:runDateLabel];
        [cellView addSubview:cell.contentView];
    
    }
    
    return cellView;
    /*self.tableView.separatorColor = [UIColor lightGrayColor];
    cell.backgroundColor=[UIColor grayColor];
    return cell;*/
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
        static NSString *simpleTableIdentifier = @"TransactionListCellIdentifier";
        
        TransactionListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[TransactionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        // Configure the cell
        cell.Run_No.text=[object objectForKey:@"Run_No"];
        cell.Machine_Name.text=[object objectForKey:@"Machine_Name"];
        cell.Run_Date.text=[object objectForKey:@"Run_Date"];
        return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//if (flag == 1) {
   //     return NO;
   // }
//else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded == TRUE) {
                [self refreshTable:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Transaction could not be deleted"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [tableView setEditing:FALSE animated:YES];
                [alertView show];
            }
        }];
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

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    [error localizedDescription];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindToTransactionListViewController:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.identifier isEqualToString:@"PostUnwindToTransactionListSegue"]) {
        AddTransaction_Post *AddPostVC = (AddTransaction_Post *)unwindSegue.sourceViewController;
       // NSLog(@"The Parameter 0 are %@",AddPostVC.Parameter0);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
    else if ([unwindSegue.identifier isEqualToString:@"PreUnwindToTransactionListSegue"]){
        AddTransaction_Pre *addtransactionPre=(AddTransaction_Pre *)unwindSegue.sourceViewController;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
    else if ([unwindSegue.identifier isEqualToString:@"RunUnwindToTransactionListSegue"]){
        AddTransaction_Run *addtransactionRun=(AddTransaction_Run *)unwindSegue.sourceViewController;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
        [self.tableView reloadData];
    }
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
