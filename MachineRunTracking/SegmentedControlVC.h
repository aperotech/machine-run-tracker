//
//  SegmentedControlVC.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedControlVC : UIViewController
@property (strong,nonatomic) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property(strong,nonatomic) NSMutableArray *preExtractionArraySegment;

@end
