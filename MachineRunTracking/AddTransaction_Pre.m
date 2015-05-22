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

@implementation AddTransaction_Pre {
    NSMutableArray *GetValuesFromTextFieldArray, *RunProcessArray;
    NSArray *preExtractionArray;
    NSString *Parameter0, *Parameter1, *Parameter2, *Parameter3, *LastInsertedTransactionNo, *LastInsertedTransactionNoObjectId, *finalText;
    NSInteger objectCount;
    int bounceFlag, doneFlag;
}

@synthesize tableView,parameterAdd_PrePF, activityIndicatorView, scrollView, activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self setupViewControllers];
    RunProcessArray = [[NSMutableArray alloc]init];
    preExtractionArray = [[NSArray alloc]init];
  
    [activityIndicatorView startAnimating ];
    // Do any additional setup after loading the view.
   // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    bounceFlag = 0;
    doneFlag = 0;

    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Pre-Extraction"];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;

    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     
        objectCount=objects.count;
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
                preExtractionArray = objects;
             
                [self.tableView reloadData];
            }
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Parameters"];
    [query2 selectKeys:@[@"Name"]];
    [query2 whereKey:@"Type" equalTo:@"Pre-Extraction"];
    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objectsPF, NSError *error) {
       // objectCount=objectsPF.count;
        if (!objectsPF) {
            // Did not find any UserStats for the current user
        } else {
            
            preExtractionArray = objectsPF;
            GetValuesFromTextFieldArray = [[NSMutableArray alloc] initWithCapacity:objectsPF.count];
            
            for (int i=0;i<[preExtractionArray count];i++) {
                NSString *newString=[[objectsPF objectAtIndex:i]valueForKey:@"Name"];
                [RunProcessArray addObject:newString];
                [GetValuesFromTextFieldArray addObject:[NSNull null]];
                [activityIndicatorView stopAnimating];
            }
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
//self.placeholderArray=[object allKeys];
        
            LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
            LastInsertedTransactionNoObjectId=[object objectId];
            //NSLog(@"name %@ and object id %@",self.LastInsertedTransactionNo,self.LastInsertedTransactionNoObjectId);
        }
    }];
  
   }

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    [super viewDidDisappear:animated];
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
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do want to cancel transaction?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];*/
    
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Transaction Alert" message:@"Are you sure you want to cancel this transaction?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        //Create the alert actions i.e. options
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self DeleteTransaction];
            [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
        }];
        
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"No, go back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        //Add alert actions to the alert controller
        [alert addAction:cancelAction];
        [alert addAction:yesAction];
        [alert addAction:backAction];
        
        //Present the alert controller
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Transaction Alert" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No, go back", nil];
        
        [actionSheet showInView:self.view];
    }
    
}

//Delegate methods to handle action sheet press
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self DeleteTransaction];
            [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
            break;
            
        case 1:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

-(void)DeleteTransaction{
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %ld scores.", objects.count);
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

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            break;
        case 1:
            [self DeleteTransaction];
            [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
            
            break;
    }
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return objectCount ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *simpleTableIdentifier = @"Pre_ExtractionCellIdentifier";
    
    AddTransaction_PreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[AddTransaction_PreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor=[UIColor grayColor];
    }
    
     cell.p_1Text.tag=indexPath.row;
    // Configure the cell...
        NSString* string1 =[[preExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Name"] ;
        NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];

      //  NSString *PlaceholderString=
        if (bounceFlag == 0) {
            cell.p_1Text.placeholder=[string2 stringByAppendingFormat:@" (%@)",[[preExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Units"]];
        }
    if (indexPath.row == (RunProcessArray.count-1)) {
        bounceFlag = 1;
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    if (textField.tag == RunProcessArray.count-1) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeyNext;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = textField;
    
    /*if (textField.tag < GetValuesFromTextFieldArray.count | textField.tag > GetValuesFromTextFieldArray.count) {
        [GetValuesFromTextFieldArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    } else  {
        [GetValuesFromTextFieldArray replaceObjectAtIndex:textField.tag withObject:textField.text];
        NSLog(@"added %@ at %ld",textField.text, (long)textField.tag);
    }*/
    if (![textField.text isEqualToString:@""]) {
        [GetValuesFromTextFieldArray replaceObjectAtIndex:textField.tag withObject:textField.text];
        //NSLog(@"added %@ at %ld",textField.text, (long)textField.tag);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == RunProcessArray.count-1) {
        [textField resignFirstResponder];
    } else {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == (RunProcessArray.count-1)) {
        finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        doneFlag = 1;
    }
    
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

-(IBAction)SaveAndForward:(id)sender {
    //[self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];

    if (doneFlag == 1) {
        [GetValuesFromTextFieldArray replaceObjectAtIndex:(RunProcessArray.count-1) withObject:finalText];
    }
    
   if (parameterAdd_PrePF != nil) {
        [self updateParameters];
   } else {
       if([GetValuesFromTextFieldArray containsObject:[NSNull null]]) {
           //NSLog(@"contains null");
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Value"
                                                               message:@"Please enter all parameter values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
       } else
           [self saveParameters];
   }
}

- (void)saveParameters
{
    //[activityIndicatorView startAnimating];
      //PFObject *NewParameter=[PFObject objectWithClassName:@"Pre_Extraction"];
     
     //if([NewParameter save]) {
         PFObject *ParameterValue = [PFObject objectWithClassName:@"Pre_Extraction"];
         for (int i=0;i<[RunProcessArray count];i++) {
             NSString *newPara=[RunProcessArray objectAtIndex:i];
             ParameterValue[newPara] = [GetValuesFromTextFieldArray objectAtIndex:i];
         }

     ParameterValue[@"Run_No"]=LastInsertedTransactionNo;
     
     [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
         //[activityIndicatorView stopAnimating];
         [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
    
     } else {
         //NSLog(@"error here");
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:[error.userInfo objectForKey:@"error"]
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];

    // There was a problem, check error.description
     }
         
     }];
     
     //  class created;
     
     //}
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
            
            [UpdateParameter setObject:Parameter0 forKey:@"Parameter_1"];
            [UpdateParameter setObject:Parameter1 forKey:@"Parameter_2"];
            [UpdateParameter setObject:Parameter2 forKey:@"Parameter_3"];
            [UpdateParameter setObject:Parameter0 forKey:@"Parameter_4"];
            [UpdateParameter setObject:LastInsertedTransactionNo forKey:@"Run_No"];
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
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

//Methods to take care of UIScrollView when keyboard appears
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (self.activeField.frame.origin.y-kbSize.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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
