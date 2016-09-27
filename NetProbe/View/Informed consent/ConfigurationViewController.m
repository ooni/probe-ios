//
//  ConfigurationViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:60.0/255.0 green:118.0/255.0 blue:61.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:240.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"correct", nil) duration:3.0 position:CSToastPositionBottom style:style];
    
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIBarButtonItem *configure = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"configure", nil) style:UIBarButtonItemStylePlain target:self action:@selector(configure)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:configure, nil];

    settingsTitles = @[@"Should we include your IP address in results?", @"Should we include your network information in the reports (note: disabling this will make it much harder for us to draw conclusions from the measurements)?", @"Should we include your country name in the reports (note: disabling this will make it much harder for us to draw conclusions from the measurements)?", @"Should we upload your results to the default ooni collector?"];
    settingsItems = @[@"include_ip", @"include_asn", @"include_country", @"upload_collector"];
    settingsValues = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithBool:FALSE], [NSNumber numberWithBool:TRUE], [NSNumber numberWithBool:TRUE], [NSNumber numberWithBool:TRUE]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingsTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UIImageView *image = (UIImageView*)[cell viewWithTag:2];
    title.text = [settingsTitles objectAtIndex:indexPath.row];
    if ([[settingsValues objectAtIndex:indexPath.row] boolValue])
        image.image = [UIImage imageNamed:@"selected"];
    else
        image.image = [UIImage imageNamed:@"not-selected"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self switchRow:indexPath.row];
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) switchRow:(long)idx{
    if ([[settingsValues objectAtIndex:idx] boolValue])
        [settingsValues setObject:[NSNumber numberWithBool:FALSE] atIndexedSubscript:idx];
    else
        [settingsValues setObject:[NSNumber numberWithBool:TRUE] atIndexedSubscript:idx];
}

-(void)configure{
    //save prefs
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showToast" object:nil];
    }];
}

@end
