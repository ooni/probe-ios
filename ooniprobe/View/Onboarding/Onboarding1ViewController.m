#import "Onboarding1ViewController.h"

@interface Onboarding1ViewController ()

@end

@implementation Onboarding1ViewController

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

    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;
    
    [self.nextButton setTitle:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.GotIt", nil) forState:UIControlStateNormal];
     [self.nextButton setTitleColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]
                           forState:UIControlStateNormal];
     [self.nextButton setBackgroundColor:[UIColor whiteColor]];

    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Title", nil)];
    /*
    NSMutableAttributedString *whatIsOoniprobe1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Paragraph.1", nil)];
    [whatIsOoniprobe1 addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                    range:NSMakeRange(0, whatIsOoniprobe1.length)];
    
    NSMutableAttributedString *whatIsOoniprobe2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Paragraph.2", nil)]];
    [whatIsOoniprobe2 addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                    range:NSMakeRange(0, whatIsOoniprobe2.length)];
    
    NSMutableAttributedString *whatIsOoniprobe3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Paragraph.3", nil)]];
    [whatIsOoniprobe3 addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                             range:NSMakeRange(0, whatIsOoniprobe3.length)];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:whatIsOoniprobe1];
    [attrStr appendAttributedString:whatIsOoniprobe2];
    [attrStr appendAttributedString:whatIsOoniprobe3];
    [self.textLabel setAttributedText:attrStr];
    */
    [self.textLabel setText:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Paragraph", nil)];
    [self.textLabel setTextColor:[UIColor whiteColor]];
}


@end
