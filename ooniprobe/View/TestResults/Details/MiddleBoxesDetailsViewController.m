#import "MiddleBoxesDetailsViewController.h"

@interface MiddleBoxesDetailsViewController ()

@end

@implementation MiddleBoxesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point_orange"]];
    [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Hero.Title", nil)];
    [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Content.Paragraph", nil)];
    */
    self.titleLabel.imageView.image = [UIImage imageNamed:@"exclamation_point_orange"];
    self.titleLabel.textLabel.text = NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Content.Paragraph", nil);
    self.titleLabel.textLabel.textColor = [UIColor blackColor];
    self.titleLabel.textLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.space = 0;
    self.titleLabel.textLabel.numberOfLines = 0;


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
