//
//  Oboarding3ViewController.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/12/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "Oboarding3ViewController.h"

@interface Oboarding3ViewController ()

@end

@implementation Oboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;

    [self.titleLabel setText:NSLocalizedString(@"things_to_know", nil)];
    
    NSMutableAttributedString *things_to_know_1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"• %@\n\n• %@\n\n• %@\n\n• %@", NSLocalizedString(@"things_to_know_1", nil), NSLocalizedString(@"things_to_know_2", nil), NSLocalizedString(@"things_to_know_3", nil), NSLocalizedString(@"things_to_know_4", nil)]];
    [things_to_know_1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, things_to_know_1.length)];
    
    [self.textLabel setAttributedText:things_to_know_1];
    [self.nextButton setTitle:NSLocalizedString(@"i_understand", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showQuiz:(id)sender{
    UIViewController *aViewController = [[UIViewController alloc] initWithNibName:@"Quiz" bundle:nil];
    quizView = aViewController.view;
    /*
    UIButton *ruoloButton = (UIButton*)[popupView viewWithTag:1];
    [ruoloButton addTarget:self action:@selector(scegliRuolo) forControlEvents:UIControlEventTouchUpInside];
    NSArray *ruoli = [[NSArray alloc] initWithObjects:@"Ruolo qualunque", @"Portiere", @"Difensore", @"Centrocampista", @"Attaccante", nil];
    [ruoloButton setTitle:[ruoli objectAtIndex:ruoloDaEstrarre] forState:UIControlStateNormal];
    
    UIButton *resetButton = (UIButton*)[popupView viewWithTag:2];
    [resetButton addTarget:self action:@selector(resetEstratti) forControlEvents:UIControlEventTouchUpInside];
    UIButton *estraiButton = (UIButton*)[popupView viewWithTag:3];
    [estraiButton addTarget:self action:@selector(estrai) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *estrattiLabel = (UILabel*)[popupView viewWithTag:4];
    NSArray * estratti = [CacheManager get_estratti_for_lega:idLegaCorrente];
    [estrattiLabel setText:[NSString stringWithFormat:@"Estratti (%d)", [estratti count]]];
     */
    PopupView* popup = [PopupView popupViewWithContentView:quizView];
    //[popup setDidFinishDismissingCompletion:^{}];
    [popup show];
}

@end
