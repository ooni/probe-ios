#import "AboutViewController.h"
#import <measurement_kit/common.hpp>

@interface AboutViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    self.revealViewController.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] isEqualToString:@"ar"]){
        [self.revealViewController setRightViewRevealWidth:260.0f];
        self.revealViewController.rightPresentViewHierarchically = YES;
        [self.revealButtonItem setAction: @selector(revealRightView)];
    }
    else {
        [self.revealButtonItem setAction: @selector(revealLeftView)];
        self.revealViewController.leftPresentViewHierarchically = YES;
    }
    self.revealViewController.toggleAnimationType = PBRevealToggleAnimationTypeSpring;
    self.view.backgroundColor = color_off_black;

    [self.titleLabel setText:NSLocalizedString(@"about_ooni", nil)];
    [self.learnMoreButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
    [self.textLabel setText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"about_text_1", nil),  NSLocalizedString(@"about_text_2", nil)]];
    [self.ppButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"view_data_policy", nil)] forState:UIControlStateNormal];
    [self.versionLabel setText:[NSString stringWithFormat:@"ooniprobe: %@\nmeasurement-kit: %s", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], mk_version()]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDot) name:@"reloadTable" object:nil];
    [self reloadDot];
}

- (void)reloadDot{
    if ([TestStorage new_tests]){
        self.navigationItem.leftBarButtonItem.badgeValue = @" ";
        self.navigationItem.leftBarButtonItem.badgeBGColor = color_ok_green;
    }
}


-(IBAction)learn_more:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/"]];
}


-(IBAction)privacy_policy:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/about/data-policy/"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
