#import "InstantMessagingDetailsViewController.h"

@interface InstantMessagingDetailsViewController ()

@end

@implementation InstantMessagingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (super.measurement.blocking == MEASUREMENT_OK){
        [self.statusImage setImage:[UIImage imageNamed:@"tick_green"]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.Reachable.Hero.Title", nil)];
    }
    else if (super.measurement.blocking == MEASUREMENT_BLOCKED){
        [self.statusImage setImage:[UIImage imageNamed:@"x_red"]];
        [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.Hero.Title", nil)];
    }
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
