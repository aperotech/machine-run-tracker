//
//  DetailsTransaction_Post.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailsTransaction_Post : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *RunDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *MachineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RunNoLabel;
@property(strong,nonatomic)PFObject *DetialsTransaction_PostPF;
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic)NSArray *runArrayPost;

@property(nonatomic,strong)NSArray *PostExtractionArray;
@property(nonatomic ,strong)NSMutableArray *RunProcessArray;
@property(nonatomic)NSInteger ObjectCount;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
