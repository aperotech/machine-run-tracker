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
    int count, sectionCount, doneFlag, bounceFlag, updateFlag, doubleAction, firstSave;
    BOOL NextFlag;
    NSString *lastinsertedRunProcessID, *LastInsertedTransactionNo, *LastInsertedTransactionNoObjectID, *finalText;
    NSArray *runPalceholderArray;
    NSMutableArray *GetValuesFromRunTextFieldArray, *FinalValuesArray, *headerArray, *RunProcessArray, *dataArray, *updateObjects;
    UITextField *valueTextField, *timeField, *updateField;
    UILabel *valueHeaderLabel;
    UIDatePicker *timePicker;
    UIToolbar *timePickerToolbar;
    NSDateFormatter *formatter;
    NSInteger indexObject;
}

@synthesize aTableView, activityIndicatorView, scrollView, tableWidth, tableHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    NextFlag=0;
    doneFlag = 0;
    bounceFlag = 0;
    count = 0;
    updateFlag = 0;
    doubleAction = 0;
    firstSave = 0;
    
    self.tableHeight.constant = self.view.frame.size.width;
    self.tableWidth.constant = self.view.frame.size.height;
    [self.aTableView layoutIfNeeded];
    
    timeField = [[UITextField alloc] init];
    updateField = [[UITextField alloc] init];
    
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
    [query1 orderByAscending:@"createdAt"];
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
            } else {
                headerArray=[[NSMutableArray alloc]init];
                RunProcessArray=[[NSMutableArray alloc]init];
                dataArray=[[NSMutableArray alloc]initWithArray:objects];
                for (int i=0;i<[dataArray count];i++) {
                    [headerArray addObject:[[objects objectAtIndex:i]valueForKey:@"Name"]];
                    [RunProcessArray addObject:[[objects objectAtIndex:i]valueForKey:@"Units"]];
                    [activityIndicatorView stopAnimating];
                }
                [aTableView reloadData];
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NextFlag = 0;
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    updateFlag = 1;
    
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
            valueHeaderLabel = [[UILabel alloc] init];
            
            valueHeaderLabel.numberOfLines = 0;
            valueHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            valueHeaderLabel.textColor = [UIColor whiteColor];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                valueHeaderLabel.preferredMaxLayoutWidth = 100;
                valueHeaderLabel.font = [UIFont boldSystemFontOfSize:16.0];
                if (i == 0) {
                    frameText = CGRectMake(10, 5, 100, 50);
                } else {
                    frameText = CGRectMake(130*i, 5, 100, 50);
                }
            }
            else {
                valueHeaderLabel.preferredMaxLayoutWidth = 90;
                valueHeaderLabel.font = [UIFont boldSystemFontOfSize:14.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 5, 90, 40);
                } else {
                    frameText=CGRectMake(110*i, 5, 90, 40);
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
    if ((valueHeaderLabel.frame.origin.x + valueHeaderLabel.frame.size.width) >= self.view.frame.size.height) {
        self.tableWidth.constant = (valueHeaderLabel.frame.origin.x + valueHeaderLabel.frame.size.width + 10);
    }
    
    if (self.aTableView.frame.size.height >= self.scrollView.frame.size.height) {
        self.tableHeight.constant = self.aTableView.frame.size.height;
    }
    
    [self.aTableView layoutIfNeeded];
    
    [self.scrollView setContentSize:CGSizeMake(self.tableWidth.constant, self.tableHeight.constant + 100 )];
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
    if (doneFlag == 1) {
        [GetValuesFromRunTextFieldArray replaceObjectAtIndex:(GetValuesFromRunTextFieldArray.count-1) withObject:finalText];
    }
    if (sectionCount == 0) {
        sectionCount = sectionCount+1;
        for (int i=0; i<RunProcessArray.count; i++) {
            [GetValuesFromRunTextFieldArray addObject:[NSNull null]];
        }
        [self.aTableView reloadData];
    } else if (sectionCount >= 1) {
        if ([GetValuesFromRunTextFieldArray containsObject:[NSNull null]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Please enter all parameter values before adding a new row"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if (!updateFlag == 1) {
                [self saveParameters];
            }
            sectionCount=sectionCount+1;
            doneFlag = 0;
            updateFlag = 0;
            for (int i=0; i<RunProcessArray.count; i++) {
                [GetValuesFromRunTextFieldArray addObject:[NSNull null]];
            }
            [self.aTableView reloadData];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProcessRunCellIdentifier";
    Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell != nil) {
        for (int i = 0 ; i < [RunProcessArray count]; i++) {
            CGRect frameText;
            valueTextField = [[UITextField alloc] init];
            valueTextField.textColor = [UIColor blackColor];
            valueTextField.textAlignment = NSTextAlignmentCenter;

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                valueTextField.font = [UIFont systemFontOfSize:16.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 10, 100, 30);
                } else {
                    frameText=CGRectMake(130*i, 10, 100, 30);
                }
            } else {
                valueTextField.font = [UIFont systemFontOfSize:14.0];
                if (i == 0) {
                    frameText=CGRectMake(10, 10, 90, 30);
                } else {
                    frameText=CGRectMake(110*i, 10, 90, 30);
                }
            }
            
            [valueTextField setFrame:frameText];
            valueTextField.tag = (indexPath.row * RunProcessArray.count)+i+1;
            
            valueTextField.borderStyle = UITextBorderStyleRoundedRect;
            //[valueTextField setEnablesReturnKeyAutomatically:YES];
            [valueTextField setDelegate:self];
            
            valueTextField.placeholder = [RunProcessArray objectAtIndex:i];
            
            if ([valueTextField.placeholder rangeOfString:@"Comment"].location != NSNotFound | [valueTextField.placeholder rangeOfString:@"Text"].location != NSNotFound) {
                [valueTextField setSpellCheckingType:UITextSpellCheckingTypeDefault];
                [valueTextField setAutocorrectionType:UITextAutocorrectionTypeDefault];
                [valueTextField setKeyboardType:UIKeyboardTypeAlphabet];
            } else {
                [valueTextField setSpellCheckingType:UITextSpellCheckingTypeNo];
                [valueTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                [valueTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            }
            
            if ([valueTextField.placeholder rangeOfString:@"Time"].location != NSNotFound) {
                [timePicker setFrame:CGRectMake(16, (valueTextField.frame.origin.y + 30.0), self.view.frame.size.width, 140)];
                [valueTextField setInputView:timePicker];
                [valueTextField setInputAccessoryView:timePickerToolbar];
                timeField = valueTextField;
            }
            
            //if (bounceFlag == 0) {
                if (count > 0 && ((sectionCount - indexPath.row) >1)) {
                    for (int j=0;j<GetValuesFromRunTextFieldArray.count;j++) {
                        if (valueTextField.tag==j+1) {
                            valueTextField.text = [GetValuesFromRunTextFieldArray objectAtIndex:j];
                        }
                    }
                }
            //}
            
            /*if (indexPath.row == sectionCount) {
                bounceFlag = 1;
            }*/
            [cell.contentView addSubview:valueTextField];
        } // for loop
    } //if cell nil
    count++;
    
    /*if (self.aTableView.frame.size.height >= self.scrollView.frame.size.height) {
        self.tableHeight.constant = self.aTableView.frame.size.height;
    }
    [self.scrollView setContentSize:CGSizeMake(self.tableWidth.constant, self.tableHeight.constant)];*/
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    
    if ((textField.tag % RunProcessArray.count) == 0) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeyNext;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
    if (![textField.text isEqualToString:@""]) {
        [GetValuesFromRunTextFieldArray replaceObjectAtIndex:textField.tag-1 withObject:textField.text];
    }
    if ((textField.tag % RunProcessArray.count) == 0) {
        doneFlag = 0;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ((textField.tag % RunProcessArray.count) == 0) {
        [textField resignFirstResponder];
    } else {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((textField.tag % RunProcessArray.count) == 0) {
        finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        doneFlag = 1;
    }
    
    if (textField.text.length >= 40 && range.length == 0)
        return NO;
    
    // Only characters in the NSCharacterSet you choose will insertable.
    if ([textField.placeholder rangeOfString:@"Comments"].location != NSNotFound | [textField.placeholder rangeOfString:@"Text"].location != NSNotFound) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789:. ()-;\""] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    } else if ([textField isEqual:textField]) {
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

- (IBAction)Cancel:(id)sender {
        
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Transaction Alert" message:@"Are you sure you want to cancel? Any unsaved data will be lost" preferredStyle:UIAlertControllerStyleActionSheet];
        
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
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to cancel this transaction? Any unsaved data will be lost" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No, go back", nil];
            
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
    
- (void)DeleteTransaction {
    NSArray *DeletionArray=[NSArray arrayWithObjects:@"Transaction",@"Pre_Extraction",@"Run_Process",@"Post_Extraction", nil];
    for (int i=0;i<DeletionArray.count;i++) {
        NSString *ClassName=[DeletionArray objectAtIndex:i];
        PFQuery *query = [PFQuery queryWithClassName:ClassName];
        [query whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // if (!(objects.count == nil)) {
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            } else {
                [error userInfo];
            }
        }];
    }
}
    
-(IBAction)SaveAndForward:(id)sender {
    if (doneFlag == 1) {
        [GetValuesFromRunTextFieldArray replaceObjectAtIndex:(GetValuesFromRunTextFieldArray.count-1) withObject:finalText];
    }
    
    if (sectionCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"You have not added any values for Run Process"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];

        [alert show];
    } else if ([GetValuesFromRunTextFieldArray containsObject:[NSNull null]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please enter all parameter values to continue"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NextFlag=1;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
        [query whereKey:@"Run_No" equalTo:LastInsertedTransactionNo];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count == sectionCount) {
                    updateObjects = [[NSMutableArray alloc] initWithArray:objects];
                    for (PFObject *object in objects) {
                        lastinsertedRunProcessID = [object objectId];
                        indexObject = [objects indexOfObject:object];
                        [self updateParameters:indexObject];
                    }
                    [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                } else if (sectionCount > objects.count && firstSave == 1) {
                    doubleAction = 1;
                    [self saveParameters];
                    for (PFObject *object in objects) {
                        lastinsertedRunProcessID = [object objectId];
                        indexObject = [objects indexOfObject:object];
                        [self updateParameters:indexObject];
                    }
                    [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                } else {
                    firstSave = 1;
                    [self saveParameters];
                }
            } else {
                [error userInfo];
            }
        }];
    }
}

