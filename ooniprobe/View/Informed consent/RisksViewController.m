#import "RisksViewController.h"

@interface RisksViewController ()

@end

@implementation RisksViewController

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
    

    [self.titleLabel setText:NSLocalizedString(@"what_is_ooniprobe", nil)];
    [self.nextButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
        
    NSMutableAttributedString *muAtrStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"risks_text_1", nil) attributes:@{NSForegroundColorAttributeName : color_ooni_blue}];
    NSAttributedString *atrStr2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", NSLocalizedString(@"risks_text_2", nil)] attributes:@{NSForegroundColorAttributeName : color_off_black}];
    NSAttributedString *atrStr3 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", NSLocalizedString(@"risks_text_3", nil)] attributes:@{NSForegroundColorAttributeName : color_off_black}];
    NSAttributedString *atrStr4 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", NSLocalizedString(@"risks_text_4", nil)] attributes:@{NSForegroundColorAttributeName : color_off_black}];
    NSAttributedString *atrStr5 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@", NSLocalizedString(@"risks_text_5", nil)] attributes:@{NSForegroundColorAttributeName : color_off_black}];

    [muAtrStr appendAttributedString:atrStr2];
    [muAtrStr appendAttributedString:atrStr3];
    [muAtrStr appendAttributedString:atrStr4];
    [muAtrStr appendAttributedString:atrStr5];

    [self.textLabel setAttributedText:muAtrStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)next{
    [self performSegueWithIdentifier:@"toLaws" sender:self];
}

-(void)previous{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
