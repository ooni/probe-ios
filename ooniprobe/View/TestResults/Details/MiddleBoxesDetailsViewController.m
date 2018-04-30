#import "MiddleBoxesDetailsViewController.h"

@interface MiddleBoxesDetailsViewController ()

@end

@implementation MiddleBoxesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point_orange"]];
    [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Hero.Title", nil)];
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
