//
//  MachineLIst.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface MachineLIst : PFQueryTableViewController<UIActivityItemSource>
@property BOOL *PermissionFlag;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
