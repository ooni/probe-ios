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
    self.title = NSLocalizedString(@"risks", nil);
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast) name:@"showToastWrong" object:nil];

/*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *risks_text = [[NSAttributedString alloc] initWithData:[NSLocalizedString(@"risks_text", nil) dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        self.textView.attributedText = risks_text;
    });
 */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)showToast{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:169.0/255.0 green:68.0/255.0 blue:66.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"wrong", nil) duration:3.0 position:CSToastPositionBottom style:style];
}


-(void)next{
    [self performSegueWithIdentifier:@"toQuiz" sender:self];
}

@end
