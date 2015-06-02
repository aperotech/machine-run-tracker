//
//  AddTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AddTransaction_RunDelegate <NSObject>
-(void) AddTransaction_RunVCDismissed:(BOOL)previousState;
@end


@interface AddTransaction_Run : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate ,UITextFieldDelegate, UIBarPositioningDelegate, UIActionSheetDelegate>
{
    __weak id  AddRun_Delegate;
    
}
@property (nonatomic, weak) id<AddTransaction_RunDelegate> AddRun_Delegate;
@property (nonatomic)BOOL PreUpdateReturn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UITableView *aTableView;

@property (weak, nonatomic) IBOutlet UIButton *SaveAndForward;
@property (strong, nonatomic) IBOutlet UITextField * activeField;
@property(strong,nonatomic)PFObject *parameterAdd_RunPF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableWidth;

@end
