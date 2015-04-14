//
//  AddTransaction_Basic.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AddTransaction_Basic : UIViewController<UITextFieldDelegate>
@property(strong,nonatomic)PFObject *BasicTransactionPF;

@property(strong,nonatomic)IBOutlet UITextField *Run_NoText;
@property(strong,nonatomic)IBOutlet UITextField *Machine_NameText;
@property(strong,nonatomic)IBOutlet UITextField *Run_DateText;
@property (strong,nonatomic)IBOutlet UITextField *Run_DurationText;
-(IBAction)SaveAndForword:(id)sender;
-(IBAction)Cancel:(id)sender;
@end
