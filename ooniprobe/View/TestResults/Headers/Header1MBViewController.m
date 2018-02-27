#import "Header1MBViewController.h"

@interface Header1MBViewController ()

@end

@implementation Header1MBViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
    Summary *summary = [result getSummary];

    NSMutableAttributedString *middleBoxes = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"middle_boxes", nil)];
    [middleBoxes addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                    range:NSMakeRange(0, middleBoxes.length)];
    
    NSString *found;
    if (summary.failedMeasurements > 0)
        found = NSLocalizedString(@"found", nil);
    else if (summary.okMeasurements == summary.totalMeasurements)
        found = NSLocalizedString(@"not_found", nil);
    else
        //TODO string
        found = NSLocalizedString(@"failed", nil);
    NSMutableAttributedString *foundStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", found]];
    [foundStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                    range:NSMakeRange(0, foundStr.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:middleBoxes];
    [attrStr appendAttributedString:foundStr];
    [self.headerTitle setAttributedText:attrStr];
}

@end
