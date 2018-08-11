#import "Header1MBViewController.h"

@interface Header1MBViewController ()

@end

@implementation Header1MBViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];

    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.name]];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurement];
}

-(void)reloadMeasurement{
    //TestKeys *testKeys = [self.measurement testKeysObj];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *middleBoxes = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Test.Middleboxes.Fullname", nil)];
        [middleBoxes addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                            range:NSMakeRange(0, middleBoxes.length)];
        
        NSString *found;
        /*TODO if (summary.anomalousMeasurements > 0)
            found = NSLocalizedString(@"TestResults.Summary.Middleboxes.Hero.Found", nil);
        else if (summary.okMeasurements == summary.totalMeasurements-summary.failedMeasurements)
            found = NSLocalizedString(@"TestResults.Summary.Middleboxes.Hero.NotFound", nil);
        else
            found = NSLocalizedString(@"TestResults.Summary.Middleboxes.Hero.Failed", nil);
        NSMutableAttributedString *foundStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", found]];
        [foundStr addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                         range:NSMakeRange(0, foundStr.length)];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
        [attrStr appendAttributedString:middleBoxes];
        [attrStr appendAttributedString:foundStr];
        [self.headerTitle setAttributedText:attrStr];
         */
    });    
}

@end
