//
//  MainMenu.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 07/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MainMenu : UIViewController
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UserButton;
@property (weak, nonatomic) IBOutlet UIButton *MachineButton;
@property (weak, nonatomic) IBOutlet UIButton *TransactionsButton;
@property (weak, nonatomic) IBOutlet UIButton *ParametersButton;
@property BOOL *PermissionFlag;
@property (nonatomic, strong) PFObject *MainMenuObjPF;
@property (nonatomic, strong) PFUser * CurrentUser;
-(IBAction)UserButtonClick:(id)sender;
@end
