//
//  SegmentedLocationVC.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 15/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTransaction_Pre.h"

@interface SegmentedLocationVC : UIViewController
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;

@property(strong,nonatomic) NSMutableArray *preExtractionArraySegment;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;

@end
