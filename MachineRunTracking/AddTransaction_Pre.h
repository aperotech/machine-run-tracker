//
//  AddTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SegmentedLocationVC.h"
#import <Parse/Parse.h>
/*@class AddTransaction_Pre;
@protocol AddTransaction_PreDelegates <NSObject>

- (void)addPrameterViewController:(AddTransaction_Pre *)controller didFinishEnteringItem:(NSString *)Pre_String;
@end
*/

@interface AddTransaction_Pre : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate, UIActionSheetDelegate>

@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(strong,nonatomic)PFObject *parameterAdd_PrePF;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic)UITextField *activeField;

@end
