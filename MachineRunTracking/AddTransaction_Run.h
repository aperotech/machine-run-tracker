//
//  AddTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Run : UIViewController
@property (strong,nonatomic)IBOutlet UISegmentedControl *segmentControl;

- (IBAction)segmentedControlIndexChanged;

@end
