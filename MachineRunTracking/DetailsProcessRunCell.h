//
//  DetailsProcessRunCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsProcessRunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * IntervalText ;
@property (weak, nonatomic) IBOutlet UILabel *ParametersText;
@property (weak, nonatomic) IBOutlet UILabel *Parameters1Text;
@property (weak, nonatomic) IBOutlet UILabel *Parameters2Text;
@property (weak, nonatomic) IBOutlet UILabel *Parameters3Text;
@property (weak,nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *ValueText;
@end
