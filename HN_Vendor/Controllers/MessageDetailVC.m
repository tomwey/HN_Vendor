//
//  MessageDetailVC.m
//  HN_Vendor
//
//  Created by tomwey on 21/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "MessageDetailVC.h"
#import "Defines.h"

@interface MessageDetailVC () <UIWebViewDelegate>

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.backgroundColor = AWColorFromRGB(247, 247, 247);
    
    self.navBar.title = @"消息";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:webView];
    
    [webView removeGrayBackground];
    
    webView.delegate = self;
    
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg.tpl" ofType:nil]
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    
    NSString *content = [self.params[@"msgcontent"] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    html = [html stringByReplacingOccurrencesOfString:@"${title}" withString:self.params[@"msgtheme"]];
    html = [html stringByReplacingOccurrencesOfString:@"${content}" withString:content];
    
    [webView loadHTMLString:html baseURL:nil];
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [[request.URL absoluteString] hasPrefix:@"hn-msg://"] ) {
        NSLog(@"%d", navigationType);
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
}

@end
