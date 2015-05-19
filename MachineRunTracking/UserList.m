//
//  UserList.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserList.h"
#import "UserListCell.h"
#import "UserListHeaderCell.h"
#import "UserDetails.h"
#import <Parse/Parse.h>

@implementation UserList {
    NSMutableArray *NewUserArray;
}

//@dynamic activityIndicatorView;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //ClassName to query on
        self.parseClassName = @"User";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
     //   self.objectsPerPage = 15;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshTable:nil];
    
    if (self.objects.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User List Empty" message:@"You can create a new user by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert show];
    }
}

- (void)refreshTable:(NSNotification *) notification {
    // Reload the recipes
    //[self.activityIndicatorView startAnimating];
    [self loadObjects];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    //[self.activityIndicatorView stopAnimating];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
     NSString *CellIdentifier1=@"UserListHeaderCell";
    
    UserListHeaderCell *cell = (UserListHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[UserListHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
       

    
    }

//    CGRect frameText;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.cellView = [[UIView alloc] init];//WithFrame:cell.contentView.bounds];
        self.cellView.backgroundColor = [UIColor lightGrayColor];
         [self.cellView addSubview:cell.contentView];
    
    }
    else
    {
        self.cellView = [[UIView alloc] init];//WithFrame:cell.contentView.bounds];
        self.cellView.backgroundColor = [UIColor lightGrayColor];

        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,11,160,20)];
        
        nameLabel.text=@"Name";
        nameLabel.preferredMaxLayoutWidth = 160;
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        [self.cellView addSubview:nameLabel];
        
        UILabel *emailAddress = [[UILabel alloc]initWithFrame:CGRectMake(110,11,240,20)];
        emailAddress.text=@"Email Address";
        emailAddress.preferredMaxLayoutWidth = 240;
        emailAddress.numberOfLines = 0;
        emailAddress.lineBreakMode = NSLineBreakByCharWrapping;
        emailAddress.textColor = [UIColor blackColor];
        emailAddress.font = [UIFont boldSystemFontOfSize:14.0];
        [emailAddress sizeToFit];
        [self.cellView addSubview:emailAddress];
        
        UILabel *userType = [[UILabel alloc]initWithFrame:CGRectMake(230,11,80,20)];
        userType.text=@"User Type";
        userType.preferredMaxLayoutWidth = 80;
        userType.numberOfLines = 0;
        userType.lineBreakMode = NSLineBreakByCharWrapping;
        userType.textColor = [UIColor blackColor];
        userType.font = [UIFont boldSystemFontOfSize:14.0];
        [userType sizeToFit];
        
        [self.cellView addSubview:userType];
    [self.cellView addSubview:cell.contentView];
    }
   // cell.nameLabel.text=@"Name";
    //cell.emailLabel.text=@"Email Address";
    //cell.userTypeLabel.text=@"User Type";

//[cellView addSubview:cell.emailLabel];
//[cellView addSubview:cell.userTypeLabel];
    //[cell addSubview:cellView];
    
    
    return self.cellView;
}


#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"UserListCell";
   
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    //NSString *currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([object[@"userType"] isEqualToString:@"Admin"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                                message:@"Admin user cannot be deleted"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [tableView setEditing:FALSE animated:YES];
            [alertView show];
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded == TRUE) {
                    [self refreshTable:nil];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"User could not be deleted"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [tableView setEditing:FALSE animated:YES];
                    [alertView show];
                }
            }];
        }
    }
}

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