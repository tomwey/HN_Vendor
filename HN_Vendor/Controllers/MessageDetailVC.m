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
    
    if ( [self.params[@"msgtypeid"] integerValue] == 10 ||
         [self.params[@"msgtypeid"] integerValue] == 20) {
        NSString *more = @"<div class=\"more\">点击查看</div>";
        html = [html stringByReplacingOccurrencesOfString:@"${more}" withString:more];
    } else {
        html = [html stringByReplacingOccurrencesOfString:@"${more}" withString:@""];
    }
    
    [webView loadHTMLString:html baseURL:nil];
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    [self markViewMsg];
}

- (void)markViewMsg
{
    if ( [self.params[@"islook"] boolValue] == NO ) {
        id userInfo = [[UserService sharedInstance] currentUser];
        [[self apiServiceWithName:@"APIService"]
         POST:nil params:@{
                           @"dotype": @"GetData",
                           @"funname": @"供应商查看消息APP",
                           @"param1": [userInfo[@"supid"] ?: @"0" description],
                           @"param2": userInfo[@"loginname"] ?: @"",
                           @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                           @"param4": [self.params[@"supmsgid"] ?: @"0" description],
                           } completion:^(id result, NSError *error) {
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"kHasNewMessageNotification"
                                                                                   object:nil];
                           }];
    }
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
