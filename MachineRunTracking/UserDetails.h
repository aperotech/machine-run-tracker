//
//  UserDetails.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@interface UserDetails : ViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) PFObject *UpdateObjPF;
@property (weak, nonatomic) IBOutlet UITextField *userNameUpdateText;
@property (weak, nonatomic) IBOutlet UITextField *userTypeUpdateText;
@property (weak, nonatomic) IBOutlet UITextField *userEmailUpdateText;
@property (weak, nonatomic) IBOutlet UITextField *OldPassText;
@property (weak, nonatomic) IBOutlet UITextField *NewPassText;
@property (weak, nonatomic) IBOutlet UITextField *ReTypePassText;
@property (weak, nonatomic) IBOutlet UIButton *UpdateButton;

-(IBAction)UpdateButton:(id)sender;
@end
