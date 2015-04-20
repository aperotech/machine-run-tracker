//
//  AddTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Run : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)addORDeleteRows;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;

@property (weak, nonatomic) IBOutlet UIButton *SaveAndForward;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@end
