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

@implementation MachineLIst

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Machine";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Code";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
   /* [[PFUser currentUser] fetchInBackgroundWithBlock:nil];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:currentUser];
    [query whereKey:@"usertype" hasPrefix:@"Standard"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects!=NULL) {
                     //The find succeeded.
                      NSLog(@"Successfully retrieved %ld locations.", objects.count);
                    //Do something with the found objects
            
            NSString *theusers = [objects valueForKey:@"usertype"];
            
                        NSLog(@"The Users %@", theusers);
            NSLog(@"The Objects %@", objects);
                    for (PFObject *object in objects) {
                          NSLog(@"The Type %@", object);
                  }
                 } else {
                     self.navigationItem.rightBarButtonItem.enabled=FALSE;

                       // Log details of the failure
                       NSLog(@"Error: %@ %@", error, [error userInfo]);
                   }
    }];*/
    
    
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
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    //    [query orderByAscending:@"name"];
    
    return query;
}


/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 40.0f;
 }
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
 CGRectMake(0, 0, self.tableView.frame.size.width, 40.0)];
 sectionHeaderView.backgroundColor = [UIColor grayColor];
 
 UILabel *headerLabel = [[UILabel alloc] initWithFrame:
 CGRectMake(28, 11, sectionHeaderView.frame.size.width, 25.0)];
 
 headerLabel.backgroundColor = [UIColor clearColor];
 headerLabel.textAlignment = NSTextAlignmentLeft;
 [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
 headerLabel.text = @"Code";
 [sectionHeaderView addSubview:headerLabel];
 
 UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:
 CGRectMake(100,11, sectionHeaderView.frame.size.width, 25.0)];
 
 headerLabel1.backgroundColor = [UIColor clearColor];
 headerLabel1.textAlignment = NSTextAlignmentLeft;
 [headerLabel1 setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
 headerLabel1.text = @"Name";
 [sectionHeaderView addSubview:headerLabel1];
 
 UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:
 CGRectMake(177,11, sectionHeaderView.frame.size.width, 25.0)];
 
 headerLabel3.backgroundColor = [UIColor clearColor];
 headerLabel3.textAlignment = NSTextAlignmentLeft;
 [headerLabel3 setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
 headerLabel3.text = @"Location";
 [sectionHeaderView addSubview:headerLabel3];
     
UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:
    CGRectMake(271,11, sectionHeaderView.frame.size.width, 25.0)];
     
     headerLabel4.backgroundColor = [UIColor clearColor];
     headerLabel4.textAlignment = NSTextAlignmentLeft;
     [headerLabel4 setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
     headerLabel4.text = @"Capacity";
     [sectionHeaderView addSubview:headerLabel4];
 
 
 
 
 
 
 return sectionHeaderView;
 
 }*/
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    if (indexPath.row ==0) {
    
        static NSString *simpleTableIdentifier = @"MachineListHeaderCellIdentifier";
        
        MachineListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[MachineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        // Configure the cell
        cell.backgroundColor=[UIColor grayColor];
        cell.codeLabel.text=@"Code";
        cell.nameLabel.text=@"Name";
        cell.locationLabel.text=@"Location";
        cell.capacityLabel.text=@"Capacity";
        
        return cell;
        
        
    } else {
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
        return cell;
    
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MachineListToMachineDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        MachineDetails *MachinDetailsObj = (MachineDetails *)segue.destinationViewController;
        MachinDetailsObj.MachineDetailsPF = object;
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
