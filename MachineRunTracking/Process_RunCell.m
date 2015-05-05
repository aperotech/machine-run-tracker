//
//  Process_RunCell.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 20/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "Process_RunCell.h"

@implementation Process_RunCell

@synthesize ParametersText,ValueText,IntervalText,Parameters1Text,Parameters2Text,Parameters3Text;
- (void)awakeFromNib {
    // Initialization code
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 44;
    //Change as per your table header hight
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
