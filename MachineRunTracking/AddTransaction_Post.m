//
//  AddTransaction_Post.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Post.h"
#import <Parse/Parse.h>
#import "TransactionList.h"
#import <Parse/Parse.h>
#import "AddPostExtractionCell.h"
@interface AddTransaction_Post ()

@end

@implementation AddTransaction_Post
@synthesize parameterAdd_PostPF;

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self setupViewControllers];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
          
            self.LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
           
        }
        
        
    }];

    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Parameters"];
    [query2 selectKeys:@[@"Name"]];
    [query2 whereKey:@"Type" equalTo:@"Post-Extraction"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objectsPF, NSError *error) {
        // iterate through the objects array, which contains PFObjects for each Student
        if (!objectsPF) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
            //self.preExtractionArray=[objectsPF allKeys];
            self.postExtractionArray=[[NSArray alloc]initWithArray:objectsPF ];
            self.RunProcessArray=[[NSMutableArray alloc]init];
            
            for (int i=0;i<[self.postExtractionArray count];i++) {
                NSString *newString=[[objectsPF objectAtIndex:i]valueForKey:@"Name"];
                [self.RunProcessArray addObject:newString];
                
            }

        }
    }];
    

        // Do any additional setup after loading the view.
    // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Post-Extraction"];
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
                 [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                
            }
            
        }
    }];
    self.GetValuesFromPostTextFieldArray=[[NSMutableArray alloc]init];
}

- (void)refreshTable {
    //TODO: refresh your data
        [self.tableView reloadData];
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (IBAction)Cancel:(id)sender {
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    
    [query getObjectInBackgroundWithId:self.LastInsertedTransactionNo block:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            NSLog(@"Successfully retrieved the object.");
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded && !error) {
                    NSLog(@"Transaction deleted from Parse");
    [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
                } else {
                    NSLog(@"error: %@", error);
                }
            }];
        }
    }];

    
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.ObjectCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Post_ExtractionCellIdentifier";
    
    AddPostExtractionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AddPostExtractionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
       
    }
    cell.p_1Text.tag=indexPath.row;
    for (int i=-1;i<indexPath.row;i++) {
        cell.p_1Text.placeholder=[[self.postExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
        
    }
 
      return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    UITableView *table = (UITableView *)[[cell superview] superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    for (NSInteger i=textField.tag;i<=textFieldIndexPath.row;i++) {
        [self.GetValuesFromPostTextFieldArray addObject:textField.text];
       
    }
    
   
}




-(IBAction)SaveAndExit:(id)sender {
   
    
    
    
    if (parameterAdd_PostPF != nil) {
        [self updateParameters];
    }
    else {
        [self saveParameters];
    }
    
    
}

- (void)saveParameters
{
    
    PFObject *NewParameter=[PFObject  objectWithClassName:@"Post_Extraction" ];
    
    if([NewParameter save]) {
        
        PFObject *ParameterValue = [PFObject objectWithClassName:@"Post_Extraction"];
        for (int i=0;i<[self.RunProcessArray count];i++) {
            NSString *newPara=[self.RunProcessArray objectAtIndex:i];
            ParameterValue[newPara]=[self.GetValuesFromPostTextFieldArray objectAtIndex:i];
        }
       // ParameterValue[@"Parameter_1"] = [self.GetValuesFromPostTextFieldArray objectAtIndex:0];
       // ParameterValue[@"Parameter_2"] = [self.GetValuesFromPostTextFieldArray objectAtIndex:1];
       // ParameterValue[@"Parameter_3"] = [self.GetValuesFromPostTextFieldArray objectAtIndex:2];
       // ParameterValue[@"Parameter_4"] = [self.GetValuesFromPostTextFieldArray objectAtIndex:3];
        ParameterValue[@"Run_No"]=self.LastInsertedTransactionNo;
        [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];

            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
              
            }
        }];
        
        //  class created;
        
    }
}

- (void)updateParameters
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Pre_Extraction"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[parameterAdd_PostPF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
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
                    [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue"  sender:self];
                    
                   // [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
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
