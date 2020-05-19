#import "MiddleBoxesDetailsViewController.h"

@interface MiddleBoxesDetailsViewController ()

@end

@implementation MiddleBoxesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.statusImage setImage:[UIImage imageNamed:@"middle_boxes"]];
    
    [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                    color:[TestUtility getColorForTest:self.result.test_group_name]];
    [self.headerView setBackgroundColor:[TestUtility getColorForTest:self.result.test_group_name]];
    
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
@end
