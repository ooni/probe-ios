//
//  BrowserViewController.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 23/06/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController
@synthesize urlList;
- (void)viewDidLoad
{
    [super viewDidLoad];
    urlIndex = 0;
    [self loadPage];
    if ([urlList count] == 1)
        [self.openMirrorButton setEnabled:NO];
    [self.openMirrorButton setTitle:NSLocalizedString(@"try_mirror", nil)];
}

-(void)loadPage{
    NSString *url = [urlList objectAtIndex:urlIndex];
    self.title = NSLocalizedString(@"loading", nil);
    NSURL *websiteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateButtons];
    NSString *url = [urlList objectAtIndex:urlIndex];
    NSString *http = [url substringWithRange:NSMakeRange(0, 5)];
    NSString *websiteUrl;
    if ([http isEqualToString:@"https"])
        websiteUrl = [NSString stringWithFormat:@"🔒 %@", url];
    else
        websiteUrl = [NSString stringWithFormat:@"%@", url];
    self.title = websiteUrl;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [self updateButtons];
    lastError = error;
    [self nextUrl:FALSE];
    NSLog(@"didFailLoadWithError %@", [error localizedDescription]);
}

-(IBAction)previous:(id)sender{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
        [self updateButtons];
    }
}

-(IBAction)next:(id)sender{
    if ([self.webView canGoForward])
    {
        [self.webView goForward];
        [self updateButtons];
    }
}

-(void)updateButtons{
    if ([self.webView canGoBack])
        [self.backButton setEnabled:YES];
    else
        [self.backButton setEnabled:NO];

    if ([self.webView canGoForward])
        [self.nextButton setEnabled:YES];
    else
        [self.nextButton setEnabled:NO];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)not_see:(id)sender {
    [self nextUrl:TRUE];
}

-(void)nextUrl:(BOOL)cycle {
    if (urlIndex+1 < [urlList count]){
        urlIndex++;
        [self loadPage];
    }
    else if (cycle) {
        urlIndex = 0;
        [self loadPage];
    }
    else {
        [self.webView loadHTMLString:[lastError localizedDescription] baseURL:nil];
    }
}

-(IBAction)share:(id)sender{
    NSString *url = [urlList objectAtIndex:urlIndex];
    NSArray *activityItems = @[[NSURL URLWithString:url]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] )
    {
        activityViewController.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activityViewController animated:YES completion:^{}];

}

@end
