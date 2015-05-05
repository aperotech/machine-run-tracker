//
//  AddTransaction_Basic.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddTransaction_Basic : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UIActivityItemSource>

@property(strong,nonatomic)PFObject *BasicTransactionPF;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityView;
@property(strong,nonatomic)IBOutlet UITextField *Run_NoText;
@property(strong,nonatomic)IBOutlet UITextField *Machine_NameText;
@property(strong,nonatomic)IBOutlet UITextField *Run_DateText;
@property (strong,nonatomic)IBOutlet UITextField *Run_DurationText;
-(IBAction)SaveAndForword:(id)sender;
-(IBAction)Cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField * activeField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)NSArray *placeholderArray;

//- (IBAction)dismissKeyboard:(id)sender;
@end
