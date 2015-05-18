//
//  MachineLIst.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "MachineLIst.h"
#import "MachineListCell.h"
#import "MachineDetails.h"
#import <Parse/Parse.h>

@interface MachineLIst ()

@end

@implementation MachineLIst {
    NSString *userType;
    int flag;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Machine";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"Code";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = 0;
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
        flag = 1;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshTable:nil];
    
    if (self.objects.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Machine List Empty" message:@"You can create a new machine by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert show];
    }
}

- (void)refreshTable:(NSNotification *) notification {
    // Reload the recipes
    [self loadObjects];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     [query orderByAscending:@"Code"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //[self.activityIndicatorView stopAnimating];
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
    NSString *CellIdentifier1 = @"MachineListHeaderCellIdentifier";
    MachineListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[MachineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    
    // Configure the cell
    cell.backgroundColor=[UIColor lightGrayColor];

    UIView *cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    
    cellView.backgroundColor = [UIColor lightGrayColor];
    //[cell addSubview:cellView];
    cell.codeLabel.text=@"Code";
    cell.nameLabel.text=@"Name";
    cell.locationLabel.text=@"Location";
    cell.capacityLabel.text=@"Capacity";
    
//[cell addSubview:cellView];
//[cell addSubview:cellView];
    
    [cellView addSubview:cell.contentView];
    

    
    
    return cellView;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
        static NSString *simpleTableIdentifier1 = @"MachineListCellIdentifier";
        
        MachineListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];
        if (cell == nil) {
            cell = [[MachineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier1];
        }
        
        // Configure the cell
        cell.codeLabel.text=[object objectForKey:@"Code"];
        cell.nameLabel.text=[object objectForKey:@"Machine_Name"];
        cell.locationLabel.text=[object objectForKey:@"Location"];
        cell.capacityLabel.text=[object objectForKey:@"Capacity"];
         //NSLog(@"The MAchine Are %@",object);
        return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (flag == 1) {
        return NO;
    } else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Check if machine has been used in transaction
        PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
        [query whereKey:@"Machine_Name" equalTo:object[@"Machine_Name"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                                    message:@"Machine is being used in a Transaction"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [tableView setEditing:FALSE animated:YES];
                [alertView show];
            } else {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded == TRUE) {
                        [self refreshTable:nil];
                    } else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                            message:@"Machine could not be deleted"
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [tableView setEditing:FALSE animated:YES];
                        [alertView show];
                    }
                }];
            }
        }];
    }
}

  /*if (self.PermissionFlag == FALSE) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission Denied !!"
                                                            message:@"You don't have permission to delete Machine. "
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if(self.PermissionFlag == TRUE){
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
    }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MachineListToMachineDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        MachineDetails *selectedMachine = segue.destinationViewController;
        selectedMachine.machineObject = object;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
