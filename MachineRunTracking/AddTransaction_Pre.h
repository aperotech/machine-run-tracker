//
//  AddTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Pre : UIViewController
{
    BOOL Pre_extractionFlag;
}
//@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSArray *ViewControllers;

@property(nonatomic)NSInteger ObjectCount;

@end
