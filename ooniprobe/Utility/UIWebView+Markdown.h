//
//  UIWebView+Markdown.h
//
//  Created by Daniel Hough on 26/03/2013.
//  Copyright (c) 2013 Huddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Markdown)

/**
 Simply loads a HTML-ified Markdown string and inserts it into the standard webview (except with a sans-serif font)
 */
- (void)loadMarkdownString:(NSString *)markdown;

/**
 Load it at a specific base URL, in case you want to put some custom images in or something like that!
 baseURL can be nil if you want, in which case the default bundle URL will be used
 */
- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL;
/**
 Load a Markdown string as HTML, and specify some CSS (such as body { ... }) to insert into the header. BaseURL options are the same.
 */
- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheet:(NSString *)stylesheet;
/**
 Load a Markdown string as HTML, and specify a CSS file to load through with the page.

 You can specify a custom URL For the stylesheet, but if you don't, the default will be used, as before.
 */
- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheetFile:(NSString *)stylesheetFilename;
/**
 Same as the one above, but need to provide an HTML string which has two placeholder tokens - one for the stylesheet, and one for the body content
 */
- (void)loadMarkdownString:(NSString *)markdown atBaseURL:(NSURL *)baseURL withStylesheetFile:(NSString *)stylesheetFilename andSurroundedByHTML:(NSString *)html;

@end
