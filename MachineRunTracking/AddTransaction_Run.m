//
//  AddTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Run.h"
#import "Process_RunCell.h"
#import "MainMenu.h"
#import <Parse/Parse.h>

@interface AddTransaction_Run ()

@end    

@implementation AddTransaction_Run

@synthesize aTableView;

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
               // [aTableView reloadData];
               // self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Tiger",@"Leopard",@"Snow Leopard",@"Lion",nil];
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                NSLog(@"The Data Array Is %@",self.dataArray);
              // self.refreshControl = [[UIRefreshControl alloc]init];
              // [self.aTableView addSubview:self.refreshControl];
              // [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
              
                PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
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
                            [aTableView reloadData];
                            
                            self.RunProcessArray=[[NSMutableArray alloc]initWithArray:objects];
                            NSLog(@"The  self.PostExtractionArray Is %@", self.RunProcessArray);
                            self.refreshControl = [[UIRefreshControl alloc]init];
                            [self.aTableView addSubview:self.refreshControl];
                            [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
                            //   NSLog(@"objectArray %@",objects);
                        }
                      
                        }
                   
                    }];
               
               }
          }
       
    }];

    
   // self.title = @"Data Table";
  //  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(addORDeleteRows)];[self.navigationItem setLeftBarButtonItem:addButton];
    [super setEditing:YES animated:YES];
    [aTableView setEditing:YES animated:YES];
    [aTableView reloadData];
     NSLog(@"AddTransaction_Run Loaded!");
    
    // Do any additional setup after loading the view.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[self.RunProcessArray count];
    NSLog(@"The Count Is %d",count);
    if(self.editing) count++;
    return count;
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0,0, aTableView.frame.size.width, 42.0)];
    sectionHeaderView.backgroundColor = [UIColor grayColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,aTableView.frame.size.width,42.0)];
    scrollView.contentSize=CGSizeMake(600, 42);
   scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    [sectionHeaderView addSubview:scrollView];
    
    //scrollView.superview=sectionHeaderView;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(55, 10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel.text = @"Interval";
    [scrollView addSubview:headerLabel];
    
    UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:
                             CGRectMake(120,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel1.backgroundColor = [UIColor clearColor];
    headerLabel1.textAlignment = NSTextAlignmentLeft;
    [headerLabel1 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel1.text = @"Parameter 1";
    [scrollView addSubview:headerLabel1];
    
    UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:
                             CGRectMake(216,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel3.backgroundColor = [UIColor clearColor];
    headerLabel3.textAlignment = NSTextAlignmentLeft;
    [headerLabel3 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel3.text = @"Parameter 2";
    [scrollView addSubview:headerLabel3];
    
    UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:
                             CGRectMake(318,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel4.backgroundColor = [UIColor clearColor];
    headerLabel4.textAlignment = NSTextAlignmentLeft;
    [headerLabel4 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel4.text = @"Parameter 3";
    [scrollView addSubview:headerLabel4];
    
    UILabel *headerLabel5 = [[UILabel alloc] initWithFrame:
                             CGRectMake(420,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel5.backgroundColor = [UIColor clearColor];
    headerLabel5.textAlignment = NSTextAlignmentLeft;
    [headerLabel5 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel5.text = @"Parameter 4";
    [scrollView addSubview:headerLabel5];
    
    UILabel *headerLabel6 = [[UILabel alloc] initWithFrame:
                             CGRectMake(522,10, sectionHeaderView.frame.size.width, 21.0)];
    
    headerLabel6.backgroundColor = [UIColor clearColor];
    headerLabel6.textAlignment = NSTextAlignmentLeft;
    [headerLabel6 setFont:[UIFont fontWithName:@"System" size:15.0]];
    headerLabel6.text = @"Value";
    [scrollView addSubview:headerLabel6];
    
    
    
    
    
    return sectionHeaderView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProcessRunCellIdentifier";
    
    Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        
        cell.editingAccessoryType = YES;
    }
    
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    
    if(indexPath.row == ([self.RunProcessArray count]) && self.editing){
       
     //   cell.IntervalText.text = @"Interval ";
       // cell.ParametersText.text = @"Is";
       // cell.Parameters1Text.text=@"Showing";
        //cell.Parameters2Text.text=@"Parameters";
        //cell.Parameters3Text.text=@"Parameters2";
       // cell.ValueText.text = @"Parameters3";
             return cell;
    }
    
  /*  cell.IntervalText.text = [[self.dataArray objectAtIndex:indexPath.row ]objectForKey:@"Description"];
    cell.ParametersText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
    cell.Parameters1Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Type"];
    cell.Parameters2Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Units"];
    cell.Parameters3Text.text= @"Parameter 3";//[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_4"];
    cell.ValueText.text = @"Value";//[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Value"];*/
    
   /* cell.IntervalText.text = @"Here ";
    cell.ParametersText.text = @"Is";
    cell.Parameters1Text.text=@"Showing";
    cell.Parameters2Text.text=@"Parameters";
    cell.Parameters3Text.text=@"Parameters2";
    cell.ValueText.text = @"Parameters3";*/
    
    
    cell.IntervalText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Interval"];
    cell.ParametersText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_1"];
    cell.Parameters1Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_2"];
    cell.Parameters2Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_3"];
    cell.Parameters3Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_4"];
    cell.ValueText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Value"];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // if (self.editing == YES || !indexPath)
     //   return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([self.RunProcessArray count]))
        
        return UITableViewCellEditingStyleInsert;
   // else
     //   return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [aTableView reloadData];
    }*/
     if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self.RunProcessArray insertObject:@"new Value" atIndex:[self.RunProcessArray count]];
        [aTableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isEditing] == YES) {
        
        NSLog(@"Do something.");
        
    }
    
    else {
        NSLog(@"Do something. Else");
        // Do Something else.
        
    }}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    //Change as per your table header hight
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (IBAction)Cancel:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[[textField superview]superview ] superview];
    UITableView *table = (UITableView *)[[cell superview] superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    if (textField.tag==0) {
        self.Interval=textField.text;
        NSLog(@"Interval %@",self.Interval);
      }
    if (textField.tag==1) {
        self.Parameter1=textField.text;
        NSLog(@"Parameter1 %@",self.Parameter1);
    }
    if (textField.tag==2) {
        self.Parameter2=textField.text;
        NSLog(@"Parameter2 %@",self.Parameter2);
    }
    if (textField.tag==3) {
        self.Parameter3=textField.text;
        NSLog(@"Parameter3 %@",self.Parameter3);
    }
    if (textField.tag==4) {
        self.Value=textField.text;
        NSLog(@"Value %@",self.Value);
    }
      NSLog(@"Pre Row %ld just finished editing with the value %@  tag is %ld",(long)textFieldIndexPath.row,textField.text ,(long)textField.tag);
    
    
}
-(IBAction)SaveAndForward:(id)sender {
  // [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
    if (self.parameterAdd_RunPF != nil) {
        [self updateParameters];
    }
    else {
        [self saveParameters];
    }

}

- (void)saveParameters
{
    PFObject *NewParameter=[PFObject  objectWithClassName:@"Run_Process" ];
    
    if([NewParameter save]) {
        //  NSLog(@"Successfully Created");
        PFObject *ParameterValue = [PFObject objectWithClassName:@"Run_Process"];
        ParameterValue[@"Interval"] = self.Interval;
        ParameterValue[@"Parameter_1"] = self.Parameter1;
        ParameterValue[@"Parameter_2"] = self.Parameter2;
        ParameterValue[@"Parameter_3"] = self.Parameter3;
        ParameterValue[@"Parameter_4"] = @"Akshay";
        ParameterValue[@"Value"] = self.Value;
        
        
        [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                // [self.navigationController popViewControllerAnimated:YES];
               [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                NSLog(@"The object has been saved");
                // The object has been saved.
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                NSLog(@"here was a problem, check error.description");
                // There was a problem, check error.description
            }
        }];
        
        //  class created;
        
    }
    /* PFObject *NewParameter = [PFObject objectWithClassName:@"Pre_Extraction"];
     
     
     [NewParameter setObject:self.Parameter0 forKey:@"Parameter_1"];
     [NewParameter setObject:self.Parameter1 forKey:@"Parameter_2"];
     [NewParameter setObject:self.Parameter2 forKey:@"Parameter_3"];
     [NewParameter setObject:self.Parameter0 forKey:@"Parameter_4"];
     
     
     
     
     //  NewMachine[@"Machine"] = [PFUser currentUser];
     
     [NewParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
     [self.navigationController popViewControllerAnimated:YES];
     } else {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:[error.userInfo objectForKey:@"error"]
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     }
     }];
     */
}

- (void)updateParameters
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.parameterAdd_RunPF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            [UpdateParameter setObject:self.Interval forKey:@"Interval"];
            [UpdateParameter setObject:self.Parameter1 forKey:@"Parameter_1"];
            [UpdateParameter setObject:self.Parameter2 forKey:@"Parameter_2"];
            [UpdateParameter setObject:self.Parameter3 forKey:@"Parameter_3"];
            [UpdateParameter setObject:@"Akshay" forKey:@"Parameter_4"];
            [UpdateParameter setObject:self.Value forKey:@"Value"];
            
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                   [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                    //  [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
        
    }];
    
}
#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
