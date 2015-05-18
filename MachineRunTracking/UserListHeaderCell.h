//
//  UserListHeaderCell.h
//  MachineRunTracking
//
//  Created by Malay Parekh on 13/05/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;

@end
