//
//  AddTransaction_Pre.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Pre.h"

#import "AddTransaction_PreCell.h"
#import <Parse/Parse.h>
@interface AddTransaction_Pre ()


@end

@implementation AddTransaction_Pre
@synthesize tableView,parameterAdd_PrePF;
//@synthesize SegmentedLocationVCObj;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupViewControllers];
  
    
    // Do any additional setup after loading the view.
   // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    
   
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Pre_Extraction"];
    NSLog(@"The Query For Pre_Extraction %@",query1);
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        NSLog(@"all types: %ld",(long)objects.count);
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
               // self.placeholderArray=[[NSMutableArray alloc]initWithArray:objects];
                //NSLog(@"The Object Array For Pre Is %@",objects);
                [self.tableView reloadData];
              // self.refreshControl = [[UIRefreshControl alloc]init];
              //  [self.tableView addSubview:self.refreshControl];
               // [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
            
             //   NSLog(@"objectArray %@",objects);
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        }
    }];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
            NSLog(@"The Objec ts %@",object);
            self.LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
            NSLog(@"The String Is To Be Inside %@",self.LastInsertedTransactionNo);
        }
        
        
    }];
    NSLog(@"The String Is To Be %@",self.LastInsertedTransactionNo);
    

   }

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (IBAction)Cancel:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ NSLog(@"The No Of ROws %ld",self.ObjectCount);
// [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    return self.ObjectCount ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *simpleTableIdentifier = @"Pre_ExtractionCellIdentifier";
    
    AddTransaction_PreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[AddTransaction_PreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor=[UIColor grayColor];
        
    }
       cell.p_1Text.tag=indexPath.row;
    // Configure the cell...
   
    
    return cell;
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Pre_ExtractionCellIdentifier";
    
    AddTransaction_PreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AddTransaction_PreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
       // cell.p_1Text.text = @"New Parameter";
        UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(150,7,300,26)];
        valueTextField.tag = indexPath.row;
        [valueTextField borderStyle];
        valueTextField.backgroundColor =[UIColor grayColor];
        valueTextField.delegate = self;
        valueTextField.placeholder=@"Parameters";
        [cell.contentView addSubview:valueTextField];
       
    }
   // cell.p_1Text.text = @"New Parameter";
    for (int i=0; i<self.ObjectCount;i++) {
        if (indexPath.row == i) {   
            
            UITextField *parameterTextField = (UITextField *)[cell viewWithTag:i];
        }
        
    }
        return cell;
}
*/

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  // NSLog(@"text Field index path %ld ,%@ ",indexPath.row,cell);
}*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    UITableView *table = (UITableView *)[[cell superview] superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    if (textField.tag==0) {
        self.Parameter0=textField.text;
        NSLog(@"Parameter0 %@",self.Parameter0);
 
    
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
  
    
       NSLog(@"Pre Row %ld just finished editing with the value %@  tag is %ld",(long)textFieldIndexPath.row,textField.text ,(long)textField.tag);
   }




-(IBAction)SaveAndForward:(id)sender {
    
    
    
   /* NSString *name = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *type = [typeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Units = [unitsText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([name length] == 0 ||[description length] == 0 ||[type length] == 0 ||[Units length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {*/
        
        [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
        
        if (parameterAdd_PrePF != nil) {
      // [self updateParameters];
        }
        else {
       // [self saveParameters];
        }
    //}
    
}

- (void)saveParameters
{
      PFObject *NewParameter=[PFObject  objectWithClassName:@"Pre_Extraction" ];
     
     if([NewParameter save]) {
   //  NSLog(@"Successfully Created");
     PFObject *ParameterValue = [PFObject objectWithClassName:@"Pre_Extraction"];
     ParameterValue[@"Parameter_1"] = self.Parameter0;
     ParameterValue[@"Parameter_2"] = self.Parameter1;
     ParameterValue[@"Parameter_3"] = self.Parameter2;
     ParameterValue[@"Parameter_4"] = self.Parameter3;
     ParameterValue[@"Run_No"]=self.LastInsertedTransactionNo;
     
     [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    // [self.navigationController popViewControllerAnimated:YES];
         [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Pre_Extraction"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[parameterAdd_PrePF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            [UpdateParameter setObject:self.Parameter0 forKey:@"Parameter_1"];
            [UpdateParameter setObject:self.Parameter1 forKey:@"Parameter_2"];
            [UpdateParameter setObject:self.Parameter2 forKey:@"Parameter_3"];
            [UpdateParameter setObject:self.Parameter0 forKey:@"Parameter_4"];
            [UpdateParameter setObject:self.LastInsertedTransactionNo forKey:@"Run_No"];
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
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






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
