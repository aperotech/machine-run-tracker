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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the Machine" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the Machine from Parse cloud
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
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

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
