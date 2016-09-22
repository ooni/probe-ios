//
//  QuizViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    headers = @[@"In regards to how detectable ooniprobe is, which of the following statements is true?", @"In regards to the publication of measurements, which of the following statements is true?"];
    firstQuestion = @[@"Anyone monitoring my internet activity (e.g. ISP, government or employer) might be able to see that I am running ooniprobe, even though OONI takes precautions to make this hard", @"Anyone monitoring my internet activity (e.g. ISP, government or employer) will not be able to see that I am running ooniprobe", @"ooniprobe is designed to protect my privacy and therefore my use of ooniprobe cannot be detected"];
    secondQuestion = @[@"My measurements will not by default get published on OONI Explorer", @"My measurements will by default get published on OONI Explorer and might include personally-identifiable information.",  @"My measurements will by default get published to OONI Explorer and will never include any personally-identifiable information"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        if(indexPath.section == 0) cell.textLabel.text = [headers objectAtIndex:indexPath.section];
        else if(indexPath.section == 1) cell.textLabel.text = [headers objectAtIndex:indexPath.section];
        cell.imageView.image = nil;
    }
    else {
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.imageView.image = [UIImage imageNamed:@"not-selected"];
        if(indexPath.section == 0) {
            cell.textLabel.text = [firstQuestion objectAtIndex:indexPath.row-1];
            if (indexPath.row == firstAnswer) cell.imageView.image = [UIImage imageNamed:@"selected"];
        }
        else if(indexPath.section == 1) {
            cell.textLabel.text = [secondQuestion objectAtIndex:indexPath.row-1];
            if (indexPath.row == secondAnswer) cell.imageView.image = [UIImage imageNamed:@"selected"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section %ld row %ld", (long)indexPath.section, (long)indexPath.row);
    if (indexPath.row != 0){
        if(indexPath.section == 0) firstAnswer = indexPath.row;
        else if(indexPath.section == 1) secondAnswer = indexPath.row;
        [self.tableView reloadData];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
