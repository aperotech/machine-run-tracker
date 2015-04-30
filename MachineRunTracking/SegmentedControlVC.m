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
     self.navigationItem.title=@"Pre-Extraction";
    
    [self.containerView setPre_ExtractionActive];
    
  }


/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}*/

- (IBAction)segmentControlChanged:(id)sender {
    
    
    switch (self.segmentedControl.selectedSegmentIndex  ) {
        case 0:
            self.navigationItem.title=@"Pre-Extraction";
            [self.containerView setPre_ExtractionActive];
            
            break;
        case 1:
            self.navigationItem.title=@"Process Run";
            
            [self.containerView setRun_ProcessActive];
            
            
            
            
           // [self  supportedInterfaceOrientations];
            //[self shouldAutorotate];
            break;
        case 2:
            self.navigationItem.title=@"Post-Extraction";
            [self.containerView setPost_ExtractionActive];
            break;
        
        default:
            break;
    }
    
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}*/


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return NO;
}*/
/*- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    
}*/
-(void)viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
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
   
     self.containerView.ContainerControlPF=SegmentControlPF;
        

 }
    
}


@end
