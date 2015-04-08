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
#import "User.h"
@implementation UserList
//MainMenuToUserListSegue
//userListTouserDetailsSegue
//userListToAddUserSegue

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"User";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
     //   self.objectsPerPage = 15;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    PFUser *currentUser = [PFUser currentUser];
    
    
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTable:)
                                                     name:@"refreshTable"
                                                   object:nil];
    }
    else {
        [self performSegueWithIdentifier:@"userListToAddUserSegue" sender:self];
    }
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



// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    // Create a query
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    NSLog(@"The self.parseClassName Are %@ ",self.parseClassName);
     if ([PFUser currentUser]) {
        [query whereKey:@"username" equalTo:[PFUser currentUser]];
         NSArray *objectstofind = [query findObjects];
         NSLog(@"The objectstofind Are %@ ",objectstofind);

    }
    else {
        // I added this so that when there is no currentUser, the query will not return any data
        // Without this, when a user signs up and is logged in automatically, they briefly see a table with data
        // before loadObjects is called and the table is refreshed.
        // There are other ways to get an empty query, of course. With the below, I know that there
        // is no such column with the value in the database.
        [query whereKey:@"nonexistent" equalTo:@"doesn't exist"];
    }

    
    return query;
}





#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"UserListCellIdentifier";
    NSLog(@"The PFObjects Are %@ ",object);
     UserListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ UserListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  /*  UILabel *userNameLabel = (UILabel*) [cell viewWithTag:101];
    userNameLabel.text = [object objectForKey:@"username"];
    
    UILabel *userEmailLabel = (UILabel*) [cell viewWithTag:102];
    userEmailLabel.text = [object objectForKey:@"email"];
    
    UILabel *userTypeLabel = (UILabel*) [cell viewWithTag:103];
    userTypeLabel.text = [object objectForKey:@"password"];*/
    
    cell.userNameLabel.text=[object objectForKey:@"username"];
   cell.userEmailLabel.text=[object objectForKey:@"email"];
   cell.userTypeLabel.text=[object objectForKey:@"password"];
    
      NSLog(@"the User name %@ n Email %@",[object objectForKey:@"username"] ,cell.detailTextLabel.text );
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}

/*- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"userListTouserDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        UserDetails *userdetailsObj = (UserDetails *)segue.destinationViewController;
        userdetailsObj.UpdateObjPF = object;
    }
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
 //   PFUser *currentUser = [PFUser currentUser];
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
