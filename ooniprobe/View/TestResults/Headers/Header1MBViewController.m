#import "Header1MBViewController.h"

@interface Header1MBViewController ()

@end

@implementation Header1MBViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];

    NSMutableAttributedString *middleBoxes = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"middle_boxes", nil)];
    [middleBoxes addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                    range:NSMakeRange(0, middleBoxes.length)];
    
    //TODO
    NSString *found = NSLocalizedString(@"not_found", nil);
    if (true)
        found = NSLocalizedString(@"found", nil);
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
