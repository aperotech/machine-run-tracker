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
    int value;
    NSDateFormatter *formatter;
}


@synthesize BasicTransactionPF, Run_NoText,Run_DateText,Run_DurationText,Machine_NameText,activityIndicatorView;

- (void)viewDidLoad {
   
    [super viewDidLoad];
     self.navigationController.navigationBar.topItem.title=@"";
    activityIndicatorView.hidden=YES;
    
    PFQuery *query=[PFQuery queryWithClassName:@"Transaction"];
   
    [query orderByDescending:@"Run_No"];
    
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
    
     [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error){
            
             Machine_NameArray = [NSMutableArray arrayWithCapacity:objects.count]; // make an array to hold the cities
            for(PFObject* obj in objects) {
                [Machine_NameArray addObject:[obj objectForKey:@"Machine_Name"]];
              
            }
            
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
#pragma mark - Textfield delegate

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
    if (textField == self.Machine_NameText | textField == self.Machine_NameText) {
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


/*-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}*/

- (IBAction)SaveAndForword:(id)sender {
//[self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:sender];
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
    
    
    // Upload Machine to Parse
    [transactionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if (!error) {
          
            [activityIndicatorView stopAnimating];
            
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:self];
            } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    }
}

- (IBAction)Cancel:(id)sender {
    
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
