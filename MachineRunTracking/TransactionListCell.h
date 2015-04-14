//
//  TransactionListCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionListCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *Run_No;
@property(strong,nonatomic) IBOutlet UILabel *Machine_Name;
@property(strong,nonatomic) IBOutlet UILabel *Run_Date;
@end
