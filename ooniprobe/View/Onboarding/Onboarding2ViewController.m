#import "Onboarding2ViewController.h"

@interface Onboarding2ViewController ()

@end

@implementation Onboarding2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];

    //Constraint for iPhoneSE
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 568)
        {
            self.topConstraint.constant = 8.0f;
        }
    }
    
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"what_is_ooniprobe", nil)];
    
    NSMutableAttributedString *whatIsOoniprobe1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"what_is_ooniprobe_1", nil)];
    [whatIsOoniprobe1 addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                    range:NSMakeRange(0, whatIsOoniprobe1.length)];
    
    NSMutableAttributedString *whatIsOoniprobe2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"what_is_ooniprobe_2", nil)]];
    [whatIsOoniprobe2 addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                    range:NSMakeRange(0, whatIsOoniprobe2.length)];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:whatIsOoniprobe1];
    [attrStr appendAttributedString:whatIsOoniprobe2];
    [self.textLabel setAttributedText:attrStr];
    [self.textLabel setTextColor:[UIColor whiteColor]];
}

@end
