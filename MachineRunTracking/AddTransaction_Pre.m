//
//  AddTransaction_Pre.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Pre.h"
#import "AddTransaction_Run.h"
#import "AddTransaction_PreCell.h"
#import <Parse/Parse.h>
@interface AddTransaction_Pre ()


@end

@implementation AddTransaction_Pre
@synthesize tableView,parameterAdd_PrePF;
@synthesize activityIndicatorView;
//@synthesize SegmentedLocationVCObj;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupViewControllers];
  
    [activityIndicatorView startAnimating ];
    // Do any additional setup after loading the view.
   // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
   
    [query1 whereKey:@"Type" equalTo:@"Pre-Extraction"];

   
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Parameters Found"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                
                self.preExtractionArray=[[NSArray alloc]initWithArray:objects];
             
                [self.tableView reloadData];
                
            }
            
        }
    }];
    
      PFQuery *query2 = [PFQuery queryWithClassName:@"Parameters"];
    [query2 selectKeys:@[@"Name"]];
    [query2 whereKey:@"Type" equalTo:@"Pre-Extraction"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objectsPF, NSError *error) {
        
        if (!objectsPF) {
            // Did not find any UserStats for the current user
        } else {
            
            self.preExtractionArray=[[NSArray alloc]initWithArray:objectsPF ];
            self.RunProcessArray=[[NSMutableArray alloc]init];
            
            for (int i=0;i<[self.preExtractionArray count];i++) {
                NSString *newString=[[objectsPF objectAtIndex:i]valueForKey:@"Name"];
                [self.RunProcessArray addObject:newString];
                [activityIndicatorView stopAnimating];
            }
          
        }
    }];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
//self.placeholderArray=[object allKeys];
        
            self.LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
            self.LastInsertedTransactionNoObjectId=[object objectId];
            NSLog(@"name %@ and object id %@",self.LastInsertedTransactionNo,self.LastInsertedTransactionNoObjectId);
        }
        
        
    }];
  
    self.GetValuesFromTextFieldArray=[[NSMutableArray alloc]init];
   }

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (IBAction)Cancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do want to cancel transaction?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
 }

-(void)DeleteTransaction{
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"Run_No" equalTo:self.LastInsertedTransactionNo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
                
            }
           
        } else {
            [error userInfo];
            // Log details of the failure
//NSLog(@"Error: %@ %@", error, [error userInfo]);
            // [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
        }
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0:
            break;
        case 1:
            [self DeleteTransaction];
            
            [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
            
            break;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    for (int i=-1;i<indexPath.row;i++) {
        cell.p_1Text.placeholder=[[self.preExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];

    }
    
    return cell;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
   UITableView *table = (UITableView *)[[cell superview] superview];
NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
for (NSInteger i=textField.tag;i<=textFieldIndexPath.row;i++) {
        [self.GetValuesFromTextFieldArray addObject:textField.text];
       
}
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 40 && range.length == 0)
        return NO;
    
    // Only characters in the NSCharacterSet you choose will insertable.
    if ([textField isEqual:textField]) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789:. "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
      [textField resignFirstResponder];
    return YES;
    
}


-(IBAction)SaveAndForward:(id)sender {
    
    
    
//[self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
        
if (parameterAdd_PrePF != nil) {
      [self updateParameters];
        }
        else {
      [self saveParameters];
        }
}

- (void)saveParameters
{
    [activityIndicatorView startAnimating];
      PFObject *NewParameter=[PFObject objectWithClassName:@"Pre_Extraction"];
     
     if([NewParameter save]) {
         
              PFObject *ParameterValue = [PFObject objectWithClassName:@"Pre_Extraction"];
         
         for (int i=0;i<[self.RunProcessArray count];i++) {
             NSString *newPara=[self.RunProcessArray objectAtIndex:i];
             ParameterValue[newPara]=[self.GetValuesFromTextFieldArray objectAtIndex:i];
         }

     ParameterValue[@"Run_No"]=self.LastInsertedTransactionNo;
     
     [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    
         [activityIndicatorView stopAnimating];
         [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
    
     } else {
         NSLog(@"error here");
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:[error.userInfo objectForKey:@"error"]
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];

    // There was a problem, check error.description
     }
         
     }];
     
     //  class created;
     
     }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  /*  if ([[segue identifier] isEqualToString:@"Pre_ExtractionToRunExtractionSegue"])
    {
        AddTransaction_Run *addVC = (AddTransaction_Run *)segue.destinationViewController;
    }*/
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
