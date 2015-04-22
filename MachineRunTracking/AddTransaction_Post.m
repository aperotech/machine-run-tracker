//
//  AddTransaction_Post.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Post.h"
#import <Parse/Parse.h>
#import "TransactionList.h"
#import <Parse/Parse.h>
@interface AddTransaction_Post ()

@end

@implementation AddTransaction_Post
@synthesize parameterAdd_PostPF;

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self setupViewControllers];
    
    
   
        // Do any additional setup after loading the view.
    // PFObject *transactionObj=[PFObject objectWithClassName:@"Transaction"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parameters"];
    [query whereKey:@"Type" equalTo:@"Post_Extraction"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"all types: %ld",(unsigned long)objects.count);
        self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
                 [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                   NSLog(@"objectArray %@",objects);
            }
            
        }
    }];
    
}
- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.ObjectCount;
    return self.ObjectCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Post_ExtractionCellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell != nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        // cell.p_1Text.text = @"New Parameter";
        UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(150,12,300,26)];
        valueTextField.tag = indexPath.row;
        [valueTextField borderStyle];
        valueTextField.backgroundColor =[UIColor grayColor];
        valueTextField.delegate = self;
        valueTextField.placeholder=@"Parameters";
        [cell.contentView addSubview:valueTextField];
        // [valueTextField release];
        // cell.
    }
    // cell.p_1Text.text = @"New Parameter";
    /* for (int i=0; i<self.ObjectCount;i++) {
     if (indexPath.row == i) {
     
     UITextField *parameterTextField = (UITextField *)[cell viewWithTag:i];
     parameterTextField.placeholder = @"Parameter";
     }
     
     }*/
    return cell;
}


/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // NSLog(@"text Field index path %ld ,%@ ",indexPath.row,cell);
}*/
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    UITableView *table = (UITableView *)[[cell superview] superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    if (textField.tag==0) {
        self.Parameter0=textField.text;
        NSLog(@"Parameter0 %@",self.Parameter0);
        
        
    }
    if (textField.tag==1) {
        self.Parameter1=textField.text;
        NSLog(@"Parameter1 %@",self.Parameter1);
        
        
    }
    if (textField.tag==2) {
        self.Parameter2=textField.text;
        NSLog(@"Parameter2 %@",self.Parameter2);
        
        
    }
    
    
    
    NSLog(@"Pre Row %ld just finished editing with the value %@  tag is %ld",(long)textFieldIndexPath.row,textField.text ,(long)textField.tag);
}




-(IBAction)SaveAndExit:(id)sender {
    
    /* NSString *name = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     NSString *description = [descriptionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *type = [typeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *Units = [unitsText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     
     if ([name length] == 0 ||[description length] == 0 ||[type length] == 0 ||[Units length] == 0) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:@"You must enter details"
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     }
     else {*/
    
    
    
    if (parameterAdd_PostPF != nil) {
        [self updateParameters];
    }
    else {
        [self saveParameters];
    }
    //}
    
}

- (void)saveParameters
{
    PFObject *NewParameter=[PFObject  objectWithClassName:@"Post_Extraction" ];
    
    if([NewParameter save]) {
        //  NSLog(@"Successfully Created");
        PFObject *ParameterValue = [PFObject objectWithClassName:@"Post_Extraction"];
        ParameterValue[@"Parameter_1"] = self.Parameter0;
        ParameterValue[@"Parameter_2"] = self.Parameter1;
        ParameterValue[@"Parameter_3"] = self.Parameter2;
        ParameterValue[@"Parameter_4"] = @"Akshay";
        
        [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                // [self.navigationController popViewControllerAnimated:YES];
              ////  [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
               // [self performSegueWithIdentifier:@"UnwindToTransactionListSegue" sender:self];
                NSLog(@"The object has been saved");
                [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];

                
                // The object has been saved.
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                NSLog(@"here was a problem, check error.description");
                // There was a problem, check error.description
            }
        }];
        
        //  class created;
        
    }
    /* PFObject *NewParameter = [PFObject objectWithClassName:@"Pre_Extraction"];
     
     
     [NewParameter setObject:self.Parameter0 forKey:@"Parameter_1"];
     [NewParameter setObject:self.Parameter1 forKey:@"Parameter_2"];
     [NewParameter setObject:self.Parameter2 forKey:@"Parameter_3"];
     [NewParameter setObject:self.Parameter0 forKey:@"Parameter_4"];
     
     
     
     
     //  NewMachine[@"Machine"] = [PFUser currentUser];
     
     [NewParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
     [self.navigationController popViewControllerAnimated:YES];
     } else {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
     message:[error.userInfo objectForKey:@"error"]
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     }
     }];
     */
}

- (void)updateParameters
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Pre_Extraction"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[parameterAdd_PostPF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            [UpdateParameter setObject:self.Parameter0 forKey:@"Parameter_1"];
            [UpdateParameter setObject:self.Parameter1 forKey:@"Parameter_2"];
            [UpdateParameter setObject:self.Parameter2 forKey:@"Parameter_3"];
            [UpdateParameter setObject:self.Parameter0 forKey:@"Parameter_4"];
            
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    [self performSegueWithIdentifier:@"PostUnwindToTransactionListSegue" sender:self];
                    
                   // [self performSegueWithIdentifier:@"Pre_ExtractionToRunExtractionSegue" sender:self];
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
#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
