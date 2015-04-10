//
//  MachineListCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineListCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *codeLabel;//Name,Location,Capacity
@property(strong,nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic,strong) IBOutlet UILabel *capacityLabel;

@end
