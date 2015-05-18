//
//  Process_RunCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 20/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Process_RunCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UITextField * IntervalText ;
@property (weak, nonatomic) IBOutlet UITextField *ParametersText;
@property (weak, nonatomic) IBOutlet UITextField *Parameters1Text;
@property (weak, nonatomic) IBOutlet UITextField *Parameters2Text;
@property (weak, nonatomic) IBOutlet UITextField *Parameters3Text;
@property (weak,nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *ValueText;
@end
