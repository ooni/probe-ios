//
//  UIWebView+Markdown.m
//
//  Created by Daniel Hough on 26/03/2013.
//  Copyright (c) 2013 Huddle. All rights reserved.
//

#import "UIWebView+Markdown.h"
#import <sundown/SundownWrapper.h>

@implementation UIWebView (Markdown)

- (void)loadMarkdownString:(NSString *)markdown {
    [self loadMarkdownString:markdown atBaseURL:nil withStylesheet:nil];
}

- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL {
    [self loadMarkdownString:markdown atBaseURL:baseURL withStylesheet:nil];
}

- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheet:(NSString *)stylesheet {
    if (!baseURL) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        baseURL = [NSURL fileURLWithPath:path];
    }
    
    NSString *htmlString = [SundownWrapper convertMarkdownString:markdown];
    
    NSString *fullHtmlPage;
    
    if (stylesheet) {
        fullHtmlPage = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\"><style type=\"text/css\">%@</style></head><body>%@</body></html>", stylesheet, htmlString];
    } else {
        fullHtmlPage = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\"><style type=\"text/css\">body { font-family:sans-serif; font-size:10pt; }</style></head><body>%@</body></html>", htmlString];
    }
    
    [self loadHTMLString:fullHtmlPage baseURL:baseURL];
}

- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheetFile:(NSString *)stylesheetFilename {
    if (!baseURL) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        baseURL = [NSURL fileURLWithPath:path];
    }
    
    NSString *htmlString = [SundownWrapper convertMarkdownString:markdown];
    
    NSString *fullHtmlPage = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\"><link rel=\"stylesheet\" href=\"%@\" /></head><body>%@</body></html>", stylesheetFilename, htmlString];
    
    [self loadHTMLString:fullHtmlPage baseURL:baseURL];
}

- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheetFile:(NSString *)stylesheetFilename andSurroundedByHTML:(NSString *)html {
    if (!baseURL) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        baseURL = [NSURL fileURLWithPath:path];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"{markdown}" withString:@"%@"];
    html = [html stringByReplacingOccurrencesOfString:@"{stylesheetName}" withString:@"%@"];
    
    NSString *htmlString = [SundownWrapper convertMarkdownString:markdown];
    
    NSString *fullHtmlPage = [NSString stringWithFormat:html, stylesheetFilename, htmlString];
    
    [self loadHTMLString:fullHtmlPage baseURL:baseURL];
}

@end
