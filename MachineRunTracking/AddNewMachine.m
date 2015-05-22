//
//  AddNewMachine.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddNewMachine.h"
#import <Parse/Parse.h>

@interface AddNewMachine ()

@end

@implementation AddNewMachine {
    NSArray *frequency;
    UIPickerView *frequencyPicker;
    UIDatePicker *datePicker;
    UIToolbar *frequencyPickerToolbar, *datePickerToolbar;
    NSString *date, *freq, *LastInsertedMachineNo, *numbers, *MachineNo;
    int value;
    NSDateFormatter *formatter;
}


@synthesize codeText,nameText,descriptionText,trackingFrequencyText,locationText,capacityText,maintanceFrequencyText,lastMaintanceDate, scrollView, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.topItem.title=@"";
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800.0)];
    
    self.codeText.enabled = FALSE;
    
    // Do any additional setup after loading the view.
    
   //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
 //   self.datePicker=[[UIDatePicker alloc] init];//frames are just for demo
 //   [lastMaintanceDate setInputView:self.datePicker];
    
    PFQuery *query=[PFQuery queryWithClassName:@"Machine"];
    [query orderByDescending:@"Code"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.activityIndicator startAnimating];
        
        if (!object) {
            value = 1;
            MachineNo=[NSString stringWithFormat:@"M%03i",value];
            [self.activityIndicator stopAnimating];
            self.codeText.text=MachineNo;
        } else {
                       
            LastInsertedMachineNo = [object objectForKey:@"Code"];
            numbers = [LastInsertedMachineNo stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
            value = [numbers intValue];
            
            MachineNo=[NSString stringWithFormat:@"M%03i",value+1];
            [self.activityIndicator stopAnimating];
            self.codeText.text=MachineNo;
            //[activityIndicator stopAnimating];
        }
    }];
    
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
/*- (void)keyboardWillShow:(NSNotification *)notification
{
    if(self.datePickerToolbar == nil) {
        self.datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 400, 320, 44)] ;
        [self.datePickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
        [self.datePickerToolbar sizeToFit];
        
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.4];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];               NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,doneButton1, nil];
        
        [self.datePickerToolbar setItems:itemsArray];
        
        
        [lastMaintanceDate setInputAccessoryView:self.datePickerToolbar];
        [self.scrollView addSubview:self.datePickerToolbar];
        [UIScrollView commitAnimations];
    }
}
*/


/*-(void)resignKeyboard {
    
    [self.datePickerToolbar removeFromSuperview];
    [lastMaintanceDate resignFirstResponder];
    ///do nescessary date calculation here
    
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (textField == self.codeText) {
        [self.nameText becomeFirstResponder];
    } else if (textField == self.nameText) {
        [self.descriptionText becomeFirstResponder];
    } else if (textField == self.descriptionText) {
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
        if ([self.trackingFrequencyText.text isEqualToString:@""]) {
            self.trackingFrequencyText.text = [frequency objectAtIndex:0];
        }
        [self.capacityText becomeFirstResponder];
    }
    if (self.activeField == self.maintanceFrequencyText) {
        if ([self.maintanceFrequencyText.text isEqualToString:@""]) {
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


- (IBAction)save:(id)sender {
    [activityIndicator startAnimating];
    // Create PFObject with recipe information
    PFObject *machineObj = [PFObject objectWithClassName:@"Machine"];
    [machineObj setObject:codeText.text forKey:@"Code"];
    [machineObj setObject:nameText.text forKey:@"Machine_Name"];
    [machineObj setObject:descriptionText.text forKey:@"Description"];
    [machineObj setObject:trackingFrequencyText.text forKey:@"Tracking_Frequency"];
    [machineObj setObject:locationText.text forKey:@"Location"];
    [machineObj setObject:capacityText.text forKey:@"Capacity"];
    [machineObj setObject:maintanceFrequencyText.text forKey:@"Maintenance"];
    [machineObj setObject:lastMaintanceDate.text forKey:@"LastMaintain_Date"];
    
    
    // Upload Machine to Parse
    [machineObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        
        if (!error) {
            // Show success message
          //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the Machine" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           // [alert show];
            
            // Notify table view to reload the Machine from Parse cloud
            [activityIndicator stopAnimating];
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setCodeText:nil];
    [self setNameText:nil];
    [self setDescriptionText:nil];
    [self setTrackingFrequencyText:nil];
    [self setLocationText:nil];
    [self setCapacityText:nil];
    [self setMaintanceFrequencyText:nil];
    [self setLastMaintanceDate:nil];
   
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
