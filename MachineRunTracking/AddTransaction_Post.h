//
//  AddTransaction_Post.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AddTransaction_Post : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate>



@property(strong,nonatomic)PFObject *parameterAdd_PostPF;
@property(nonatomic)NSInteger ObjectCount;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@property(nonatomic,strong)NSString *Parameter3;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *LastInsertedTransactionNo;
@property(nonatomic,strong)NSString *LastInsertedTransactionNoObjectId;
-(IBAction)SaveAndExit:(id)sender;

@property(nonatomic,strong)NSArray *postExtractionArray;
@property(nonatomic,strong)NSMutableArray *GetValuesFromPostTextFieldArray;
@property(nonatomic,strong)NSMutableArray *RunProcessArray;
@end
