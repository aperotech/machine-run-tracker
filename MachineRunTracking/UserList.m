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
    UIView *cellView;
    UILabel *nameLabel, *emailLabel, *typeLabel;
    int alertFlag;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //ClassName to query on
        self.parseClassName = @"User";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    alertFlag = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshTable:nil];
}

- (void)refreshTable:(NSNotification *) notification {
    // Reload the recipes
    //[self.activityIndicatorView startAnimating];
    [self loadObjects];
}

- (BOOL)shouldAutorotate {
    return NO;
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}*/

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

- (void) objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [error localizedDescription];
    
    if (alertFlag == 0) {
        alertFlag = 1;
        if (self.objects.count == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User List Empty" message:@"You can create a new user by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            alert.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert show];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 45.0f;
    else
        return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1=@"UserListHeaderCell";
    
    UserListHeaderCell *cell = (UserListHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellView = [[UIView alloc] init];//WithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    } else {
        cellView = [[UIView alloc] init];//WithFrame:cell.contentView.bounds];
        cellView.backgroundColor = [UIColor lightGrayColor];

        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,11,90,17)];
        nameLabel.text = @"Name";
        nameLabel.preferredMaxLayoutWidth = 90;
        nameLabel.numberOfLines = 1;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:nameLabel];
        
        emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(110,11,110,17)];
        emailLabel.text = @"Email";
        emailLabel.preferredMaxLayoutWidth = 110;
        emailLabel.numberOfLines = 1;
        emailLabel.textColor = [UIColor blackColor];
        emailLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:emailLabel];
        
        typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(230,11,70,17)];
        typeLabel.text=@"User Type";
        typeLabel.preferredMaxLayoutWidth = 70;
        typeLabel.numberOfLines = 1;
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:typeLabel];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    }
    return cellView;
}


#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"UserListCell";
   
    UserListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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