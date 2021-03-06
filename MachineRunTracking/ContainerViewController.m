//
//  ContainerViewController.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 27/04/15.
//  Copyright (c) 2015 Apero Technologies. All rights reserved.
//

#import "ContainerViewController.h"
#import "DetailsTransaction_Pre.h"
#import "DetailsTransaction_Run.h"
#import "DetailsTransaction_Post.h"
//#define SegueIdentifierToDetailsPre_Extraction @"SegmentControlToDetailsPreExtractionSegue"
//#define SegueIdentifierToDetailsRun_Process @"SegmentControlToDetailsRunProcessSegue"
//#define SegueIdentifierToDetailsPost_Extraction @"SegmentControlToDetailsPostExtractionSegue"


@interface ContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;


@end

@implementation ContainerViewController
@synthesize ContainerControlPF;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Check to see if the childViewControllers are empty
    // If so, create the initial addSubview
    
    if( self.childViewControllers.count <= 0 ){
        
       
        DetailsTransaction_Pre *DetialsTransactionPreObj=(DetailsTransaction_Pre *)segue.destinationViewController;
        [self addChildViewController:DetialsTransactionPreObj];
        DetialsTransactionPreObj.preTransobject = ContainerControlPF;
        ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
        [segue.destinationViewController didMoveToParentViewController:self];
        
    } else {
        
        
        // Currently, these if/else checks aren't doing anything special, but if you needed to do any further setup,
        // This would be the place to do it:
        
        if([segue.identifier isEqualToString:@"ContainerToDetailsPreExtractionSegue"]){
            DetailsTransaction_Pre *DetialsTransactionPreObj=(DetailsTransaction_Pre *)segue.destinationViewController;
        DetialsTransactionPreObj.preTransobject = ContainerControlPF;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:[segue destinationViewController]];
            
        } else if ([segue.identifier isEqualToString:@"ContainerToDetailsRunProcessSegue"]){
            DetailsTransaction_Run *DetailsTransactionRunObj=(DetailsTransaction_Run *)segue.destinationViewController;
            DetailsTransactionRunObj.DetialsTransaction_RunPF=ContainerControlPF;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:[segue destinationViewController]];
            [[segue destinationViewController] willMoveToParentViewController:self];
            
           /* [self transitionFromViewController:[self.childViewControllers objectAtIndex:0]
                              toViewController:[segue destinationViewController]
                                      duration:0.0
                                       options:UIViewAnimationOptionTransitionNone
                                    animations:nil
                                    completion:^(BOOL finished){
                                        [[segue destinationViewController] didMoveToParentViewController:self];
                                    }];*/
            
            
        } else if ([segue.identifier isEqualToString:@"ContainerToDetailsPostExtractionSegue"]){
            DetailsTransaction_Post *DetailsTransactionPostObj=(DetailsTransaction_Post *)segue.destinationViewController;
            DetailsTransactionPostObj.DetialsTransaction_PostPF=ContainerControlPF;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:[segue destinationViewController]];
            
        }
        
    }

    
}


- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    
    toViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.4 options:UIViewAnimationOptionBeginFromCurrentState animations:nil completion:^(BOOL finished) {
        // done with animation
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    }];
    
}


-(void)setPre_ExtractionActive
{
    [self performSegueWithIdentifier:@"ContainerToDetailsPreExtractionSegue" sender:nil];
   
}


-(void)setRun_ProcessActive
{
    [self performSegueWithIdentifier:@"ContainerToDetailsRunProcessSegue" sender:nil];
   //[self shouldAutorotate];
  // [self supportedInterfaceOrientations];
    
}

-(void)setPost_ExtractionActive
{
    [self performSegueWithIdentifier:@"ContainerToDetailsPostExtractionSegue" sender:nil];
}


/*-(BOOL)shouldAutorotate {
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}*/

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
