//
//  SegmentedLocationVC.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 15/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "SegmentedLocationVC.h"
#import "ContainerViewController.h"
#import "AddTransaction_Pre.h"
#import "AddTransaction_Post.h"
#import "AddTransaction_Run.h"
@interface SegmentedLocationVC ()

@property (nonatomic, weak) ContainerViewController *containerViewController;

@property(nonatomic,strong)AddTransaction_Pre *AddTransaction_Pre;
@property (nonatomic,strong)AddTransaction_Run *AddTransaction_Run;
@property (nonatomic,strong)AddTransaction_Post *AddTransaction_Post;

@end

@implementation SegmentedLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     // [self setupUI];
    
    self.AddTransaction_Pre = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Pre_ID"];
    
    // Create the penalty view controller
    self.AddTransaction_Run = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Run_ID"];
    self.AddTransaction_Post = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTransaction_Post_ID"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:self.AddTransaction_Pre,self.AddTransaction_Run,self.AddTransaction_Post , nil];
    
    // Ensure a view controller is loaded
    //self.switchViewControllers.selectedSegmentIndex = 0;
    
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.segmentedControl.selectedSegmentIndex]];
    

    
    
    
}
#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
        //  newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        newVC.view.frame =  CGRectMake(0, 113, 600, 487);
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            // Add the new view controller view to the ciew hierarchy
            [self.view addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
        NSLog(@"The Current VC IS %@ incomimng VC %@",self.currentViewController,incomingViewController);
        if ([incomingViewController isEqual:self.AddTransaction_Pre]) {
            self.navigationItem.title=@"Pre-Extraction";
            self.navigationItem.rightBarButtonItem.enabled =FALSE;
        }else if ([incomingViewController isEqual:self.AddTransaction_Run]){
        self.navigationItem.title=@"Run-Process";
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
        }else if ([incomingViewController isEqual:self.AddTransaction_Post]){
        self.navigationItem.title=@"Post-Extraction";
            self.navigationItem.rightBarButtonItem=[ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
        }
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
