//
//  SegmentedControlVC.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import "SegmentedControlVC.h"
#import "DetailsTransaction_Pre.h"
#import "DetailsTransaction_Run.h"
#import "DetailsTransaction_Post.h"
#import "ContainerViewController.h"

@interface SegmentedControlVC ()
//@property(nonatomic,strong)DetailsTransaction_Pre *DetailsTransaction_Pre;
//@property (nonatomic,strong)DetailsTransaction_Run *DetailsTransaction_Run;
//@property (nonatomic,strong)DetailsTransaction_Post *DetailsTransaction_Post;
@end

@implementation SegmentedControlVC
@synthesize SegmentControlPF;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"Pre-extraction";
   // [self.containerView setPre_ExtractionActive];
   // self.containerView.ContainerControlPF=SegmentControlPF;
        // self.navigationController.navigationBar.topItem.title=@"";
    
  //  self.containerView =[[ContainerViewController alloc]init];
    // Do any additional setup after loading the view.
   /* NSLog(@"AddTransaction_Pre Loaded!");
    self.DetailsTransaction_Pre = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTransaction_Pre"];
    
    // Create the penalty view controller
    self.DetailsTransaction_Run = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTransaction_Run"];
    self.DetailsTransaction_Post = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTransaction_Post"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:self.DetailsTransaction_Pre,self.DetailsTransaction_Run,self.DetailsTransaction_Post , nil];
    
    // Ensure a view controller is loaded
    //self.switchViewControllers.selectedSegmentIndex = 0;
    
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.segmentedControl.selectedSegmentIndex]];
    
*/
    
}

/*#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
         //newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        newVC.view.frame =  CGRectMake(0, 119, 600, 481);
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
        
        if ([incomingViewController isEqual:self.DetailsTransaction_Pre]) {
           self.navigationItem.title=@"Pre-Extraction";
            
          //  self.navigationItem.rightBarButtonItem.enabled =FALSE;
           // [self ADDORUpdatePreTransaction];
            NSLog(@"********In Pre Segment View Controller********");
           // NSLog(@"The Strings Are Pre %@ --- %@ ---- %@",Parameter0,Parameter1,Parameter2);
        }else if ([incomingViewController isEqual:self.DetailsTransaction_Run]){
            self.navigationItem.title=@"Run-Process";
            NSLog(@"********In Run Segment View Controller********");
           // self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
         //   NSLog(@"The Strings Are Run %@ --- %@ ---- %@",Parameter0,Parameter1,Parameter2);
        }else if ([incomingViewController isEqual:self.DetailsTransaction_Post]){
            self.navigationItem.title=@"Post-Extraction";
            NSLog(@"********In Post Segment View Controller********");
           // self.navigationItem.rightBarButtonItem=[ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
           // NSLog(@"The Strings Are  Post %@ --- %@ ---- %@",Parameter0,Parameter1,Parameter2);
        }
    }
    
}*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}*/

- (IBAction)segmentControlChanged:(id)sender {
    
    
    switch (self.segmentedControl.selectedSegmentIndex ) {
        case 0:
            self.navigationItem.title=@"Pre-extraction";
            [self.containerView setPre_ExtractionActive];
            
            break;
        case 1:
            self.navigationItem.title=@"Process Run";
            
            [self.containerView setRun_ProcessActive];
            [self  supportedInterfaceOrientations];
            [self shouldAutorotate];
            break;
        case 2:
            self.navigationItem.title=@"Post-extraction";
            [self.containerView setPost_ExtractionActive];
            break;
        
        default:
            break;
    }
    
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 if ([segue.identifier isEqualToString:@"embedManageContainer"]){
 self.containerView = segue.destinationViewController;
   //  ContainerViewController *containerControlVCObj=(ContainerViewController *)segue.destinationViewController;
     self.containerView.ContainerControlPF=SegmentControlPF;
     
    // self.containerView.ContainerControlPF=SegmentControlPF;

 }
    
}


@end
