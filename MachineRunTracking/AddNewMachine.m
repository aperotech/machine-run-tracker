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

@implementation AddNewMachine
@synthesize codeText,nameText,descriptionText,trackingFrequencyText,locationText,capacityText,maintanceFrequencyText,lastMaintanceDate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationController.navigationBar.topItem.title=@"";
    
    codeText.delegate=self;
    nameText.delegate=self;
    descriptionText.delegate=self;
    trackingFrequencyText.delegate=self;
    locationText.delegate=self;
    capacityText.delegate=self;
    maintanceFrequencyText.delegate=self;
    lastMaintanceDate.delegate=self;
    // Do any additional setup after loading the view.
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
 //   self.datePicker=[[UIDatePicker alloc] init];//frames are just for demo
 //   [lastMaintanceDate setInputView:self.datePicker];
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

- (IBAction)save:(id)sender {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
             [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


/*- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
}*/

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    const int movementDistance = -125; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIScrollView setAnimationBeginsFromCurrentState: YES];
    [UIScrollView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIScrollView commitAnimations];
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
