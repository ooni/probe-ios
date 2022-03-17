#import "MiddleBoxesDetailsViewController.h"
#import "RunningTest.h"

@interface MiddleBoxesDetailsViewController ()

@end

@implementation MiddleBoxesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.statusImage setImage:[UIImage imageNamed:@"middle_boxes"]];
    [self reloadConstraints];

    [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                    color:[TestUtility getBackgroundColorForTest:self.result.test_group_name]];
    [self.headerView setBackgroundColor:[TestUtility getBackgroundColorForTest:self.result.test_group_name]];
    
    if ([self.measurement.test_name isEqualToString:@"http_invalid_request_line"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.NotFound.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.NotFound.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.Found.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.Found.Content.Paragraph", nil)];
        }
    }
    else if ([self.measurement.test_name isEqualToString:@"http_header_field_manipulation"]){
        if (!super.measurement.is_anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.NotFound.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.NotFound.Content.Paragraph", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Hero.Title", nil)];
            [self.textLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Content.Paragraph", nil)];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadConstraints];
}

-(void)reloadConstraints{
    CGFloat uploadConstraint = 0;
    if ([RunningTest currentTest].isTestRunning){
        uploadConstraint += 64;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.uploadBarFooterConstraint.constant = uploadConstraint;
    });
}
@end
