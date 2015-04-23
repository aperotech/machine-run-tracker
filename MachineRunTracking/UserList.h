//
//  UserList.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface UserList :PFQueryTableViewController


@property (nonatomic,strong)NSMutableArray *HeaderArray;




@end

//MainMenuToUserListSegue
//userListToAddUserSegue
//userListTouserDetailsSegue
//LoginToMainMenuSegue