//
//  ParameterList.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ParameterList.h"
#import <Parse/Parse.h>
#import "ParameterListCell.h"
#import "parameterDetails.h"

@interface ParameterList ()

@end

@implementation ParameterList {
    NSString *userType;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Parameters";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"Name";
        
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
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTable:nil];
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
    NSString *CellIdentifier1 = @"ParameterListHeaderCellIdentifier";
    ParameterListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    cell.backgroundColor=[UIColor grayColor];
    return cell;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
        static NSString *simpleTableIdentifier = @"ParameterListCellIdentifier";
        
        ParameterListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[ParameterListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        // Configure the cell
        cell.parameterName.text=[object objectForKey:@"Name"];
        cell.parameterType.text=[object objectForKey:@"Type"];
        cell.parameterUnits.text=[object objectForKey:@"Units"];
        
        return cell; 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([userType isEqualToString:@"Standard"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                                message:@"You do not have delete rights"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [tableView setEditing:FALSE];
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded == TRUE) {
                    [self refreshTable:nil];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Parameter could not be deleted"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
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
    if ([segue.identifier isEqualToString:@"ParameterListToParameterDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        parameterDetails *selectedParameter = segue.destinationViewController;
        selectedParameter.parameterObject = object;
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
