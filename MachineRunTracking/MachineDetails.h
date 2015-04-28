//
//  MachineDetails.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MachineDetails : UIViewController <UITextFieldDelegate,UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(strong,nonatomic)PFObject *MachineDetailsPF;

@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *trackingFrequencyText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *capacityText;
@property (weak, nonatomic) IBOutlet UITextField *maintanceFrequencyText;
@property (weak, nonatomic) IBOutlet UITextField *lastMaintanceDate;
@property (strong,nonatomic) UITextField *activeField;

@end
