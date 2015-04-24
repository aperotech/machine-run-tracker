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

@implementation UserList
//MainMenuToUserListSegue
//userListTouserDetailsSegue
//userListToAddUserSegue

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"_User";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"User Name";
        
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
   [[PFUser currentUser] fetchInBackgroundWithBlock:nil];
    PFUser *currentUser = [PFUser currentUser];
   
    //[query whereKey:@"Parameter_4" equalTo:@"Akshay"];
    
    
    self.HeaderArray=[[NSMutableArray alloc]initWithObjects:@"UserName",@"email",@"User Type", nil];
    
    
    if (currentUser) {
    //    NSLog(@"Current user: %@", currentUser.username);
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
    
    return query;
}





#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    
    if(indexPath.row==0){
     static NSString *CellIdentifier1 = @"UserListHeaderCellIdentifier";
        
        UserListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        self.tableView.separatorColor = [UIColor lightGrayColor];
        if (cell == nil) {
            cell = [[ UserListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        cell.backgroundColor=[UIColor grayColor];
        cell.userNameLabel.text= [self.HeaderArray objectAtIndex:0];
        cell.userEmailLabel.text=[self.HeaderArray objectAtIndex:2];
        cell.userTypeLabel.text=[self.HeaderArray objectAtIndex:1];
        return cell;
    }else {
    static NSString *CellIdentifier = @"UserListCellIdentifier";
   
        UserListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
       
        self.tableView.separatorColor = [UIColor lightGrayColor];
        if (cell == nil) {
            cell = [[ UserListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.userNameLabel.text=[object objectForKey:@"username"];
        cell.userEmailLabel.text=[object objectForKey:@"email"];
        cell.userTypeLabel.text=[object objectForKey:@"usertype"];
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

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    [error localizedDescription];
   
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
                            CGRectMake(19, 11, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
    headerLabel.text = @"Name";
    [sectionHeaderView addSubview:headerLabel];
    
    UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:
                             CGRectMake(122,11, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel1.backgroundColor = [UIColor clearColor];
    headerLabel1.textAlignment = NSTextAlignmentLeft;
    [headerLabel1 setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
    headerLabel1.text = @"Type";
    [sectionHeaderView addSubview:headerLabel1];
    
    UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:
                             CGRectMake(193,11, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel3.backgroundColor = [UIColor clearColor];
    headerLabel3.textAlignment = NSTextAlignmentLeft;
    [headerLabel3 setFont:[UIFont fontWithName:@"Verdana" size:17.0]];
    headerLabel3.text = @"Email Address";
    [sectionHeaderView addSubview:headerLabel3];
    
    
    
    
    
    
    return sectionHeaderView;
    
}*/


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"userListTouserDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row ];
        
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
