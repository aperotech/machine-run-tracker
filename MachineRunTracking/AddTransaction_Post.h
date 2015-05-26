//
//  AddTransaction_Post.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddTransaction_Post : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)PFObject *parameterAdd_PostPF;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
-(IBAction)SaveAndExit:(id)sender;

@property (strong,nonatomic)UITextField *activeField;
@end
