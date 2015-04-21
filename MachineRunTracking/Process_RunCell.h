//
//  Process_RunCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 20/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Process_RunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * IntervalLabel ;
@property (weak, nonatomic) IBOutlet UILabel *ParametersLabel;
@property (weak, nonatomic) IBOutlet UILabel *Parameters1Label;
@property (weak, nonatomic) IBOutlet UILabel *Parameters2Label;
@property (weak, nonatomic) IBOutlet UILabel *Parameters3Label;
@property (weak,nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *ValueLabel;
@end
