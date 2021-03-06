//
//  DetailsTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailsTransaction_Pre : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *RunDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *Run_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *MachineNameLabel;
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic)PFObject *preTransobject;

@end
