// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "IntroductionViewController.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"introduction", nil);
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    
    [self.greetingsLabel setText:NSLocalizedString(@"greetings", nil)];
    [self.textView setText:[NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@", NSLocalizedString(@"intro_text_1", nil) , NSLocalizedString(@"intro_text_2", nil) , NSLocalizedString(@"intro_text_3", nil) , NSLocalizedString(@"intro_text_4", nil)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)next{
    [self performSegueWithIdentifier:@"toRisks" sender:self];
}


@end
