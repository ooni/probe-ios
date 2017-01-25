// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    headers = @[@"question_1", @"question_2"];
    firstQuestion = @[@"true", @"false"];
    secondQuestion = @[@"true", @"false"];
    
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(next)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(previous)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    [self.titleLabel setText:NSLocalizedString(@"pop_quiz", nil)];
    [self.nextButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"how_did_i_do", nil)] forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"pop_quiz", nil);

    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Header" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString([headers objectAtIndex:indexPath.section], nil);
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        UIImageView *image = (UIImageView*)[cell viewWithTag:2];
        image.image = [UIImage imageNamed:@"radio_button_off"];
        if(indexPath.section == 0) {
            title.text = NSLocalizedString([firstQuestion objectAtIndex:indexPath.row-1], nil);
            if (indexPath.row == firstAnswer) image.image = [UIImage imageNamed:@"radio_button_on"];
        }
        else if(indexPath.section == 1) {
            title.text = NSLocalizedString([secondQuestion objectAtIndex:indexPath.row-1], nil);
            if (indexPath.row == secondAnswer) image.image = [UIImage imageNamed:@"radio_button_on"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0){
        if(indexPath.section == 0) firstAnswer = indexPath.row;
        else if(indexPath.section == 1) secondAnswer = indexPath.row;
        [self.tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)previous{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)next{
    if ([self checkAnswers]){
        [self performSegueWithIdentifier:@"toConfiguration" sender:self];
    }
    else {
        [self showToast];
    }
}

-(BOOL) checkAnswers{
    if (firstAnswer == 1 && secondAnswer == 1) return TRUE;
    return false;
}

-(void)showToast{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = color_off_white;
    style.backgroundColor = color_bad_red;
    style.titleFont = [UIFont fontWithName:@"FiraSansOT-Bold" size:15];
    [self.view makeToast:NSLocalizedString(@"wrong", nil) duration:3.0 position:CSToastPositionBottom style:style];
}

@end