- (void)saveParameters {
    [activityIndicatorView startAnimating];

    NSUInteger tag, tagCount;
    
    tagCount = 0;
    PFObject *ParameterValue = [PFObject objectWithClassName:@"Run_Process"];
    while (tagCount < headerArray.count) {
        tag = ((sectionCount - 1) * headerArray.count + tagCount +1);
        ParameterValue[[headerArray objectAtIndex:tagCount]] = [GetValuesFromRunTextFieldArray objectAtIndex:(tag-1)];
        tagCount++;
    }
    ParameterValue[@"Run_No"] = LastInsertedTransactionNo;
    [ParameterValue  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [activityIndicatorView stopAnimating];
            
            if (NextFlag == 1 && doubleAction == 0) {
                [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
            }
            // The object has been saved.
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)updateParameters:(NSInteger)value {
    PFObject *UpdateParameter = [updateObjects objectAtIndex:value];
            
    NSUInteger tag, tagCount;
    tagCount = 0;
    
    while (tagCount < headerArray.count ) {
        tag = ((value)  * headerArray.count + tagCount +1);
        NSString *newString=[headerArray objectAtIndex:tagCount];
        UpdateParameter[newString] = [GetValuesFromRunTextFieldArray objectAtIndex:tag-1];
        tagCount++;
    }
    
    [UpdateParameter saveInBackground];
    /*[UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (NextFlag == 1 && (value == sectionCount-1)) {
                [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];  save*/
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
    //Original code + change
    /*NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.aTableView.contentInset = contentInsets;
    self.aTableView.scrollIndicatorInsets = contentInsets;
    
    NSIndexPath *currentRowIndex = [NSIndexPath indexPathForRow:self.activeField.tag inSection:1];
    
    [self.aTableView scrollToRowAtIndexPath:currentRowIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height = aRect.size.width - kbSize.width;
    
    CGRect newFrame = self.activeField.frame;
    newFrame.origin.y += (sectionCount * 50)+50;

    if (!CGRectContainsPoint(aRect, newFrame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (newFrame.origin.y-kbSize.width));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }*/
    
    //New code, works if k/b not dismissed in between
    /*NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = self.activeField.superview.frame;
    NSLog(@"Original x %f y %f w %f h %f", self.activeField.superview.frame.origin.x, self.activeField.superview.frame.origin.y, self.activeField.superview.frame.size.width, self.activeField.superview.frame.size.height);
    NSIndexPath *currentRowIndex = [NSIndexPath indexPathForRow:self.activeField.tag inSection:1];
    
    bkgndRect.size.height += kbSize.width;
    [self.activeField.superview setFrame:bkgndRect];
    [self.aTableView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.width+196) animated:YES];*/
    
    //Trial of landscape specific code
    NSDictionary* info = [aNotification userInfo];
    CGSize kbValue = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = self.aTableView.frame;
    
    CGSize kbSize = CGSizeMake(kbValue.height, kbValue.width);
    
    aRect.size.height -= kbSize.height+50;
    // This will the exact rect in which your textfield is present
    CGRect rect =  [self.aTableView convertRect:self.activeField.bounds fromView:self.activeField];
    // Scroll up only if required
    if (!CGRectContainsPoint(aRect, rect.origin) ) {
        [self.aTableView setContentOffset:CGPointMake(0.0, rect.origin.y-11) animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    //Original code
    /*UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.aTableView.contentInset = contentInsets;
    self.aTableView.scrollIndicatorInsets = contentInsets;*/
    
    //New code, works if k/b not dismissed in between
    /*UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.aTableView.contentInset = contentInsets;
    self.aTableView.scrollIndicatorInsets = contentInsets;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = self.activeField.superview.frame;
    //bkgndRect.size.height += kbSize.height;
    //[self.activeField.superview setFrame:bkgndRect];
    [self.aTableView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.width+342) animated:YES];*/
    
    //Trial of landscape specific code
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.aTableView.contentInset = contentInsets;
    self.aTableView.scrollIndicatorInsets = contentInsets;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbValue = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize kbSize = CGSizeMake(kbValue.height, kbValue.width);
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [self.activeField.superview setFrame:bkgndRect];
    [self.aTableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }*/

@end