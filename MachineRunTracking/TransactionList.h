//
//  TransactionList.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
@interface TransactionList : PFQueryTableViewController<UIActivityItemSource>
@property (nonatomic, strong) PFUser * CurrentUser;
@property BOOL *PermissionFlag;

@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
