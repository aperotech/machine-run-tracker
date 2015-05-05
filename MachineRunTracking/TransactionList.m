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
@interface TransactionList ()

@end

@implementation TransactionList

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Transaction";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Run_No";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
         // self.objectsPerPage = 5;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // self.navigationController.navigationBar.topItem.title=@"";
    // self.navigationController.navigationBar.backItem.title=@"";
    [[PFUser currentUser] fetchInBackgroundWithBlock:nil];
    self.CurrentUser = [PFUser currentUser];

    
    
    PFQuery *query = [PFUser query];
   [query whereKey:@"username" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"usertype" equalTo:@"Admin"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!object) {
            NSLog(@"Not An Admin User");
            self.navigationItem.rightBarButtonItem.enabled=FALSE;
            
            self.PermissionFlag = FALSE;
            // Did not find any UserStats for the current user
        } else {
           self.PermissionFlag = TRUE;
            NSLog(@"The Transaction Currenet User Is %@ ",object );
            // Found UserStats
          //  int highScore = [[object objectForKey:@"highScore"] intValue];
        }
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
}
- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    [self loadObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"TransactionListHeaderCellIdentifier";
    TransactionListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    cell.backgroundColor=[UIColor grayColor];
    return cell;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
        static NSString *simpleTableIdentifier = @"TransactionListCellIdentifier";
        
        TransactionListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[TransactionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        // Configure the cell
        cell.Run_No.text=[object objectForKey:@"Run_No"];
        cell.Machine_Name.text=[object objectForKey:@"Machine_Name"];
        cell.Run_Date.text=[object objectForKey:@"Run_Date"];
        return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    
        if (self.PermissionFlag == FALSE) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission Denied !!"
                                                                message:@"You don't have permission to delete Transaction. "
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
    }else if(self.PermissionFlag == TRUE){
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
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
