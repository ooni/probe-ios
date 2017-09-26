#import "LawsViewController.h"

@interface LawsViewController ()

@end

@implementation LawsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(next)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(previous)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    
    [self.titleLabel setText:NSLocalizedString(@"potential_risks", nil)];
    [self.nextButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"i_understand_the_risks", nil)] forState:UIControlStateNormal];
    [self.textLabel setText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",NSLocalizedString(@"laws_text_1", nil),  NSLocalizedString(@"laws_text_2", nil), NSLocalizedString(@"laws_text_3", nil), NSLocalizedString(@"laws_text_4", nil), NSLocalizedString(@"laws_text_5", nil), NSLocalizedString(@"laws_text_6", nil)]];
    [self.moreButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)next{
    [self performSegueWithIdentifier:@"toQuiz" sender:self];
}

-(void)previous{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)learn_more:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/about/risks/"]];
}


@end
