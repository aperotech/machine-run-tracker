//
//  AddTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Pre : UIViewController
//@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (strong,nonatomic)IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic)NSInteger ObjectCount;
- (IBAction)segmentedControlIndexChanged;
@end
