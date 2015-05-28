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

@implementation AddTransaction_Post {
    int bounceFlag, doneFlag, firstSave;
    NSString *lastinsertedPostExtractionID, *LastInsertedTransactionNo, *LastInsertedTransactionNoObjectId, *finalText;
    NSInteger objectCount;
    NSArray *postExtractionArray;
    NSMutableArray *GetValuesFromPostTextFieldArray, *RunProcessArray;
    UIDatePicker *timePicker;
    UIToolbar *timePickerToolbar;
    UITextField *timeField;
    NSDateFormatter *formatter;
}

@synthesize parameterAdd_PostPF, scrollView, activeField, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    bounceFlag = 0;
    doneFlag = 0;
    firstSave = 0;
    timeField = [[UITextField alloc] init];
    
    
    //Creating time picker for time fields
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    timePicker = [[UIDatePicker alloc] init];
    
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setBackgroundColor:[UIColor lightTextColor]];
    
    //Creating a toolbar above Date picker where Done button can be added
    timePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [timePickerToolbar setBarStyle:UIBarStyleDefault];
    [timePickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *dateBarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [dateBarItems addObject:flexSpace];
    
    UIBarButtonItem *dateDoneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(timePickerDoneClicked:)];
    [dateBarItems addObject:dateDoneBtn];
    
    [timePickerToolbar setItems:dateBarItems animated:YES];
    
    postExtractionArray=[[NSArray alloc]init];
    RunProcessArray=[[NSMutableArray alloc]init];
    
    [self.activityIndicator startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
            LastInsertedTransactionNoObjectId = [object objectId];
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Parameters"];
    [query2 selectKeys:@[@"Name"]];
    [query2 selectKeys:@[@"Units"]];
    [query2 whereKey:@"Type" equalTo:@"Post-Extraction"];
    [query2 orderByAscending:@"createdAt"];
    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objectsPF, NSError *error) {
        if (!objectsPF) {
            // Did not find any UserStats for the current user
        } else {
            postExtractionArray=objectsPF;
            GetValuesFromPostTextFieldArray = [[NSMutableArray alloc] initWithCapacity:objectsPF.count];
            
            for (int i=0;i<[postExtractionArray count];i++) {
                NSString *newString=[[objectsPF objectAtIndex:i]valueForKey:@"Name"];
                [RunProcessArray addObject:newString];
                [GetValuesFromPostTextFieldArray addObject:[NSNull null]];
            }
        }
        [self.activityIndicator stopAnimating];
    }];
    

        // Do any additional setup after loading the view.
    // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Post-Extraction"];
    [query1 orderByAscending:@"createdAt"];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        objectCount=objects.count;
        if(error){
            NSLog(@"Error! Post");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Parameters Found" message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                postExtractionArray =objects;
                [self.activityIndicator stopAnimating];
                 [self.tableView reloadData];
            }
        }
    }];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    //[self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    //[self deregisterFromKeyboardNotifications];
    
    [super viewDidDisappear:animated];
}

- (IBAction)Cancel:(id)sender {
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do want to cancel transaction?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];*/
    
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Transaction Alert" message:@"Are you sure you want to cancel? Any unsaved data will be lost" preferredStyle:UIAlertControllerStyleActionSheet];
        
        //Create the alert actions i.e. options
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self DeleteTransaction];
            [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to cancel this transaction? Any unsaved data will be lost" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No, go back", nil];
        
        [actionSheet showInView:self.view];
    }
    
}

//Delegate methods to handle action sheet press
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self DeleteTransaction];
            [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
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
            // [self performSegueWithIdentifier:@"PreUnwindToTransactionListSegue" sender:self];
        }
    }];
    
    PFQuery *query1= [PFQuery queryWithClassName:@"Run_Process"];
    [query1 whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
    query1.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            [error userInfo];
            // Log details of the failure
        }
    }];
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0:
            break;
        case 1:
            [self DeleteTransaction];
            
            [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
            
            break;
    }
}*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return objectCount;
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
    
    NSString* string1 =[[postExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Name"] ;
    NSString* string2 = [string1 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    if (bounceFlag == 0) {
        cell.p_1Text.placeholder = [string2 stringByAppendingFormat:@" (%@)",[[postExtractionArray objectAtIndex:indexPath.row ]objectForKey:@"Units"]];
    }
    
    if ([cell.p_1Text.placeholder rangeOfString:@"Time"].location != NSNotFound) {
        [timePicker setFrame:CGRectMake(16, (cell.p_1Text.frame.origin.y + 30.0), self.view.frame.size.width, 140)];
        [cell.p_1Text setInputView:timePicker];
        [cell.p_1Text setInputAccessoryView:timePickerToolbar];
        timeField = cell.p_1Text;
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
    self.activeField = nil;
    
    if (![textField.text isEqualToString:@""]) {
        [GetValuesFromPostTextFieldArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    if (textField.tag == RunProcessArray.count-1) {
        doneFlag = 0;
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789:."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

//Method to call when Done is clicked on Time picker
- (void)timePickerDoneClicked:(id)sender {
    NSString *currentTime = [formatter stringFromDate:timePicker.date];
    timeField.text = currentTime;
    [timeField resignFirstResponder];
    [[self.view viewWithTag:timeField.tag+1] becomeFirstResponder];
}


-(IBAction)SaveAndExit:(id)sender {
    if (doneFlag == 1) {
        [GetValuesFromPostTextFieldArray replaceObjectAtIndex:(RunProcessArray.count-1) withObject:finalText];
    }
    
    if([GetValuesFromPostTextFieldArray containsObject:[NSNull null]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Value"
                                                            message:@"Please enter all parameter values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if (firstSave == 0) {
        firstSave = 1;
        [self saveParameters];
    } else {
        [self.activityIndicator startAnimating];
        PFQuery *query = [PFQuery queryWithClassName:@"Post_Extraction"];
        [query orderByDescending:@"createdAt"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!error) {
                // The find succeeded.
                //NSLog(@"Successfully retrieved %ld scores.", objects.count);
                // Do something with the found objects
                NSString *lastinsertedtransactionPreNo=[object objectForKey:@"Run_No"];
                lastinsertedPostExtractionID =[object objectId];
                if ([lastinsertedtransactionPreNo isEqualToString:LastInsertedTransactionNo]) {
                    [self updateParameters];
                } else {
                    [self saveParameters];
                }
                [self.activityIndicator stopAnimating];
            } else {
                [error userInfo];
            }
        }];
    }
}

- (void)saveParameters {
    PFObject *ParameterValue = [PFObject objectWithClassName:@"Post_Extraction"];
    for (int i=0;i<[RunProcessArray count];i++) {
        NSString *newPara=[RunProcessArray objectAtIndex:i];
        ParameterValue[newPara]=[GetValuesFromPostTextFieldArray objectAtIndex:i];
    }

    ParameterValue[@"Run_No"] = LastInsertedTransactionNo;
    [ParameterValue saveInBackground];
    [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];

    /*[ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];

        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];*/
}

- (void)updateParameters {
    PFQuery *query = [PFQuery queryWithClassName:@"Pre_Extraction"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:lastinsertedPostExtractionID block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            for (int i=0;i<[RunProcessArray count];i++) {
                NSString *newPara=[RunProcessArray objectAtIndex:i];
                UpdateParameter[newPara]=[GetValuesFromPostTextFieldArray objectAtIndex:i];
            }

            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                   [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
                    
                   
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
    
    CGRect newFrame = self.activeField.frame;
    newFrame.origin.y += (objectCount * 50)+50;
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
