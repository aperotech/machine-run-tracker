//
//  SegmentedLocationVC.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 15/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedLocationVC : UIViewController
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSArray *ViewControllers;

@end
