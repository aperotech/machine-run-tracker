//
//  AddTransaction_Pre.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentedLocationVC.h"
#import <Parse/Parse.h>
/*@class AddTransaction_Pre;
@protocol AddTransaction_PreDelegates <NSObject>

- (void)addPrameterViewController:(AddTransaction_Pre *)controller didFinishEnteringItem:(NSString *)Pre_String;
@end
*/



@interface AddTransaction_Pre : UIViewController<UITextFieldDelegate>
{
    BOOL Pre_extractionFlag;
}
@property(strong,nonatomic)PFObject *parameterAdd_PrePF;
//@property (nonatomic, weak) id <AddTransaction_PreDelegates> delegate;
//@property (weak,nonatomic) SegmentedLocationVC *SegmentedLocationVCObj;
@property (weak, nonatomic) IBOutlet UIButton *Add;
@property (strong,nonatomic) NSMutableArray *pre_extractionArray;
@property(nonatomic)NSInteger ObjectCount;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@end
