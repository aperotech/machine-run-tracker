//
//  AddUser.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "UserList.h"

@interface AddUser : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTypeField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *tempPasswordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic)UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;



@end
