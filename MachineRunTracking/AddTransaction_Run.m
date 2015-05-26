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
#import "AppDelegate.h"

@interface AddTransaction_Run ()

@end

@implementation AddTransaction_Run {
    int count, textFieldCount, sectionCount, doneFlag, bounceFlag;
    BOOL NextFlag;
    NSString *lastinsertedRunProcessID, *LastInsertedTransactionNo, *LastInsertedTransactionNoObjectID;
    NSInteger rowIndexCount;
    NSArray *runPalceholderArray;
    NSMutableArray *GetValuesFromRunTextFieldArray, *FinalValuesArray, *headerArray, *RunProcessArray, *dataArray;
    UITextField *valueTextField;
    UILabel *valueHeaderLabel;
}

@synthesize aTableView, activityIndicatorView, scrollView, tableWidth, tableHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    NextFlag=0;
    textFieldCount = 0;
    doneFlag = 0;
    bounceFlag = 0;
    count = 0;
    
    self.tableHeight.constant = self.view.frame.size.width;
    self.tableWidth.constant = self.view.frame.size.height;
    [self.aTableView layoutIfNeeded];
    
    activityIndicatorView.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
            LastInsertedTransactionNoObjectID = [object objectId];
        }
    }];
    
    GetValuesFromRunTextFieldArray = [[NSMutableArray alloc]init];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process Run"];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
    // [query1 selectKeys:@[@"Name"]];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
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
                
//dataArray=[[NSMutableArray alloc]initWithArray:objects];
                headerArray=[[NSMutableArray alloc]init];
                RunProcessArray=[[NSMutableArray alloc]init];
                dataArray=[[NSMutableArray alloc]initWithArray:objects];
                for (int i=0;i<[dataArray count];i++) {
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [headerArray addObject:newString];
                    NSString *units=[[objects objectAtIndex:i]valueForKey:@"Units"];
                 //   NSString *PlaceholderString=[newString stringByAppendingFormat:@"(%@)",units];
                    [RunProcessArray addObject:units];
                    [activityIndicatorView stopAnimating];
                }
                
                [aTableView reloadData];
                NSLog(@"the count getValuesFromTextFieldArray %ld \n the count runProcessArray %ld \n the count data array is %ld\n",self.GetValuesFromRunTextFieldArray.count,self.RunProcessArray.count,self.dataArray.count);
            
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    [super viewDidDisappear:animated];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 60.0f;
    else
        return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [activityIndicatorView startAnimating];
    
    NSString *CellIdentifier1 = @"ProcessRunHeaderCellIdentifier";
    Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    aTableView.separatorColor = [UIColor lightGrayColor];
    
      if (cell != nil) {
        cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        CGRect frameText;
        
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            valueHeaderLabel = [[UILabel alloc] init]; // 10 px padding between each view

            valueHeaderLabel.numberOfLines = 0;
            valueHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            valueHeaderLabel.textColor = [UIColor whiteColor];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                valueHeaderLabel.preferredMaxLayoutWidth = 100;
                valueHeaderLabel.font = [UIFont boldSystemFontOfSize:16.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 5, 100, 50);
                } else {
                    frameText=CGRectMake(valueHeaderLabel.frame.origin.x+130*i, 5, 100, 50);
                }
            }
            else {
                valueHeaderLabel.preferredMaxLayoutWidth = 90;
                valueHeaderLabel.font = [UIFont boldSystemFontOfSize:14.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 5, 90, 40);
                } else {
                    frameText=CGRectMake(valueHeaderLabel.frame.origin.x+110*i, 5, 90, 40);
                }
            }
            
            [valueHeaderLabel setFrame:frameText];
            valueHeaderLabel.tag = i + 100;
            
            NSString* string1 = [headerArray objectAtIndex:i];
            NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            valueHeaderLabel.text =string2;
        
            //headerLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:valueHeaderLabel];
        }
    }
    self.tableHeight.constant = self.aTableView.frame.size.height;
    self.tableWidth.constant = (valueHeaderLabel.frame.origin.x + valueHeaderLabel.frame.size.width + 10);
    [self.aTableView layoutIfNeeded];
    
    [self.scrollView setContentSize:CGSizeMake(self.tableWidth.constant, self.tableHeight.constant)];
    [activityIndicatorView stopAnimating];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UIButton *addRow=[UIButton buttonWithType:UIButtonTypeCustom];
    addRow.frame = CGRectMake(5, 5, 30, 30);
    [addRow setImage:[UIImage imageNamed:@"AddRowButton"] forState:UIControlStateNormal];
    [addRow addTarget:self action:@selector(addRow:) forControlEvents:UIControlEventTouchUpInside];
    //[addRow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//set the color this is may be different for iOS 7
     //set some large width to ur title
    [footerView addSubview:addRow];
    return footerView;
}

