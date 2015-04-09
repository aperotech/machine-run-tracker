//
//  AddUser.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ViewController.h"

@interface AddUser : ViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UITextField *userNameText;
@property (strong,nonatomic) IBOutlet UITextField *userTypeText;
@property (strong,nonatomic) IBOutlet UITextField *passwordText;
@property (strong,nonatomic) IBOutlet UITextField *userEmailText;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property(nonatomic,weak) NSArray *myArray;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerArray;
@end
