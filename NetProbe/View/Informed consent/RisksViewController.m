//
//  RisksViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "RisksViewController.h"

@interface RisksViewController ()

@end

@implementation RisksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    self.title = NSLocalizedString(@"risks", nil);
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *risks_text = [[NSAttributedString alloc] initWithData:[NSLocalizedString(@"risks_text", nil) dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        self.textView.attributedText = risks_text;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textView.scrollEnabled = YES;
}

-(void)next{
    [self performSegueWithIdentifier:@"toQuiz" sender:self];
}

@end
