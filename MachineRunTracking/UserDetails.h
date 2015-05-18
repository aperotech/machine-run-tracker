//
//  UserDetails.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserList.h"
#import <Parse/Parse.h>

@interface UserDetails : UIViewController <UITextFieldDelegate,UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTypeField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *updatePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *updateRePasswordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;

@property (nonatomic, strong) PFObject *userObject;

-(IBAction)UpdateButton:(id)sender;

@end
