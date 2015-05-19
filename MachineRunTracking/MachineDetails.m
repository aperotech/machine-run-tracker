//
//  MachineDetails.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "MachineDetails.h"
#import <Parse/Parse.h>

@interface MachineDetails ()

@end

@implementation MachineDetails {
    NSArray *frequency;
    UIPickerView *frequencyPicker;
    UIDatePicker *datePicker;
    UIToolbar *frequencyPickerToolbar, *datePickerToolbar;
    NSString *date, *freq, *userType;
    NSDateFormatter *formatter;
}

@synthesize codeText,nameText,descriptionText,trackingFrequencyText,locationText,capacityText,maintanceFrequencyText,lastMaintanceDate, machineObject, scrollView, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.topItem.title=@"";
    
    if (machineObject != nil) {
    codeText.text=[machineObject objectForKey:@"Code"];
    nameText.text=[machineObject objectForKey:@"Machine_Name"];
    descriptionText.text=[machineObject objectForKey:@"Description"];
    trackingFrequencyText.text=[machineObject objectForKey:@"Tracking_Frequency"];
    locationText.text=[machineObject objectForKey:@"Location"];
    capacityText.text=[machineObject objectForKey:@"Capacity"];
    maintanceFrequencyText.text=[machineObject objectForKey:@"Maintenance"];
    lastMaintanceDate.text=[machineObject objectForKey:@"LastMaintain_Date"];
    }
    
    userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    
    if ([userType isEqualToString:@"Standard"]) {
        [self.descriptionText setUserInteractionEnabled:FALSE];
        [self.trackingFrequencyText setUserInteractionEnabled:FALSE];
        [self.capacityText setUserInteractionEnabled:FALSE];
        [self.locationText setUserInteractionEnabled:FALSE];
        [self.maintanceFrequencyText setUserInteractionEnabled:FALSE];
        [self.lastMaintanceDate setUserInteractionEnabled:FALSE];
        [self.navigationItem.rightBarButtonItem setEnabled:FALSE];
    }
    
    //Initialize frequency picker
    frequency = [NSArray arrayWithObjects:@"Daily",@"Weekly", @"Monthly", @"Quarterly", @"Semi-Annually", @"Annually", nil];
    
    frequencyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, self.locationText.frame.origin.y, 288, 120)];
    frequencyPicker.delegate = self;
    frequencyPicker.dataSource = self;
    
    [frequencyPicker setBackgroundColor:[UIColor lightTextColor]];
    [frequencyPicker setShowsSelectionIndicator:YES];
    [self.trackingFrequencyText setInputView:frequencyPicker];
    [self.maintanceFrequencyText setInputView:frequencyPicker];
    
    //Creating a toolbar above picker where Done button can be added
    frequencyPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [frequencyPickerToolbar setBarStyle:UIBarStyleDefault];
    [frequencyPickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(frequencyPickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [frequencyPickerToolbar setItems:barItems animated:NO];
    [self.trackingFrequencyText setInputAccessoryView:frequencyPickerToolbar];
    [self.maintanceFrequencyText setInputAccessoryView:frequencyPickerToolbar];
    
    //Creating date picker for last maintenance date
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM YYYY"];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(16, (self.lastMaintanceDate.frame.origin.y + 10.0), 288, 162)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setBackgroundColor:[UIColor lightTextColor]];
    [self.lastMaintanceDate setInputView:datePicker];
    
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
    [self.lastMaintanceDate setInputAccessoryView:datePickerToolbar];
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
    if (textField == self.descriptionText) {
        [self.trackingFrequencyText becomeFirstResponder];
    } else if (textField == self.capacityText) {
        [self.locationText becomeFirstResponder];
    } else if (textField == self.locationText) {
        [self.maintanceFrequencyText becomeFirstResponder];
    }
    
    return YES;
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.trackingFrequencyText | textField == self.maintanceFrequencyText) {
        return NO;
    }
    
    if (textField.text.length >= 40 && range.length == 0)
        return NO;
    // Only characters in the NSCharacterSet you choose will insertable.
    if ([textField isEqual:self.nameText]) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }else if ([textField isEqual:locationText]) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }else if ([textField isEqual:self.capacityText]){
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789. "] invertedSet];
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
    return frequency.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [frequency objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.activeField == self.trackingFrequencyText) {
        self.trackingFrequencyText.text = [frequency objectAtIndex:row];
    } else if (self.activeField == self.maintanceFrequencyText){
        self.maintanceFrequencyText.text = [frequency objectAtIndex:row];
    }
    freq = [frequency objectAtIndex:row];
}

