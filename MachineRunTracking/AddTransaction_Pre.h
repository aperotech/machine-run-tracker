//
//  AddTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SegmentedLocationVC.h"
#import <Parse/Parse.h>
/*@class AddTransaction_Pre;
@protocol AddTransaction_PreDelegates <NSObject>

- (void)addPrameterViewController:(AddTransaction_Pre *)controller didFinishEnteringItem:(NSString *)Pre_String;
@end
*/



@interface AddTransaction_Pre : UIViewController<UITextFieldDelegate, UIBarPositioningDelegate,UIActivityItemSource>
{
    BOOL Pre_extractionFlag;
}


@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(strong,nonatomic)PFObject *parameterAdd_PrePF;
@property (weak,nonatomic) IBOutlet UITextField *ParameterText;
@property (weak, nonatomic) IBOutlet UIButton *SaveAndForward;

@property(strong,nonatomic) UIRefreshControl *refreshControl;

@property(nonatomic)NSInteger ObjectCount;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@property(nonatomic,strong)NSString *Parameter3;

@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)NSArray *preExtractionArray;
@property(nonatomic,strong)NSMutableArray *GetValuesFromTextFieldArray;
@property(nonatomic,strong)NSMutableArray *RunProcessArray;
@property(nonatomic,strong)NSString *LastInsertedTransactionNo;

@end
