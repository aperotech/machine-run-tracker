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

@implementation DetailsTransaction_Run {
    UITextField *valueTextField;
    UILabel *headerLabel, *valueLabel;
}

@synthesize DetialsTransaction_RunPF;

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
    self.valueArray=[[NSMutableArray alloc]init];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Parameters"];
    [query1 whereKey:@"Type" equalTo:@"Process Run"];
   
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
                //    NSLog(@"The Data Array IS %@",self.dataArray);
                    NSString *newString=[[objects objectAtIndex:i]valueForKey:@"Name"];
                    [self.RunProcessArray addObject:newString];

                   
                }
                
                [self.activityIndicatorView stopAnimating];
            }
                                NSLog(@"The Run Process Array Is %@",self.RunProcessArray);
            NSLog(@"run Process Array Count %ld",[self.RunProcessArray count]);
            
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
                NSLog(@"The RunArrayRun Is %@",self.runArrayRun);

/*for (int i=0; i<self.runArrayRun.count;i++) {
                    NSString *newString=[self.runArrayRun objectAtIndex:i ];
                    [self.valueArray addObject:newString];
                    NSLog(@"the Value Array is %@",self.valueArray);
                }
  */              //[self.valueArray addObject:<#(id)#>]
                
                
//NSLog(@"run Array Count %ld",[self.runArrayRun count]);
                [self.tableView reloadData];
            }
            
        }
    }];
   // [self getData];
}
/*-(void)getData{
    for (int j=0;j<self.RunProcessArray.count;j++) {
        NSString *new=[self.RunProcessArray objectAtIndex:j];
        self.valueArray=[self.runArrayRun valueForKey:new];
    }
    NSLog(@"Value Array Is %@",self.valueArray);
}*/
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
    return self.ObjectCount ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//[self getData];
    NSString *CellIdentifier1 = @"DetailsPostExtractionHeaderCellIdentifier";
    DetailsProcessRunCell  *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    //cell.backgroundColor=[UIColor lightGrayColor];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        CGRect frameText;
        
        for (int i = 0 ; i < [self.RunProcessArray count]; i++) {
            
            headerLabel = [[UILabel alloc] init]; // 10 px padding between each view
            headerLabel.preferredMaxLayoutWidth = 80;
            headerLabel.numberOfLines = 0;
            headerLabel.lineBreakMode = NSLineBreakByCharWrapping;
            headerLabel.textColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
            
            if (i == 0) {
                frameText=CGRectMake(10, 5, 80, 17);
            } else {
                frameText=CGRectMake(headerLabel.frame.origin.x+105*i, 5, 80, 17);
            }
            
            [headerLabel setFrame:frameText];
            headerLabel.tag = i + 1;
            
            headerLabel.text = [self.RunProcessArray objectAtIndex:i];
            
            //headerLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor darkGrayColor];
            [cell.contentView addSubview:headerLabel];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DetailsPostExtractionCellIdentifier";
    
    DetailsProcessRunCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell != nil) {
        cell = [[DetailsProcessRunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        CGRect frameText;
        
        for (int i = 0 ; i < [self.RunProcessArray count]; i++) {
            valueLabel = [[UILabel alloc] init];
            valueLabel.preferredMaxLayoutWidth = 80;
            valueLabel.numberOfLines = 1;
            valueLabel.lineBreakMode = NSLineBreakByCharWrapping;
            valueLabel.textColor = [UIColor blackColor];
            valueLabel.font = [UIFont systemFontOfSize:14.0];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                frameText=CGRectMake(10, 14, 80, 17);
            } else {
                frameText=CGRectMake(headerLabel.frame.origin.x+100*i, 14, 80, 17);
            }
            
            [valueLabel setFrame:frameText];
            valueLabel.tag = i+1 ;
            
            // if (self.sectionCount>= 1 && indexPath.row!=self.sectionCount )
//for (int k=0;k<[self.runArrayRun count];k++) {
            if (indexPath.row>=0 && i>=0) {
                
              //
                for (int j=0;j<[self.RunProcessArray count];j++) {
                
                    if (valueLabel.tag==j+1 ) {
                         valueLabel.text=[[self.runArrayRun objectAtIndex:0]objectForKey:[self.RunProcessArray objectAtIndex:j]];
                    }
                }
//}
            }
            
            [cell.contentView addSubview:valueLabel];
        }
        //return cell;
    }
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
