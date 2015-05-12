//
//  UserListCell.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserListCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong,nonatomic)IBOutlet UILabel *userTypeLabel;
@property (strong,nonatomic)IBOutlet UILabel *userEmailLabel;

@end
