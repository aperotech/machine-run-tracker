//
//  UserList.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserList.h"
#import "UserListCell.h"
#import "UserDetails.h"
#import <Parse/Parse.h>

@implementation UserList {
    NSMutableArray *NewUserArray;
}

//@dynamic activityIndicatorView;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    //self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"User";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"User Name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
     //   self.objectsPerPage = 15;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.topItem.title=@"";
    //[self.activityIndicatorView startAnimating];
    //[[PFUser currentUser] fetchInBackgroundWithBlock:nil];
    //self.CurrentUser = [PFUser currentUser];
    
    /*PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser]username]];
    [query whereKey:@"usertype" equalTo:@"Admin"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (!object) {
            //NSLog(@"Not An Admin User");
            self.navigationItem.rightBarButtonItem.enabled=FALSE;
            self.PermissionFlag = FALSE;
            // Did not find any UserStats for the current user
        } else {
            self.PermissionFlag = TRUE;
            //NSLog(@"The Transaction Currenet User Is %@ ",object );
            // Found UserStats
            //  int highScore = [[object objectForKey:@"highScore"] intValue];
        }
    }];
    
    if (self.CurrentUser) {
    //    NSLog(@"Current user: %@", currentUser.username);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
   }
   else {
        [self performSegueWithIdentifier:@"userListToAddUserSegue" sender:self];
    }*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshTable:nil];
}

- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    //[self.activityIndicatorView startAnimating];
    [self loadObjects];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //[self.activityIndicatorView stopAnimating];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    // Create a query
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //[self.activityIndicatorView stopAnimating];
    return query;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"UserListHeaderCellIdentifier";
    UserListCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    //UIView *cellView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    //[cellView addSubview:cell.contentView];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    cell.backgroundColor=[UIColor lightGrayColor];
    return cell;
}


#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
        static NSString *CellIdentifier = @"UserListCellIdentifier";
   
        UserListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        self.tableView.separatorColor = [UIColor lightGrayColor];
    
    if (cell == nil) {
        cell = [[ UserListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
        cell.userNameLabel.text=[object objectForKey:@"name"];
        cell.userEmailLabel.text=[object objectForKey:@"email"];
        cell.userTypeLabel.text=[object objectForKey:@"userType"];
        return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([object[@"email"] isEqualToString:currentUser]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                                message:@"You cannot delete your own record"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [tableView setEditing:FALSE];
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded == TRUE) {
                    [self refreshTable:nil];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"User could not be deleted"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
    }
}
    /* Remove the row from data model
    if (self.PermissionFlag == FALSE) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission Denied !!"
                                                            message:@"You don't have permission to delete User. "
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if(self.PermissionFlag == TRUE){
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self refreshTable:nil];
        }];
   // self.CurrentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[[PFUser currentUser]username]];
   // [query orderByAscending:FF_USER_NOMECOGNOME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
            
            //NSLog(@"%@", objects);
            NewUserArray = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                
                [NewUserArray addObject:object];
                [tableView reloadData];
            }
        }
    }];
     }*/

- (void) objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [error localizedDescription];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"userListTouserDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        UserDetails *selectedUser = segue.destinationViewController;
        selectedUser.userObject = object;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end