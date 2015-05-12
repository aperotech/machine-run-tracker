//
//  parameterDetails.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface parameterDetails : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

- (IBAction)UpdateButton:(id)sender;

@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *typeText;
@property (weak, nonatomic) IBOutlet UITextField *unitsText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong,nonatomic)PFObject *parameterObject;

@end
