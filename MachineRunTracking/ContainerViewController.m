//
//  ContainerViewController.m
//  MachineRunTracking
//
//  Created by Akshay Shrirao on 15/04/15.
//  Copyright (c) 2015 AperoTechnologies. All rights reserved.
//

#import "ContainerViewController.h"
#import "AddTransaction_Pre.h"
#import "AddTransaction_Run.h"
#import "AddTransaction_Post.h"
#define SegueIdentifierPre @"SegmentedControllToPreSegue"
#define SegueIdentifierRun @"SegementedControllToRunSegue"
#define SegueIdentifierPost @"SegementedControllToPostSegue"
@interface ContainerViewController ()
@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (assign, nonatomic) BOOL transitionInProgress;
@property(nonatomic,strong)AddTransaction_Pre *AddTransaction_Pre;
@property (nonatomic,strong)AddTransaction_Run *AddTransaction_Run;
@property (nonatomic,strong)AddTransaction_Post *AddTransaction_Post;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierPre;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierPre]) {
        self.AddTransaction_Pre = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierRun]) {
        self.AddTransaction_Run = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierPost]) {
        self.AddTransaction_Post = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierPre]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.AddTransaction_Pre];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierRun]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.AddTransaction_Run];
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierPost])
        {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:2] toViewController:self.AddTransaction_Post];
        }
    
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierPre]) ? SegueIdentifierRun : SegueIdentifierPost;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierPre]) && self.AddTransaction_Pre) {
        [self swapFromViewController:self.AddTransaction_Run toViewController:self.AddTransaction_Pre];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierRun]) && self.AddTransaction_Run) {
        [self swapFromViewController:self.AddTransaction_Pre toViewController:self.AddTransaction_Run];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierPost]) && self.AddTransaction_Post) {
        [self swapFromViewController:self.AddTransaction_Run toViewController:self.AddTransaction_Post];
        return;
    }
    

    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
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
