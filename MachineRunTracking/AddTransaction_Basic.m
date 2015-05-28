//
//  AddTransaction_Basic.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Basic.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
//#import "SegmentedLocationVC.h"
@interface AddTransaction_Basic ()

@end

@implementation AddTransaction_Basic
{
    //NSArray *frequency;
    NSMutableArray* Machine_NameArray;
    UIPickerView *MachinePicker;
    UIDatePicker *datePicker;
    UIToolbar *MachinePickerToolbar, *datePickerToolbar;
    NSString *date;
    int value, firstSave;
    NSString *lastinsertedTrasactionID;
    NSDateFormatter *formatter;
}


@synthesize BasicTransactionPF, Run_NoText,Run_DateText,Run_DurationText,Machine_NameText,activityIndicatorView;

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    firstSave = 0;
   
    self.navigationController.navigationBar.topItem.title=@"";
    activityIndicatorView.hidden=YES;
    
    PFQuery *query=[PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"Run_No"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            value=1;
             NSString *runNo=[NSString stringWithFormat:@"R%04i",value];
            self.Run_NoText.text = runNo;
            self.Run_NoText.enabled=FALSE;
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
           // self.placeholderArray=[object allKeys];
            
           NSString *LastInsertedRunNo = [object objectForKey:@"Run_No"];
            NSString *numbers = [LastInsertedRunNo stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
             value = [numbers intValue];
            
            NSString *runNo=[NSString stringWithFormat:@"R%04i",value+1];
            self.Run_NoText.text=runNo;
            self.Run_NoText.enabled=FALSE;
            [activityIndicatorView stopAnimating];
           // [activityView stopAnimating];
        }
    }];

   PFQuery *query1 = [PFQuery queryWithClassName:@"Machine"];
   [query1 selectKeys:@[@"Machine_Name"]];
   query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
   [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
             Machine_NameArray = [NSMutableArray arrayWithCapacity:objects.count];
            for(PFObject* obj in objects) {
                [Machine_NameArray addObject:[obj objectForKey:@"Machine_Name"]];
              
            }
        }
        else {
            [error userInfo];

        }
    }];

    MachinePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, Run_DurationText.frame.origin.y, 288, 120)];
    MachinePicker.delegate = self;
    MachinePicker.dataSource = self;
    
    [MachinePicker setBackgroundColor:[UIColor lightTextColor]];
    [MachinePicker setShowsSelectionIndicator:YES];
    [self.Machine_NameText setInputView:MachinePicker];
    
    //Creating a toolbar above picker where Done button can be added
    MachinePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [MachinePickerToolbar setBarStyle:UIBarStyleDefault];
    [MachinePickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(machinePickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [MachinePickerToolbar setItems:barItems animated:NO];
    [self.Machine_NameText setInputAccessoryView:MachinePickerToolbar];
    
    //Creating date picker for last maintenance date
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM YYYY"];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(16, (self.Run_DateText.frame.origin.y + 10.0), 288, 162)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor lightTextColor]];
    [self.Run_DateText setInputView:datePicker];
    
    
    //Creating a toolbar above Date picker where Done button can be added
    datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [datePickerToolbar setBarStyle:UIBarStyleDefault];
    [datePickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *dateBarItems = [[NSMutableArray alloc] init];
    
    [dateBarItems addObject:flexSpace];
    
    UIBarButtonItem *dateDoneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClicked)];
    [dateBarItems addObject:dateDoneBtn];
    
    [datePickerToolbar setItems:dateBarItems animated:YES];
    [self.Run_DateText setInputAccessoryView:datePickerToolbar];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.Run_NoText) {
        //[activityView startAnimating];
        [self.Machine_NameText becomeFirstResponder];
    } else if (textField == self.Run_DurationText) {
        [self.Run_DurationText resignFirstResponder];
    }
    return YES;
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.Machine_NameText | textField == self.Run_DateText) {
        return NO;
    }
    if ([textField isEqual:self.Run_DurationText]) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.:"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark - Picker delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return Machine_NameArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [Machine_NameArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.activeField == self.Machine_NameText) {
        self.Machine_NameText.text = [Machine_NameArray objectAtIndex:row];
    }
}

//Method to call when Done is clicked on Age picker drop down
- (void)machinePickerDoneClicked {
    if ([self.Machine_NameText.text isEqualToString:@""]) {
            self.Machine_NameText.text = [Machine_NameArray objectAtIndex:0];
        }
        [self.Run_DateText becomeFirstResponder];
}

