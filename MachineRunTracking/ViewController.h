//
//  ViewController.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property(nonatomic,strong)IBOutlet UITextField *userEmailText;
@property(nonatomic,strong)IBOutlet UITextField *passwordText;
@property(nonatomic,strong)IBOutlet UIButton *loginButton;
-(IBAction)Login:(id)sender;
@end

