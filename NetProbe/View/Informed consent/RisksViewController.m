//
//  RisksViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "RisksViewController.h"

@interface RisksViewController ()

@end

@implementation RisksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    //self.title = NSLocalizedString(@"", nil);
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textView.scrollEnabled = YES;
}

-(void)next{
    [self performSegueWithIdentifier:@"toQuiz" sender:self];
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
