//
//  IntroductionViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"introduction", nil);
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *intro_text = [[NSAttributedString alloc] initWithData:[NSLocalizedString(@"intro_text", nil) dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        self.textView.attributedText = intro_text;
    });
     */
    /*
    NSAttributedString *intro_text = [[NSAttributedString alloc] initWithData:[NSLocalizedString(@"intro_text", nil) dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
    self.textView.attributedText = intro_text;
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSData *htmlData = [self.textView.attributedText dataFromRange:NSMakeRange(0, self.textView.attributedText.length) documentAttributes:documentAttributes error:NULL];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", htmlString);
     */
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.scrollEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)next{
    [self performSegueWithIdentifier:@"toRisks" sender:self];
}

@end