- (void)addRow:(id)sender {
    if (sectionCount==0) {
        sectionCount = sectionCount+1;

    }else if (sectionCount>=1 ) {
        NSInteger val=sectionCount * headerArray.count;
        if ( !(GetValuesFromRunTextFieldArray.count== val)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Enter Parameters "
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
           [self saveParameters];
            sectionCount=sectionCount+1;
            }
      }
  
   /* if (sectionCount>=1) {
        if (self.parameterAdd_RunPF != nil) {
            [self updateParameters];
        } else {
            [self saveParameters];
        }
    }*/    
    [self.aTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProcessRunCellIdentifier";
    
    Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell != nil) {
        cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CGRect frameText;
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            valueTextField = [[UITextField alloc] init];
           
            valueTextField.textColor = [UIColor blackColor];
            valueTextField.textAlignment = NSTextAlignmentCenter;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                valueTextField.font = [UIFont systemFontOfSize:16.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 7, 100, 30);
                } else {
                    frameText=CGRectMake(valueTextField.frame.origin.x+105*i, 7, 100, 30);
                }
            } else {
                valueTextField.font = [UIFont systemFontOfSize:14.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 7, 90, 30);
                } else {
                    frameText=CGRectMake(valueTextField.frame.origin.x+110*i, 7, 90, 30);
                }
            }
            
            [valueTextField setFrame:frameText];
            valueTextField.tag = (indexPath.row * RunProcessArray.count)+i+1;
            textFieldCount++;
            
            valueTextField.borderStyle = UITextBorderStyleRoundedRect;
            [valueTextField setReturnKeyType:UIReturnKeyDefault];
            
            [valueTextField setEnablesReturnKeyAutomatically:YES];
            [valueTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [valueTextField setDelegate:self];
            valueTextField.placeholder=[RunProcessArray objectAtIndex:i];
            
            if (count > 0 && ((sectionCount - indexPath.row) >1)) {
                for (int j=0;j<GetValuesFromRunTextFieldArray.count;j++) {
                    if (valueTextField.tag==j+1) {
                        valueTextField.text=[GetValuesFromRunTextFieldArray objectAtIndex:j];
                    }
                }
                
            }
            
            [cell.contentView addSubview:valueTextField];
            if (indexPath.row == (self.sectionCount )) {
                bounceFlag = 1;
            }

        }
        
    }
    NSLog(@"get values array count %ld",self.GetValuesFromRunTextFieldArray.count);
    count++;
    return cell;
}

