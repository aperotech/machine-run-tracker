//
//  addNewParameter.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "addNewParameter.h"
#import <Parse/Parse.h>

@interface addNewParameter ()

@end

@implementation addNewParameter {
    NSArray *parameterType;
    UIPickerView *parameterPicker;
    UIToolbar *parameterPickerToolbar;
}

@synthesize nameText,descriptionText,typeText,unitsText, scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //Initialize user picker
    parameterType = [NSArray arrayWithObjects:@"Pre-Extraction", @"Process Run", @"Post-Extraction", nil];
    
    parameterPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(16, self.unitsText.frame.origin.y, 288, 120)];
    parameterPicker.delegate = self;
    parameterPicker.dataSource = self;
    
    [parameterPicker setBackgroundColor:[UIColor lightTextColor]];
    [parameterPicker setShowsSelectionIndicator:YES];
    [self.typeText setInputView:parameterPicker];
    
    //Creating a toolbar above picker where Done button can be added
    parameterPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 288, 40)];
    [parameterPickerToolbar setBarStyle:UIBarStyleDefault];
    [parameterPickerToolbar sizeToFit];
    
    //Create Done button to add to picker toolbar
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(parameterPickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [parameterPickerToolbar setItems:barItems animated:YES];
    [self.typeText setInputAccessoryView:parameterPickerToolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationPortrait;
}
#pragma mark - Picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return parameterType.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [parameterType objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.typeText.text = [parameterType objectAtIndex:row];
}

//Method to disable any user input for the user type text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.typeText ) {
        return NO;
    }
    
    if (textField.text.length >= 40 && range.length == 0)
        return NO;
    
    // Only characters in the NSCharacterSet you choose will insertable.
    if ([textField isEqual:self.nameText]) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_() 1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }else if ([textField isEqual:unitsText]) {
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz: "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

//Method to call when Done is clicked on Age picker drop down
- (void)parameterPickerDoneClicked {
    if ([self.typeText.text isEqualToString:@""]) {
        self.typeText.text = [parameterType objectAtIndex:0];
    }
    
    [self.unitsText becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameText) {
        [self.descriptionText becomeFirstResponder];
    } else if (textField == self.descriptionText) {
        [self.typeText becomeFirstResponder];
    } else if (textField == self.unitsText) {
        [self.unitsText resignFirstResponder];
    }
    return YES;
}

- (IBAction)save:(id)sender {
    [self.activityIndicator startAnimating];
    
    NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *parameterName = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *type = [typeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *units = [unitsText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([parameterName length] == 0 ||[description length] == 0 ||[type length] == 0 ||[units length] == 0) {
        [self.activityIndicator stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You must enter details"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

    
    
    
    
    
    else{
    
    
    // Create PFObject with recipe information
    PFObject *parameterObj = [PFObject objectWithClassName:@"Parameters"];
    NSString* string1 = nameText.text;
    NSString* string2 = [[[string1 stringByReplacingOccurrencesOfString:@" " withString:@"_"]stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
    [parameterObj setObject:string2 forKey:@"Name"];
    [parameterObj setObject:descriptionText.text forKey:@"Description"];
    [parameterObj setObject:typeText.text forKey:@"Type"];
    [parameterObj setObject:unitsText.text forKey:@"Units"];
  //  parameterObj[@"New Parameter"]=@"The New String";
    
    
    // Upload Machine to Parse
    [parameterObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if (!error) {
            // Show success message
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the Parameters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          //  [alert show];

            [self.activityIndicator stopAnimating];
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setNameText:nil];
    [self setTypeText:nil];
    [self setUnitsText:nil];
    [self setDescriptionText:nil];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
