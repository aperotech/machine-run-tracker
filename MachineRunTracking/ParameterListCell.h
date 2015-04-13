//
//  ParameterListCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterListCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *parameterName;
@property(strong,nonatomic) IBOutlet UILabel *parameterType;
@property(strong,nonatomic) IBOutlet UILabel *parameterUnits;
@end