//Method to call when Done is clicked on Date picker drop down
- (void)datePickerDoneClicked {
    date = [formatter stringFromDate:datePicker.date];
    self.Run_DateText.text = date;
    
    [self.Run_DurationText becomeFirstResponder];
}

- (IBAction)SaveAndForword:(id)sender {
   //[self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:sender];
    if (firstSave == 0) {
        [self saveParameters];
        firstSave = 1;
    } else {
        [self SaveORupdateParameter];
    }
}

-(void)SaveORupdateParameter{
    
     PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
   
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
 
     if (!error) {
         NSString *lastinsertedtransactionNo=[object objectForKey:@"Run_No"];
         lastinsertedTrasactionID=[object objectId];
         if ([lastinsertedtransactionNo isEqualToString:self.Run_NoText.text ]) {
             [self updateParameters];
         }
         else{
             [self saveParameters];
         }
        } else {
         [error userInfo];
    
     }
     }];
}

-(void)saveParameters{
    activityIndicatorView.hidden=NO;
    [activityIndicatorView startAnimating];
    
    NSString *Run_no = [self.Run_NoText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *Machine_Name = [self.Machine_NameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Run_Date = [self.Run_DateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Run_duration = [self.Run_DurationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([Run_no length] == 0 ||[Machine_Name length] == 0 ||[Run_Date length] == 0 ||[Run_duration length] == 0) {
        [activityIndicatorView stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        PFObject *transactionObj = [PFObject objectWithClassName:@"Transaction"];
        [transactionObj setObject:self.Run_NoText.text forKey:@"Run_No"];
        [transactionObj setObject:self.Machine_NameText.text forKey:@"Machine_Name"];
        [transactionObj setObject:self.Run_DateText.text forKey:@"Run_Date"];
        [transactionObj setObject:self.Run_DurationText.text forKey:@"Run_Duration"];
        //  parameterObj[@"New Parameter"]=@"The New String";
        
        [transactionObj saveInBackground];
        [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:self];
        // Upload transaction to Parse
        /*[transactionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
                
                [activityIndicatorView stopAnimating];
                
                [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }];*/
    }
}

- (void)updateParameters
{
    [activityIndicatorView startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:lastinsertedTrasactionID block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            [activityIndicatorView stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            [UpdateParameter setObject:self.Run_NoText.text forKey:@"Run_No"];
            [UpdateParameter setObject:self.Machine_NameText.text forKey:@"Machine_Name"];
            [UpdateParameter setObject:self.Run_DateText.text forKey:@"Run_Date"];
            [UpdateParameter setObject:self.Run_DurationText.text forKey:@"Run_Duration"];
            //[UpdateParameter setObject:LastInsertedTransactionNo forKey:@"Run_No"];
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [activityIndicatorView stopAnimating];
            [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:self];
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

- (IBAction)Cancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Alert"
                                                    message:@"Are you sure you want to cancel? Any unsaved data will be lost"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", @"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            break;
        case 1:
            [self DeleteTransaction];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2:
            break;
        default: break;
    }
}

- (void)DeleteTransaction{
    NSArray *DeletionArray=[NSArray arrayWithObjects:@"Transaction",@"Pre_Extraction",@"Run_Process",@"Post_Extraction", nil];
    for (int i=0;i<DeletionArray.count;i++) {
        NSString *ClassName=[DeletionArray objectAtIndex:i];
        PFQuery *query = [PFQuery queryWithClassName:ClassName];
        [query whereKey:@"Run_No" equalTo:self.Run_NoText.text];
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

- (void)viewDidUnload {
    [self setRun_NoText:nil];
    [self setRun_DurationText:nil];
    [self setRun_DateText:nil];
    [self setMachine_NameText:nil];
    
    [super viewDidUnload];
}


//methods to check when a field text is edited, accordingly, adjust keyboard
// Implementing picker for age text field
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
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

/*#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  //  if ([segue.identifier isEqualToString:@"BasicTRansactionDetailsToSegmentedLocationSegue"]) {
       // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       // PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
      //  SegmentedLocationVC *SegmentedLocationVCObj = (SegmentedLocationVC *)segue.destinationViewController;
        //AddTransaction_PreObj.BasicTransactionPF = object;
  //  }

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


@end
