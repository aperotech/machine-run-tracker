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
    NSString *date, *Machine;
    NSDateFormatter *formatter;


}


@synthesize BasicTransactionPF;
@synthesize Run_NoText,Run_DateText,Run_DurationText,Machine_NameText;
@synthesize activityView;
- (void)viewDidLoad {
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    [activityView stopAnimating];
    
    [self.view addSubview:activityView];
    [super viewDidLoad];
     self.navigationController.navigationBar.topItem.title=@"";
   
    /*Run_NoText.delegate=self;
    Run_DateText.delegate=self;
    Run_DurationText.delegate=self;
    Machine_NameText.delegate=self;*/
    // Do any additional setup after loading the view.
   // activityView = [[UIActivityIndicatorView alloc]                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
  //  activityView.center=self.view.center;
   // [activityView startAnimating];
   // [self.view addSubview:activityView];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Machine"];
    
   [query1 selectKeys:@[@"Machine_Name"]];
    
    // NSLog(@"The Query For Pre_Extraction %@",query1);
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        //   NSLog(@"all types: %ld",(long)objects.count);
       // self.ObjectCount=objects.count;
        if(!error){
            
             Machine_NameArray = [NSMutableArray arrayWithCapacity:objects.count]; // make an array to hold the cities
            for(PFObject* obj in objects) {
                [Machine_NameArray addObject:[obj objectForKey:@"Machine_Name"]];
                NSLog(@"Machine Array Is %@",Machine_NameArray);
            }
            //[activityView stopAnimating];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
           
            
        }
    }];
    
    //Initialize frequency picker
   // frequency = [NSArray arrayWithObjects:@"Daily",@"Weekly", @"Monthly", @"Quarterly", @"Semi-Annually", @"Annually", nil];

    
    
    MachinePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, Run_DurationText.frame.origin.y, 288, 120)];
    MachinePicker.delegate = self;
    MachinePicker.dataSource = self;
    
    [MachinePicker setBackgroundColor:[UIColor lightTextColor]];
    [MachinePicker setShowsSelectionIndicator:YES];
    [Machine_NameText setInputView:MachinePicker];
    [Machine_NameText setInputView:MachinePicker];
    
    //Creating a toolbar above picker where Done button can be added
    MachinePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [MachinePickerToolbar setBarStyle:UIBarStyleDefault];
    [MachinePickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(frequencyPickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [MachinePickerToolbar setItems:barItems animated:NO];
    [Machine_NameText setInputAccessoryView:MachinePickerToolbar];
    [Machine_NameText setInputAccessoryView:MachinePickerToolbar];
    
    //Creating date picker for last maintenance date
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM YYYY"];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(16, (Run_DateText.frame.origin.y + 10.0), 288, 162)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setBackgroundColor:[UIColor lightTextColor]];
    [Run_DateText setInputView:datePicker];
    
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
    [Run_DateText setInputAccessoryView:datePickerToolbar];
    
    
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

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == Run_NoText) {
        [Machine_NameText becomeFirstResponder];
    } else if (textField == Machine_NameText) {
        [Run_DateText becomeFirstResponder];
    } else if (textField == Run_DateText) {
        [Run_DurationText becomeFirstResponder];
    }else if (textField == Run_DurationText) {
        [Run_DurationText resignFirstResponder];
    }
    
    return YES;
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == Machine_NameText | textField == Machine_NameText) {
        return NO;
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
    if (self.activeField == Machine_NameText) {
        Machine_NameText.text = [Machine_NameArray objectAtIndex:row];
    } else if (self.activeField == Machine_NameText){
        Machine_NameText.text = [Machine_NameArray objectAtIndex:row];
    }
    Machine = [Machine_NameArray objectAtIndex:row];
}

//Method to call when Done is clicked on Age picker drop down
- (void)frequencyPickerDoneClicked {
    if (self.activeField == Run_DateText) {
        if ([Machine_NameText.text isEqualToString:@""]) {
            Machine_NameText.text = [Machine_NameArray objectAtIndex:0];
        }
        [Run_DateText becomeFirstResponder];
    }
    if (self.activeField == Machine_NameText) {
        if ([Machine_NameText.text isEqualToString:@""]) {
            Machine_NameText.text = Machine;
        }
        [Run_DateText becomeFirstResponder];
    }
}



//Method to call when Done is clicked on Date picker drop down
- (void)datePickerDoneClicked {
    date = [formatter stringFromDate:datePicker.date];
    Run_DateText.text = date;
    
    [Run_DateText resignFirstResponder];
}


/*-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}*/

- (IBAction)SaveAndForword:(id)sender {
//[self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:sender];
    
   
    NSString *Run_no = [Run_NoText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *Machine_Name = [Machine_NameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Run_Date = [Run_DateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *Run_duration = [Run_DurationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([Run_no length] == 0 ||[Machine_Name length] == 0 ||[Run_Date length] == 0 ||[Run_duration length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else{
    PFObject *transactionObj = [PFObject objectWithClassName:@"Transaction"];
    [transactionObj setObject:Run_NoText.text forKey:@"Run_No"];
    [transactionObj setObject:Machine_NameText.text forKey:@"Machine_Name"];
    [transactionObj setObject:Run_DateText.text forKey:@"Run_Date"];
    [transactionObj setObject:Run_DurationText.text forKey:@"Run_Duration"];
    //  parameterObj[@"New Parameter"]=@"The New String";
    
    
    // Upload Machine to Parse
    [transactionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if (!error) {
            // Show success message
            // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the Parameters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //  [alert show];
            
            // Notify table view to reload the Machine from Parse cloud
          //  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            NSLog(@"Successfull Saved Transaction");
              [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:sender];
            [activityView stopAnimating];
            // Dismiss the controller
           // [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    }
}

- (IBAction)Cancel:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.activeField = textField;
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


#pragma mark - Textfield delegate





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
