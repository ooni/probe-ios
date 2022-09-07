//
//  CocoaLumberjackViewController.m
//  ooniprobe
//
//  Created by Norbel Ambanumben on 06/09/2022.
//  Copyright © 2022 OONI. All rights reserved.
//

#import "CocoaLumberjackViewController.h"
#import "UIForLumberjack.h"

@interface CocoaLumberjackViewController ()
@property (weak, nonatomic) IBOutlet UIView *logView;

@end

@implementation CocoaLumberjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIForLumberjack sharedInstance] showLogInView:_logView];
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
