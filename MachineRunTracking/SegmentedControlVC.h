//
//  SegmentedControlVC.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import <Parse/Parse.h>
@interface SegmentedControlVC : UIViewController
@property (strong,nonatomic) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;

@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property(strong,nonatomic) NSMutableArray *preExtractionArraySegment;

@property(strong,nonatomic)PFObject *SegmentControlPF;
@property (nonatomic, weak) ContainerViewController *containerView;


- (IBAction)segmentControlChanged:(id)sender;


@end
