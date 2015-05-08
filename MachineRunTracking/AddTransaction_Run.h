//
//  AddTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AddTransaction_Run : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate ,UITextFieldDelegate, UIBarPositioningDelegate,UIActivityItemSource>

@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(strong,nonatomic)PFObject *parameterAdd_RunPF;
@property (nonatomic, strong) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *RunProcessArray;

@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property (weak,nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *SaveAndForward;
@property (strong, nonatomic) IBOutlet UITextField * activeField;
@property (strong, nonatomic) IBOutlet UITextField * valueTextField;
@property (nonatomic) int sectionCount;
@property (nonatomic) NSInteger rowIndexCount;

@property(nonatomic,strong)NSString *Interval;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@property(nonatomic,strong)NSString *Parameter3;
@property(nonatomic,strong)NSString *Parameter4;
@property(nonatomic,strong)NSString *Value;
@property(nonatomic,strong)NSString *LastInsertedTransactionNo;

@property(nonatomic,strong)NSArray *runPalceholderArray;
@property(nonatomic,strong)NSMutableArray *GetValuesFromRunTextFieldArray;
@property(nonatomic,strong)NSMutableArray *NewValuesArray;
@property(nonatomic,strong)NSMutableArray *FinalValuesArray;

//- (void)addORDeleteRows;

@end
