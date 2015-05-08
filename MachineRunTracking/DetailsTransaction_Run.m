//
//  DetailsTransaction_Run.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "DetailsTransaction_Run.h"
#import "SegmentedControlVC.h"
#import "DetailsTransaction_Post.h"
#import "DetailsProcessRunCell.h"
@interface DetailsTransaction_Run ()

@end

@implementation DetailsTransaction_Run
@synthesize DetialsTransaction_RunPF,valueTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicatorView startAnimating];
  
     self.navigationController.navigationItem.title=@"Process Run";
    if (DetialsTransaction_RunPF !=NULL) {
        self.RunNoLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_No"];
        self.RunDateLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Date"];
        self.RunDurationLabel.text=[DetialsTransaction_RunPF objectForKey:@"Run_Duration"];
        self.MachineNameLabel.text=[DetialsTransaction_RunPF objectForKey:@"Machine_Name"];
    }
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process_run"];
   
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (objects.count == 0) {
                NSLog(@"None found1");
            }
            else {
                
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                
                self.RunProcessArray=[[NSMutableArray alloc]init];
                self.dataArray=[[NSMutableArray alloc]initWithArray:objects];
                for (int i=0;i<[self.dataArray count];i++)
                {
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [self.RunProcessArray addObject:newString];
                }
                [self.activityIndicatorView stopAnimating];
            }
                [self.tableView reloadData];
            
        }
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Run_Process"];
    [query2 whereKey:@"Run_No" equalTo:self.RunNoLabel.text];
   
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *runArray, NSError *error) {
        
        self.ObjectCount=runArray.count;
        if(error){
            NSLog(@"Error!");
        }
        else {
            if (runArray.count == 0) {
                NSLog(@"None found2");
            }
            else {
            
                self.runArrayRun=[[NSArray alloc]initWithArray:runArray];
             
                [self.tableView reloadData];
            }
            
        }
    }];

    
}

-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return YES ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ObjectCount + 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *CellIdentifier1 = @"DetailsPostExtractionHeaderCellIdentifier";
    DetailsProcessRunCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    cell.backgroundColor=[UIColor grayColor];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        for (int i = 0 ; i < [self.RunProcessArray count]; i++) {
            
            valueTextField = [[UITextField alloc] init]; // 10 px padding between each view
            CGRect frameText=CGRectMake(valueTextField.frame.origin.x+102*i, 10, 94, 21);
            
            [valueTextField setFrame:frameText];
            valueTextField.tag = i + 1;
            valueTextField.borderStyle = UITextBorderStyleNone;
            [valueTextField setReturnKeyType:UIReturnKeyDefault];
            valueTextField.enabled =FALSE;
            
            [valueTextField setEnablesReturnKeyAutomatically:YES];
            [valueTextField setDelegate:self];
            valueTextField.text=[self.RunProcessArray objectAtIndex:i];
            // valueTextField.backgroundColor=[UIColor grayColor];
            cell.backgroundColor=[UIColor grayColor];
            [cell.contentView addSubview:valueTextField];
            
        }
    }
    

    
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DetailsPostExtractionCellIdentifier";
    
    DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell != nil)
    {
        
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        for (int i = 0 ; i < [self.RunProcessArray count]; i++)
        {
            
            valueTextField = [[UITextField alloc] init]; // 10 px padding between each view
            
            CGRect frameText=CGRectMake(valueTextField.frame.origin.x+102*i, 10, 94, 21);
            
            [valueTextField setFrame:frameText];
            
            valueTextField.tag = i+1 ;
            
            valueTextField.borderStyle = UITextBorderStyleRoundedRect;
            [valueTextField setReturnKeyType:UIReturnKeyDefault];
            [valueTextField setEnablesReturnKeyAutomatically:YES];
            [valueTextField setDelegate:self];
           // valueTextField.placeholder=[self.RunProcessArray objectAtIndex:i];
            
            // if (self.sectionCount>= 1 && indexPath.row!=self.sectionCount )
            if (indexPath.row>=0 && i>=0)
            {
                // NSLog(@"self.GetValuesFromRunTextFieldArray,self.GetValuesFromRunTextFieldArray);
                for (int j=0;j<[self.RunProcessArray count];j++)
                {
                    if (valueTextField.tag==j+1 )
                    {
                        //NSLog(@"valueTextField.tag %ld",valueTextField.tag);
                        
                        valueTextField.text=[self.RunProcessArray objectAtIndex:i];
                        // NSLog(@"valueTextField.text %@",valueTextField.text);
                    }
                }
            }
            
            [cell.contentView addSubview:valueTextField];
            
        }
        
        //return cell;
    }

    
    
    
    
    
    /* if (cell == nil) {
        cell = [[DetailsProcessRunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
      //  cell.backgroundColor=[UIColor grayColor];
    }
    
        cell.IntervalText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Interval"];
        cell.ParametersText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_1"];
        cell.Parameters1Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_2"];
        cell.Parameters2Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_3"];
        cell.Parameters3Text.text=[[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Parameter_4"];
        cell.ValueText.text = [[self.runArrayRun objectAtIndex:0 ]objectForKey:@"Value"];*/
    return cell;
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailsRunToDetailsPostSegue"]){
        DetailsTransaction_Post *DetailsTransaction_PostObj=(DetailsTransaction_Post *)segue.destinationViewController;
        DetailsTransaction_PostObj.DetialsTransaction_PostPF=DetialsTransaction_RunPF;
    }

}


@end
