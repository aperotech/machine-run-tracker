//
//  AddTransaction_Basic.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Basic.h"
//#import "SegmentedLocationVC.h"
@interface AddTransaction_Basic ()

@end

@implementation AddTransaction_Basic
@synthesize BasicTransactionPF;
@synthesize Run_NoText,Run_DateText,Run_DurationText,Machine_NameText;
- (void)viewDidLoad {
    [super viewDidLoad];
    Run_NoText.delegate=self;
    Run_DateText.delegate=self;
    Run_DurationText.delegate=self;
    Machine_NameText.delegate=self;
    // Do any additional setup after loading the view.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (IBAction)SaveAndForword:(id)sender {
  // [self performSegueWithIdentifier:@"BasicTransactionToPreExtrationSegue" sender:sender];
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
