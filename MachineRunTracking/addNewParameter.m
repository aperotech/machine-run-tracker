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

@implementation addNewParameter
@synthesize nameText,descriptionText,typeText,unitsText;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    nameText.delegate = self;
    descriptionText.delegate = self;
    typeText.delegate=self;
    unitsText.delegate=self;
    // Do any additional setup after loading the view.
    self.myArray = [NSArray arrayWithObjects:@"Pre_Extraction",@"Process_run",@"Post_Extraction",nil];
    self.picker.dataSource=self;
    self.picker.delegate=self;
    [self loadItemData];
}

#pragma mark- UIPicker View
- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker{
    picker.delegate = self;
    picker.dataSource = self;
    textField.delegate = self;
    textField.inputView = picker;
}

-(void)loadItemData {
    self.pickerArray  = [[NSArray alloc] initWithArray:self.myArray];
    
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:self.typeText :self.picker];
    
    
}



#pragma mark - Keyboard delegate stuff

// let tapping on the background (off the input field) close the thing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [typeText resignFirstResponder];
    
}

#pragma mark - Picker delegate stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return self.pickerArray.count;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return [self.pickerArray objectAtIndex:row];
    }
    
    
    return @"???";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        typeText.text = [self.pickerArray objectAtIndex:row];
        
    }
    
    [[self view] endEditing:YES];
}



- (IBAction)save:(id)sender {
    // Create PFObject with recipe information
    PFObject *parameterObj = [PFObject objectWithClassName:@"Parameters"];
    [parameterObj setObject:nameText.text forKey:@"Name"];
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
    [self setNameText:nil];
    [self setTypeText:nil];
    [self setUnitsText:nil];
    [self setDescriptionText:nil];
    
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
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIScrollView setAnimationBeginsFromCurrentState: YES];
    [UIScrollView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


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
