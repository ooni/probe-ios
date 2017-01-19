//
//  AboutViewController.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 19/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.titleLabel setText:NSLocalizedString(@"about_ooni", nil)];
    [self.learnMoreButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
    [self.textLabel setText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"about_text_1", nil),  NSLocalizedString(@"about_text_2", nil)]];
}

-(IBAction)learn_more:(id)sender{
    //or https://explorer.ooni.torproject.org/world/
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
