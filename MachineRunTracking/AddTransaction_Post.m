//
//  AddTransaction_Post.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "AddTransaction_Post.h"
#import <Parse/Parse.h>
@interface AddTransaction_Post ()

@end

@implementation AddTransaction_Post
@synthesize Post_ExtractionLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // [self setupViewControllers];
    
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationItem.title=@"Pre";
   
    NSLog(@"AddTransaction_post Loaded!");
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
    return self.ObjectCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Post_ExtractionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
    
    
    NSLog(@"Row %ld just finished editing with the value %@  tag is %ld",(long)textFieldIndexPath.row,textField.text ,(long)textField.tag);
    
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
