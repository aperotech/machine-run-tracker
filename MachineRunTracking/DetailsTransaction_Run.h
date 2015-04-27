//
//  DetailsTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface DetailsTransaction_Run : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *MachineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunNoLabel;
@property(strong,nonatomic)PFObject *DetialsTransaction_RunPF;
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)NSInteger ObjectCount;
@property (strong,nonatomic)NSArray *runArrayRun;
@end
