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
    int flag;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parameter List Empty" message:@"You can create a new parameter by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert show];
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

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
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
    
    
    UIView *cellView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor lightGrayColor];
        [cellView addSubview:cell.contentView];
    }
    else
    {
        cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor lightGrayColor];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,12,160,20)];
        
        nameLabel.text=@"Name";
        nameLabel.preferredMaxLayoutWidth = 160;
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        [cellView addSubview:nameLabel];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,12,140,20)];
        typeLabel.text=@"Type";
        typeLabel.preferredMaxLayoutWidth = 140;
        typeLabel.numberOfLines = 0;
        typeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [typeLabel sizeToFit];
        [cellView addSubview:typeLabel];
        
        UILabel *unitsLabel = [[UILabel alloc]initWithFrame:CGRectMake(210,12,100,20)];
        unitsLabel.text=@"Units";
        unitsLabel.preferredMaxLayoutWidth = 100;
        unitsLabel.numberOfLines = 0;
        unitsLabel.lineBreakMode = NSLineBreakByCharWrapping;
        unitsLabel.textColor = [UIColor blackColor];
        unitsLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [unitsLabel sizeToFit];
        
        [cellView addSubview:unitsLabel];
        [cellView addSubview:cell.contentView];
    
    
    }
    return cellView;
    
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    //cell.backgroundColor=[UIColor grayColor];
    //return cell;
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
    NSString* string1 = [object objectForKey:@"Name"];
  //  NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    cell.parameterName.text=string1;
        cell.parameterType.text=[object objectForKey:@"Type"];
        cell.parameterUnits.text=[object objectForKey:@"Units"];
        
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
        PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Action Denied"
                                                                    message:@"Parameter is being used in a Transaction"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [tableView setEditing:FALSE animated:YES];
                [alertView show];
            } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded == TRUE) {
                    [self refreshTable:nil];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Parameter could not be deleted"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [tableView setEditing:FALSE animated:YES];
                    [alertView show];
                }
            }];
        }
        }];
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
