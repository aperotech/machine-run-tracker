//
//  AddTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Run.h"
#import "Process_RunCell.h"
#import <Parse/Parse.h>

@interface AddTransaction_Run ()

@end    

@implementation AddTransaction_Run
@synthesize aTableView;
@synthesize Parameter0,Parameter1,Parameter2;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parameters"];
    [query whereKey:@"Type" equalTo:@"Process_run"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types: %ld",(long)objects.count);
       // self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
               // self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Tiger",@"Leopard",@"Snow Leopard",@"Lion",nil];
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                NSLog(@"The Data Array Is %@",self.dataArray);
                self.refreshControl = [[UIRefreshControl alloc]init];
               [self.aTableView addSubview:self.refreshControl];
               [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
              
                PFQuery *query = [PFQuery queryWithClassName:@"Pre_Extraction"];
                [query whereKey:@"Parameter_4" equalTo:@"Akshay"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    NSLog(@"all types: %ld",(long)objects.count);
                    // self.ObjectCount=objects.count;
                    if(error){
                        NSLog(@"Error!");
                    }
                    else {
                        if (objects.count == 0) {
                            NSLog(@"None found");
                        }
                        else {
                            // self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Tiger",@"Leopard",@"Snow Leopard",@"Lion",nil];
                            self.PostExtractionArray=[[NSMutableArray alloc]initWithArray:objects];
                            NSLog(@"The  self.PostExtractionArray Is %@", self.PostExtractionArray);
                            self.refreshControl = [[UIRefreshControl alloc]init];
                            [self.aTableView addSubview:self.refreshControl];
                            [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
                            //   NSLog(@"objectArray %@",objects);
                        }
                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    }
                   
                }];
                
                            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
        //self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Tiger",@"Leopard",@"Snow Leopard",@"Lion",nil];
    }];
 //   self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Interval",@"Parameter1",@"Parameter2",@"Parameter3",@"Parameter4",@"Value",nil];

     // self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Interval",@"Parameters",@"Parameter 1",@"Parameter 2",@"Parameter 3",@"Value",nil];
    
   /* self.title = @"Data Table";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(addORDeleteRows)];[self.navigationItem setLeftBarButtonItem:addButton];
                      */
     NSLog(@"AddTransaction_Run Loaded!");
    
    // Do any additional setup after loading the view.
}
- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.aTableView reloadData];
}
/*- (void)addORDeleteRows
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [aTableView setEditing:NO animated:NO];
        [aTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [aTableView setEditing:YES animated:YES];
        [aTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  int count = [self.dataArray count];
   // NSLog(@"The Count Is %d",count);
   // if(self.editing) count++;
    return [self.PostExtractionArray count];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0,0, self.aTableView.frame.size.width, 42.0)];
    sectionHeaderView.backgroundColor = [UIColor grayColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.aTableView.frame.size.width,42.0)];
    scrollView.contentSize=CGSizeMake(600, 42);
   scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    [sectionHeaderView addSubview:scrollView];
    
    //scrollView.superview=sectionHeaderView;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(8, 10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel.text = @"Interval";
    [scrollView addSubview:headerLabel];
    
    UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:
                             CGRectMake(72,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel1.backgroundColor = [UIColor clearColor];
    headerLabel1.textAlignment = NSTextAlignmentLeft;
    [headerLabel1 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel1.text = @"Parameter 1";
    [scrollView addSubview:headerLabel1];
    
    UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:
                             CGRectMake(168,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel3.backgroundColor = [UIColor clearColor];
    headerLabel3.textAlignment = NSTextAlignmentLeft;
    [headerLabel3 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel3.text = @"Parameter 2";
    [scrollView addSubview:headerLabel3];
    
    UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:
                             CGRectMake(270,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel4.backgroundColor = [UIColor clearColor];
    headerLabel4.textAlignment = NSTextAlignmentLeft;
    [headerLabel4 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel4.text = @"Parameter 3";
    [scrollView addSubview:headerLabel4];
    
    UILabel *headerLabel5 = [[UILabel alloc] initWithFrame:
                             CGRectMake(372,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel5.backgroundColor = [UIColor clearColor];
    headerLabel5.textAlignment = NSTextAlignmentLeft;
    [headerLabel5 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel5.text = @"Parameter 4";
    [scrollView addSubview:headerLabel5];
    
    UILabel *headerLabel6 = [[UILabel alloc] initWithFrame:
                             CGRectMake(472,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel6.backgroundColor = [UIColor clearColor];
    headerLabel6.textAlignment = NSTextAlignmentLeft;
    [headerLabel6 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel6.text = @"Value";
    [scrollView addSubview:headerLabel6];
    
    
    
    
    
    return sectionHeaderView;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProcessRunCellIdentifier";
    
    Process_RunCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        
       // cell.editingAccessoryType = YES;
    }
    
   /* int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    
    if(indexPath.row == ([self.dataArray count]) && self.editing){
        cell.IntervalLabel.text = @"Append a new row";
        cell.ParametersLabel.hidden=YES;
        cell.Parameters1Label.hidden=YES;
        cell.Parameters2Label.hidden=YES;
        cell.Parameters3Label.hidden=YES;
        cell.ValueLabel.hidden=YES;
        return cell;
    }*/
    //cell.IntervalLabel.tag=indexPath.row;
   // cell.ParametersLabel.tag=indexPath.row;
   // cell.ValueLabel.tag=indexPath.row;
    cell.IntervalLabel.text = [self.PostExtractionArray objectAtIndex:1];
    cell.ParametersLabel.text = [self.PostExtractionArray objectAtIndex:2];
    cell.Parameters1Label.text=[self.PostExtractionArray objectAtIndex:3];
    cell.Parameters2Label.text=[self.PostExtractionArray objectAtIndex:4];
    cell.Parameters3Label.text=NULL;//[self.PostExtractionArray objectAtIndex:indexPath.row];
    cell.ValueLabel.text = NULL;//[self.PostExtractionArray objectAtIndex:indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([self.dataArray count]))
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}
*/

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [aTableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self.dataArray insertObject:@"new Value" atIndex:[self.dataArray count]];
        [aTableView reloadData];
    }
}*/

/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    //Change as per your table header hight
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}*/


- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)SaveAndForward:(id)sender {
    [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
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
