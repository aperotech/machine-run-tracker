//
//  AddTransaction_Post.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 13/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTransaction_Post : UIViewController<UITextFieldDelegate>
{
    BOOL Pre_ExtractionPostFlag;
    BOOL Post_ExtractionFlag;
}
@property (weak,nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSArray *ViewControllers;
@property(nonatomic)NSInteger ObjectCount;
@property (strong,nonatomic) IBOutlet UILabel *Post_ExtractionLabel;


@end
