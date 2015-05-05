//
//  AddTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Run.h"
#import "Process_RunCell.h"
#import "MainMenu.h"
#import <Parse/Parse.h>
#define valueForX 8
@interface AddTransaction_Run ()

@end    

@implementation AddTransaction_Run

@synthesize aTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
          //  NSLog(@"The Objec ts %@",object);
            self.LastInsertedTransactionNo = [object objectForKey:@"Run_No"];
          //  NSLog(@"The String Is To Be %@",self.LastInsertedTransactionNo);
        }
        
        
    }];
   // NSLog(@"The String Is To Be %@",self.LastInsertedTransactionNo);

    
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process_run"];
   // [query1 selectKeys:@[@"Name"]];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
      //  NSLog(@"all types: %ld",(long)objects.count);
       // self.ObjectCount=objects.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found");
            }
            else {
               // [aTableView reloadData];
               // self.dataArray = [[NSMutableArray alloc] initWithObjects:@"Tiger",@"Leopard",@"Snow Leopard",@"Lion",nil];
              //  self.runPalceholderArray=[[NSArray alloc]initWithArray:objects];
              //  NSLog(@"the run process placeholder is %@",self.runPalceholderArray);
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                
                self.RunProcessArray=[[NSMutableArray alloc]init];
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                for (int i=0;i<[self.dataArray count];i++) {
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [self.RunProcessArray addObject:newString];

                }
                
               // NSLog(@"The Data Array Is %@",self.dataArray);
              // self.refreshControl = [[UIRefreshControl alloc]init];
              // [self.aTableView addSubview:self.refreshControl];
              // [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
              
               /* PFQuery *query2 = [PFQuery queryWithClassName:@"Run_Process"];
                [query2 whereKey:@"Parameter_4" equalTo:@"Akshay"];
              //   [query2 selectKeys:@[@"Name"]];
                [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                  //  NSLog(@"all types: %ld",(long)objects.count);
                    // self.ObjectCount=objects.count;
                    if(error){
                        NSLog(@"Error!");
                    }
                    else {
                        if (objects.count == 0) {
                            NSLog(@"None found");
                        }
                        else {
                            [aTableView reloadData];
                            self.refreshControl = [[UIRefreshControl alloc]init];
                            [self.aTableView addSubview:self.refreshControl];
                            [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
                            self.RunProcessArray=[[NSMutableArray alloc]initWithArray:objects];
                        //    NSLog(@"The  self.PostExtractionArray Is %@", self.RunProcessArray);
                            
                            //   NSLog(@"objectArray %@",objects);
                        }
                      
                        }
                   
                    }];*/
                [aTableView reloadData];
                
               }
          }
       
    }];

  /*  PFQuery *query2 = [PFQuery queryWithClassName:@"Parameters"];
    [query2 selectKeys:@[@"Name"]];
    [query2 whereKey:@"Type" equalTo:@"Process_Run"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objectsPF, NSError *error) {
        // iterate through the objects array, which contains PFObjects for each Student
        if (!objectsPF) {
            // Did not find any UserStats for the current user
        } else {
            // Found UserStats
            //self.preExtractionArray=[objectsPF allKeys];
            self.runPalceholderArray=[[NSArray alloc]initWithArray:objectsPF ];
            NSLog(@"The Run Placeholder Extraction.... %@",self.runPalceholderArray);
        }
    }];
*/
    
 //   self.navigationController.navigationBar.topItem.title = @"Data Table";
 /*  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(addORDeleteRows)];[self.navigationItem setLeftBarButtonItem:addButton];
    self.navigationItem.leftBarButtonItem= self.editButtonItem;*/
    
    [super setEditing:YES animated:YES];
    [aTableView setEditing:YES animated:YES];
   // [aTableView reloadData];
    // NSLog(@"AddTransaction_Run Loaded!");
    
    // Do any additional setup after loading the view.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.aTableView reloadData];
}
/*- (void)addORDeleteRows
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [aTableView setEditing:NO animated:NO];
        [aTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [aTableView setEditing:YES animated:YES];
        [aTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = (int)[self.dataArray count];
    //NSLog(@"The Count Is %d",count);
    if(self.editing) count++;
   // NSLog(@"The Count++ Is %d",count++);
    return count;
    

}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"ProcessRunHeaderCellIdentifier";
        
        Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell != nil) {
            cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
             for (int i = indexPath.row ; i < [self.dataArray count]; i++) {
             
            UITextField *valueTextField = [[UITextField alloc] init]; // 10 px padding between each view
            CGRect frameText=CGRectMake(valueTextField.frame.origin.x+102*i, 10, 94, 21);
            
                 [valueTextField setFrame:frameText];
                 valueTextField.tag = i + 1;
                valueTextField.borderStyle = UITextBorderStyleRoundedRect;
                 [valueTextField setReturnKeyType:UIReturnKeyDefault];
                 [valueTextField setEnablesReturnKeyAutomatically:YES];
                 [valueTextField setDelegate:self];
                 valueTextField.placeholder=@"P_1";
                 valueTextField.backgroundColor=[UIColor grayColor];
             
                 [cell.contentView addSubview:valueTextField];
               
             }
        }
        
        /*  int count = 0;
         if(self.editing && indexPath.row != 0)
         count = 1;
         
         if(indexPath.row == ([self.RunProcessArray count]) && self.editing){
         
         //   cell.IntervalText.text = @"Interval ";
         // cell.ParametersText.text = @"Is";
         // cell.Parameters1Text.text=@"Showing";
         //cell.Parameters2Text.text=@"Parameters";
         //cell.Parameters3Text.text=@"Parameters2";
         // cell.ValueText.text = @"Parameters3";
         return cell;
         }*/
         
        
        cell.backgroundColor=[UIColor grayColor];
        cell.IntervalText.text = @"Interval";
        cell.ParametersText.text = @"Parameter_1";
        cell.Parameters1Text.text=@"Parameter_2";
        cell.Parameters2Text.text=@"Parameter_3";
        cell.Parameters3Text.text=@"Parameter_4";
        cell.ValueText.text = @"Value";
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }else
    {
        static NSString *CellIdentifier = @"ProcessRunCellIdentifier";
        
        Process_RunCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell != nil) {
           
            cell = [[Process_RunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            for (int i = indexPath.row ; i < [self.dataArray count]; i++) {
               
                UITextField *valueTextField = [[UITextField alloc] init]; // 10 px padding between each view
                
                CGRect frameText=CGRectMake(valueTextField.frame.origin.x+102*i, 10, 94, 21);
                
                [valueTextField setFrame:frameText];
            
                valueTextField.tag = i + 1;
                
                valueTextField.borderStyle = UITextBorderStyleRoundedRect;
                [valueTextField setReturnKeyType:UIReturnKeyDefault];
                [valueTextField setEnablesReturnKeyAutomatically:YES];
                [valueTextField setDelegate:self];
                valueTextField.placeholder=@"P_!_Add";
                valueTextField.backgroundColor=[UIColor grayColor];
            
                [cell.contentView addSubview:valueTextField];
             
             }
        }
        
        int count = 0;
        if(self.editing && indexPath.row != 0)
            count = 1;
        
        if(indexPath.row == ([self.dataArray count]) && self.editing){
            for (int i = indexPath.row ; i < [self.dataArray count]; i++) {
            UITextField *valueTextField = [[UITextField alloc] init]; // 10 px padding between each view
            
            CGRect frameText=CGRectMake(valueTextField.frame.origin.x+102*i, 10, 94, 21);
            
            [valueTextField setFrame:frameText];
            
            valueTextField.tag = i + 1;
            
            valueTextField.borderStyle = UITextBorderStyleRoundedRect;
            [valueTextField setReturnKeyType:UIReturnKeyDefault];
            [valueTextField setEnablesReturnKeyAutomatically:YES];
            [valueTextField setDelegate:self];
            valueTextField.placeholder=@"P_!_Add";
            valueTextField.backgroundColor=[UIColor grayColor];
            
            [cell.contentView addSubview:valueTextField];
            }
            
          /*  cell.IntervalText.placeholder = @"Interval";
            cell.ParametersText.placeholder = @"Parameter_1";
            cell.Parameters1Text.placeholder=@"Parameter_2";
            cell.Parameters2Text.placeholder=@"Parameter_3";
            cell.Parameters3Text.placeholder=@"Parameter_4";
            cell.ValueText.placeholder = @"Value";*/

            
              /* cell.IntervalText.placeholder = [[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
             cell.ParametersText.placeholder = [[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
             cell.Parameters1Text.placeholder=[[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
            cell.Parameters2Text.placeholder=[[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
            cell.Parameters3Text.placeholder=[[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
             cell.ValueText.placeholder = [[self.runPalceholderArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];*/
            return cell;
        }
        
        /*  cell.IntervalText.text = [[self.dataArray objectAtIndex:indexPath.row ]objectForKey:@"Description"];
         cell.ParametersText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Name"];
         cell.Parameters1Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Type"];
         cell.Parameters2Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Units"];
         cell.Parameters3Text.text= @"Parameter 3";//[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_4"];
         cell.ValueText.text = @"Value";//[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Value"];*/
        
       
        
        
       /* cell.IntervalText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Interval"];
        cell.ParametersText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_1"];
        cell.Parameters1Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_2"];
        cell.Parameters2Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_3"];
        cell.Parameters3Text.text=[[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Parameter_4"];
        cell.ValueText.text = [[self.RunProcessArray objectAtIndex:indexPath.row ]objectForKey:@"Value"];*/
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
/*- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    NSArray *newArray= [[NSArray alloc]initWithArray:self.RunProcessArray];
    NSMutableArray *temArray=[[NSMutableArray alloc]init];
    int i=0;
    for (NSArray *count in newArray) {
       [temArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        

    }
    [aTableView beginUpdates];
    [aTableView insertRowsAtIndexPaths:(NSMutableArray *)temArray withRowAnimation:UITableViewRowAnimationNone];
    [aTableView endUpdates];
}*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (self.editing == NO || !indexPath)
       return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([self.dataArray count]))
        
        return UITableViewCellEditingStyleInsert;
     else
       return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
     [self.dataArray removeObjectAtIndex:indexPath.row];
     [aTableView reloadData];
     }
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self.dataArray insertObject:@"new Value" atIndex:[self.dataArray count]];
        [aTableView reloadData];
    }
}
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
    
    [self.RunProcessArray insertObject:@"new row" atIndex:indexPath.row+1];
    
    [aTableView beginUpdates];
    [aTableView insertRowsAtIndexPaths:(NSArray *)tempArray withRowAnimation:UITableViewRowAnimationFade];
    [aTableView endUpdates];
}*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    //Change as per your table header hight
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (IBAction)Cancel:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
     [self performSegueWithIdentifier:@"RunUnwindToTransactionListSegue" sender:self];
}
/*- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    UITableViewCell *cell = (UITableViewCell *)[[[textField superview]superview ] superview];
    UITextField *nextTextField = [cell.contentView viewWithTag:textField.tag + 1];
    [nextTextField becomeFirstResponder];
    NSLog(@"The Value In Next text Field Is %@",nextTextField.text);
    return nextTextField.text;
}*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *)[[[textField superview]superview ] superview];
    UITableView *table = (UITableView *)[[cell superview] superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    
    for (NSInteger i=textField.tag;i<=textFieldIndexPath.row;i++) {
        [self.GetValuesFromRunTextFieldArray addObject:textField.text];
        NSLog(@"the IndexPathe Array Is %@",self.GetValuesFromRunTextFieldArray);
    }

    
    /*if (textField.tag==0) {
        self.Interval=textField.text;
     //   NSLog(@"Interval %@",self.Interval);
      }
    if (textField.tag==1) {
        self.Parameter1=textField.text;
      //  NSLog(@"Parameter1 %@",self.Parameter1);
    }
    if (textField.tag==2) {
        self.Parameter2=textField.text;
       // NSLog(@"Parameter2 %@",self.Parameter2);
    }
    if (textField.tag==3) {
        self.Parameter3=textField.text;
      ///  NSLog(@"Parameter3 %@",self.Parameter3);
    }
    if (textField.tag==4) {
        self.Value=textField.text;
      //  NSLog(@"Value %@",self.Value);
    }*/
     NSLog(@"Pre Row %ld just finished editing with the value %@  tag is %ld",(long)textFieldIndexPath.row,textField.text ,(long)textField.tag);
    
    
}
-(IBAction)SaveAndForward:(id)sender {
   
   
   [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
    
    if (self.parameterAdd_RunPF != nil) {
      // [self updateParameters];
    }
    else {
        //[self saveParameters];
    }

}

- (void)saveParameters
{
    
   

    
    
    PFObject *NewParameter=[PFObject  objectWithClassName:@"Run_Process" ];
    
    if([NewParameter save]) {
        //  NSLog(@"Successfully Created");
        PFObject *ParameterValue = [PFObject objectWithClassName:@"Run_Process"];
        ParameterValue[@"Interval"] = [self.GetValuesFromRunTextFieldArray objectAtIndex:0];
        ParameterValue[@"Parameter_1"] = [self.GetValuesFromRunTextFieldArray objectAtIndex:1];        ParameterValue[@"Parameter_2"] = [self.GetValuesFromRunTextFieldArray objectAtIndex:2];
        ParameterValue[@"Parameter_3"] = [self.GetValuesFromRunTextFieldArray objectAtIndex:3];
        ParameterValue[@"Parameter_4"] =[self.GetValuesFromRunTextFieldArray objectAtIndex:4];
        ParameterValue[@"Value"] = [self.GetValuesFromRunTextFieldArray objectAtIndex:5];
        ParameterValue[@"Run_No"]=self.LastInsertedTransactionNo;
        
        
        [ParameterValue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                // [self.navigationController popViewControllerAnimated:YES];
               [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
                NSLog(@"The object has been saved");
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Run_Process"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.parameterAdd_RunPF objectId] block:^(PFObject *UpdateParameter, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            
            [UpdateParameter setObject:self.Interval forKey:@"Interval"];
            [UpdateParameter setObject:self.Parameter1 forKey:@"Parameter_1"];
            [UpdateParameter setObject:self.Parameter2 forKey:@"Parameter_2"];
            [UpdateParameter setObject:self.Parameter3 forKey:@"Parameter_3"];
            [UpdateParameter setObject:@"Akshay" forKey:@"Parameter_4"];
            [UpdateParameter setObject:self.Value forKey:@"Value"];
            [UpdateParameter setObject:self.LastInsertedTransactionNo forKey:@"Run_No"];
            
            [UpdateParameter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                   [self performSegueWithIdentifier:@"Run_ProcessToPost_ExtractionSegue" sender:self];
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
    
  //  UITableViewCell *cell = (UITableViewCell *)[[[textField superview]superview ] superview];
   // UITableView *table = (UITableView *)[[cell superview] superview];
   // NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
  //  self.activeField =textField;
    
   
    
    if (aTableView.contentOffset.y != 0)
   {
        [UIView animateWithDuration:0.0 delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        } completion:^(BOOL finished) {
            UITableViewCell *cell = (UITableViewCell*) [[[textField superview] superview] superview];
            [aTableView scrollToRowAtIndexPath:[aTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    }
    
}

/*- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = textField;
}*/

//Methods to take care of UIScrollView when keyboard appears
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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
- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
       self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}
- (void)keyboardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
/*- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    aTableView.contentInset = contentInsets;
    aTableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (self.activeField.frame.origin.y-kbSize.height));
        [aTableView setContentOffset:scrollPoint animated:YES];
    }
    
}*/

// Called when the UIKeyboardWillHideNotification is sent
/*- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    aTableView.contentInset = contentInsets;
    aTableView.scrollIndicatorInsets = contentInsets;
}*/

/*- (void)viewDidUnload {
    [self setInterval:nil];
    [self setParameter1:nil];
    [self setParameter2:nil];
    [self setParameter3:nil];
    [self setParameter4:nil];
    [self setValue:nil];
    
    
    [super viewDidUnload];
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
