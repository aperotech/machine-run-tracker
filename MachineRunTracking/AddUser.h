//
//  AddUser.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ViewController.h"

@interface AddUser : ViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIBarPositioningDelegate>

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UITextField *userNameText;
@property (weak,nonatomic) IBOutlet UITextField *userTypeText;
@property (strong,nonatomic) IBOutlet UITextField *passwordText;
@property (strong,nonatomic) IBOutlet UITextField *userEmailText;
@property (strong,nonatomic)UITextField *activeField;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;



@end