//Method to call when Done is clicked on Age picker drop down
- (void)frequencyPickerDoneClicked {
    if (self.activeField == self.trackingFrequencyText) {
        if ([self.trackingFrequencyText.text isEqualToString:[machineObject objectForKey:@"Tracking_Frequency"]] && freq==NULL) {
            self.trackingFrequencyText.text = [frequency objectAtIndex:0];
        } else {
            self.trackingFrequencyText.text = freq;
        }
        [self.capacityText becomeFirstResponder];
    }
    if (self.activeField == self.maintanceFrequencyText) {
        if ([self.maintanceFrequencyText.text isEqualToString:[machineObject objectForKey:@"Maintenance"]] && freq == NULL) {
            self.maintanceFrequencyText.text = [frequency objectAtIndex:0];
        } else {
            self.maintanceFrequencyText.text = freq;
        }
        [self.lastMaintanceDate becomeFirstResponder];
    }
}

//Method to call when Done is clicked on Date picker drop down
- (void)datePickerDoneClicked {
    date = [formatter stringFromDate:datePicker.date];
    self.lastMaintanceDate.text = date;
    
    [self.lastMaintanceDate resignFirstResponder];
}

- (IBAction)UpdateButton:(id)sender {
    [activityIndicator startAnimating];
    NSString *code = [codeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trackingFrequency = [trackingFrequencyText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *location = [locationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *capacity = [capacityText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *maintainFrequency = [maintanceFrequencyText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *LastMaintainDate = [lastMaintanceDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([code length] == 0 ||[name length] == 0 ||[location length] == 0 ||[capacity length] == 0 ||[description length] == 0 ||[trackingFrequency length] == 0 ||[maintainFrequency length] == 0 ||[LastMaintainDate length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        
            
            if (machineObject != nil) {
                [self updateNote];
            }
            else {
                [self saveNote];
            }
        }
    
}

- (void)saveNote
{
    
    PFObject *NewMachine = [PFObject objectWithClassName:@"Machine"];
    
    [NewMachine setObject:codeText.text forKey:@"Code"];
    [NewMachine setObject:nameText.text forKey:@"Machine_Name"];
    [NewMachine setObject:descriptionText.text forKey:@"Description"];
    [NewMachine setObject:trackingFrequencyText.text forKey:@"Tracking_Frequency"];
    [NewMachine setObject:locationText.text forKey:@"Location"];
    [NewMachine setObject:capacityText.text forKey:@"Capacity"];
    [NewMachine setObject:maintanceFrequencyText.text forKey:@"Maintenance"];
    [NewMachine setObject:lastMaintanceDate.text forKey:@"LastMaintain_Date"];

   
   
  //  NewMachine[@"Machine"] = [PFUser currentUser];
    
    [NewMachine saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [activityIndicator stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (void)updateNote
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Machine"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[machineObject objectId] block:^(PFObject *UpdateMachine, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            [UpdateMachine setObject:codeText.text forKey:@"Code"];
            [UpdateMachine setObject:nameText.text forKey:@"Machine_Name"];
            [UpdateMachine setObject:descriptionText.text forKey:@"Description"];
            [UpdateMachine setObject:trackingFrequencyText.text forKey:@"Tracking_Frequency"];
            [UpdateMachine setObject:locationText.text forKey:@"Location"];
            [UpdateMachine setObject:capacityText.text forKey:@"Capacity"];
            [UpdateMachine setObject:maintanceFrequencyText.text forKey:@"Maintenance"];
            [UpdateMachine setObject:lastMaintanceDate.text forKey:@"LastMaintain_Date"];
            
            [UpdateMachine saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    [activityIndicator stopAnimating];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    [activityIndicator stopAnimating];
                }
            }];
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

/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIScrollView setAnimationBeginsFromCurrentState: YES];
    [UIScrollView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIScrollView commitAnimations];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
