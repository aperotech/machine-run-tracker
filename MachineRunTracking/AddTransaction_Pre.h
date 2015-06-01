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
#import "AddTransaction_Run.h"



@protocol AddTransaction_PreDelegate <NSObject>
-(void) AddTransaction_PreVCDismissed:(BOOL)previousState;
@end



@interface AddTransaction_Pre : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,AddTransaction_RunDelegate>
{
    __weak id  AddPre_Delegate;

}
@property (nonatomic, weak) id<AddTransaction_PreDelegate> AddPre_Delegate;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(strong,nonatomic)PFObject *parameterAdd_PrePF;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic)UITextField *activeField;
@property (nonatomic)BOOL basicUpdateReturn;

@end
