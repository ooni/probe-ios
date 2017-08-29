//
//  RunTestTableViewController.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/08/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "RunTestViewController.h"

@interface RunTestViewController ()

@end

@implementation RunTestViewController
@synthesize testName, testArguments, testDecription;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTestUI) name:@"reloadTable" object:nil];

    currentTests = [Tests currentTests];
    [self.runButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"run", nil)] forState:UIControlStateNormal];

    if (testDecription != nil)
        [self.titleLabel setText:[NSString stringWithFormat:@"%@", testDecription]];
    else
        [self.titleLabel setText:NSLocalizedString(@"run_test_message", nil)];

    [self.test_detailsLabel setText:NSLocalizedString(@"test_details", nil)];
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    [self.test_titleLabel setText:NSLocalizedString(current.name, nil)];
    [self.test_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_big", current.name]]];
    
    urls = [testArguments objectForKey:@"urls"];
    if ([urls count] > 0){
        current.inputs = urls;
    }
    [self reloadTestUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadTestUI{
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    //basic case (not running e not started)
    if (!current.running && !started){
        [self.indicator setHidden:TRUE];
        [self.runButton setHidden:FALSE];
        [self.indicator stopAnimating];
    }
    //current test started
    else if (current.running && started){
        [self.indicator setHidden:FALSE];
        [self.runButton setHidden:TRUE];
        [self.indicator startAnimating];
    }
    //other test is running the UI waits
    else if (current.running && !started){
        [self.indicator setHidden:FALSE];
        [self.runButton setHidden:TRUE];
        [self.indicator startAnimating];
    }
    //case test was started and finishes !current.running && started
    else {
        [self dismissViewControllerAnimated:TRUE completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [urls count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([urls count] == 0)
        return nil;
    return NSLocalizedString(@"urls", nil);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *current = [urls objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"include_cc"];
    cell.textLabel.text = current;
    return cell;
}

-(IBAction)run:(id)sender {
    started = true;
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    [current run];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
}

@end
