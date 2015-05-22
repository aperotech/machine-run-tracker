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
    int flag, alertFlag;
    UIView *cellView;
    UILabel *nameLabel, *typeLabel, *unitsLabel;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        
        // The className to query on
        self.parseClassName = @"Parameters";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = 0;
    alertFlag = 0;
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
        flag = 1;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTable:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable:(NSNotification *) notification {
    // Reload the recipes
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

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByAscending:@"Type"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    return query;
}

- (void) objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [error localizedDescription];
    
    if (alertFlag == 0) {
        alertFlag = 1;
        if (self.objects.count == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parameter List Empty" message:@"You can create a new parameter by clicking the add button" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
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
    NSString *CellIdentifier1 = @"ParameterListHeaderCellIdentifier";
    ParameterListCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    } else {
        cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor lightGrayColor];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,11,80,17)];
        nameLabel.text = @"Name";
        nameLabel.preferredMaxLayoutWidth = 80;
        nameLabel.numberOfLines = 1;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:nameLabel];
        
        typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,11,105,17)];
        typeLabel.text = @"Type";
        typeLabel.preferredMaxLayoutWidth = 105;
        typeLabel.numberOfLines = 1;
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:typeLabel];
        
        unitsLabel = [[UILabel alloc]initWithFrame:CGRectMake(215,11,60,17)];
        unitsLabel.text = @"Units";
        unitsLabel.preferredMaxLayoutWidth = 60;
        unitsLabel.numberOfLines = 1;
        unitsLabel.textColor = [UIColor blackColor];
        unitsLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [cellView addSubview:unitsLabel];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [cellView addSubview:cell.contentView];
    }
    return cellView;
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
    NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    cell.parameterName.text=string2;
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
    NSString *parameterType = object[@"Type"];
    NSString *className;
    
    if ([parameterType isEqualToString:@"Pre-Extraction"]) {
        className = @"Pre_Extraction";
    } else if ([parameterType isEqualToString:@"Process Run"]) {
        className = @"Run_Process";
    } else if ([parameterType isEqualToString:@"Post-Extraction"]) {
        className = @"Post_Extraction";
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFQuery *query = [PFQuery queryWithClassName:className];
        NSString* string1 = [object objectForKey:@"Name"];
        NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [query whereKeyExists:string2];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
