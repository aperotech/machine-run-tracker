//
//  AddNewMachine.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 10/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewMachine : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, UIBarPositioningDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField * activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *trackingFrequencyText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *capacityText;
@property (weak, nonatomic) IBOutlet UITextField *maintanceFrequencyText;
@property (weak, nonatomic) IBOutlet UITextField *lastMaintanceDate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
