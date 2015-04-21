//
//  AddTransaction_Run.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Run : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate >


@property (nonatomic, strong) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *PostExtractionArray;

- (void)addORDeleteRows;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property (weak,nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *SaveAndForward;
@property(nonatomic,strong)NSString *Parameter0;
@property(nonatomic,strong)NSString *Parameter1;
@property(nonatomic,strong)NSString *Parameter2;
@end
