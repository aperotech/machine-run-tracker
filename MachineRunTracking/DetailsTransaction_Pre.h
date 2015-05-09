//
//  DetailsTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface DetailsTransaction_Pre : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActivityItemSource>
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *RunDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *Run_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *MachineNameLabel;
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)PFObject *DetialsTransaction_PrePF;

@property (strong,nonatomic)NSArray *runArrayPre;
@property(nonatomic,strong)NSArray *preExtractionArray;
@property (nonatomic ,strong)NSMutableArray *RunProcessArray;

@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic)NSInteger ObjectCount;
@end
