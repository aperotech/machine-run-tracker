//
//  addNewParameter.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addNewParameter : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIBarPositioningDelegate,UIActivityItemSource>

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *typeText;
@property (weak, nonatomic) IBOutlet UITextField *unitsText;
@property (strong,nonatomic) UITextField *activeField;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic,weak) NSArray *myArray;

@end
