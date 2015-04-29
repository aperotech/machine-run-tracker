//
//  ContainerViewController.h
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ContainerViewController : UIViewController
-(void)setPre_ExtractionActive;
-(void)setRun_ProcessActive;
-(void)setPost_ExtractionActive;
@property(strong,nonatomic)PFObject *ContainerControlPF;
@end