- (IBAction)Cancel:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    // [self dismissViewControllerAnimated:YES completion:nil];
//[self performSegueWithIdentifier:@"RunUnwindToTransactionListSegue" sender:self];
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
            [self performSegueWithIdentifier:@"RunUnwindToTransactionListSegue" sender:self];
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
            [self performSegueWithIdentifier:@"RunUnwindToTransactionListSegue" sender:self];
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
    
    PFQuery *query1= [PFQuery queryWithClassName:@"Pre_Extraction"];
    [query1 whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
        //    NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *query3= [PFQuery queryWithClassName:@"Run_Process"];
    [query3 whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
    query3.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
//NSLog(@"Successfully retrieved %ld scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
                
            }
            
        } else {
            [error userInfo];            // Log details of the failure
           
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    if (textField.tag%textFieldCount == 0) {
        textField.returnKeyType = UIReturnKeyDone;
   // } else {
     //   textField.returnKeyType = UIReturnKeyNext;
   // }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = textField;
    [GetValuesFromRunTextFieldArray addObject:textField.text];
    
   /* if (textField.tag < GetValuesFromRunTextFieldArray.count | textField.tag > GetValuesFromRunTextFieldArray.count) {
        [GetValuesFromRunTextFieldArray replaceObjectAtIndex:textField.tag withObject:textField.text];
        NSLog(@"get value with** replace %@",GetValuesFromRunTextFieldArray);
          } else  {
        [GetValuesFromRunTextFieldArray addObject:textField.text];
        NSLog(@"get value without__ replace %@",GetValuesFromRunTextFieldArray);
        
        }*/
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  // if (textField.tag == self.RunProcessArray.count) {
        [textField resignFirstResponder];
    //} else {
   //    [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
//}
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
  /*  if (textField.tag == (self.RunProcessArray.count )) {
        finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        doneFlag = 1;
    }*/

    
    
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
//[self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
    NSInteger val=sectionCount * headerArray.count;
    if (sectionCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Enter Process Run Records"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }else if (!(GetValuesFromRunTextFieldArray.count== val)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Enter Parameters "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
   else{
    NextFlag=1;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
    [query orderByDescending:@"createdAt"];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {
            // NSString *lastinsertedtransactionPreNo=[object objectForKey:@"Run_No"];
            lastinsertedRunProcessID =[object objectId];
            
            if ([lastinsertedRunProcessID isEqualToString:LastInsertedTransactionNoObjectID]) {
                [self updateParameters];
            }
            else{
                //[self saveParameters];
                if([self.GetValuesFromRunTextFieldArray containsObject:[NSNull null]]) {
                    //NSLog(@"contains null");
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Value"
                                                                        message:@"Please enter all parameter values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else
                    [self saveParameters];
            }
            }
            
         else {
            [error userInfo];
            
        }
    }];
}
}

- (void)saveParameters
{
    [activityIndicatorView startAnimating];
    //PFObject *NewParameter=[PFObject  objectWithClassName:@"Run_Process" ];
    
    //if([NewParameter save]) {
        
        PFObject *ParameterValue = [PFObject objectWithClassName:@"Run_Process"];
        
        
        NSString *parameterColumn;
        NSUInteger tag, tagCount;
        int x=0;
        
        tagCount = headerArray.count;
        
        while (tagCount > 0) {
            tag = ((sectionCount - 1) * headerArray.count + x +1);
            parameterColumn = [headerArray objectAtIndex:x];
            ParameterValue[parameterColumn] = [GetValuesFromRunTextFieldArray objectAtIndex:(tag-1)];
           
            x++;
            tagCount--;
        }
   
   // NSLog(@"save getParameter List %@",GetValuesFromRunTextFieldArray);
        ParameterValue[@"Run_No"]=LastInsertedTransactionNo;
        
        [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [activityIndicatorView stopAnimating];
                
                if (NextFlag == 1) {
                    NSLog(@"Next Flag Is 1");
                    [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                }
                // The object has been saved.
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
               
                // There was a problem, check error.description
            }
        }];
    //}
}

- (void)updateParameters {
    PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:lastinsertedRunProcessID block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            NSString *parameterColumn;
            NSUInteger tag, tagCount;
            int x=0;
            
            tagCount = headerArray.count;
            
            while (tagCount > 0) {
                tag = ((sectionCount - 1) * headerArray.count + x +1);
                parameterColumn = [headerArray objectAtIndex:x];
                UpdateParameter[parameterColumn] = [GetValuesFromRunTextFieldArray objectAtIndex:(tag-1)];
                                x++;
                tagCount--;
            }
          //  NSLog(@"getvalues update from text field array is %@",GetValuesFromRunTextFieldArray);
            
          
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    if (NextFlag == 1) {

                   [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                    }
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

//Methods to take care of UIScrollView when keyboard appears
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }*/


@end