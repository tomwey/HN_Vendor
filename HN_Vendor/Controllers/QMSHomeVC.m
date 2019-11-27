//
//  SaleRegVC.m
//  HN_ERP
//
//  Created by tomwey on 09/08/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "QMSHomeVC.h"
#import <WebKit/WebKit.h>
#import "Defines.h"
#import "NSDataAdditions.h"
#import "GCDWebServer.h"
//#import "GCDWebServerDataResponse.h"

@interface QMSHomeVC () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) GCDWebServer *webServer;

@end

@implementation QMSHomeVC

- (void)dealloc
{
    [self.webServer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webServer = [[GCDWebServer alloc] init];
    
    UIView *hackHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    [self.view addSubview:hackHeader];
    hackHeader.backgroundColor = MAIN_THEME_COLOR;

    CGFloat topMargin = 20;
    CGFloat dtHeight = 0;
    
    if (AWOSVersionIsLower(11)) {
        topMargin = 20;
        dtHeight  = 0;
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        if ( AWFullScreenHeight() == 812 ) {
            // iphone x
            topMargin = 44;
            dtHeight  = 34;
        } else {
            // 其它iphone
        }
    }
    
    self.webView = [[WKWebView alloc] initWithFrame:
                    CGRectMake(0, topMargin, AWFullScreenWidth(), AWFullScreenHeight() - topMargin - dtHeight)];
    [self.view addSubview:self.webView];
    
//    self.view.backgroundColor = [UIColor redColor];
    id user = [[UserService sharedInstance] currentUser];
//
//    NSDictionary *dict = @{
//                           @"manid": @"217"
//                           };
    
//    NSString *server = @"http://10.0.10.75:8003/home";
//    NSString *urlString = [NSString stringWithFormat:@"%@?manid=%@&app=ERP", server, [user[@"man_id"] ?: @"0" description]];
    
//    NSURL *url = [NSURL URLWithString:urlString];
    NSString *dir = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil];
    
    [self.webServer addGETHandlerForBasePath:@"/"
                               directoryPath: dir
                               indexFilename:@"index.html"
                                    cacheAge: NSIntegerMax
                          allowRangeRequests:NO];
    [self.webServer startWithPort:8080 bonjourName:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?manid=%@&app=2", @"http://127.0.0.1:8080", [user[@"accountid"] ?: @"0" description]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.timeoutInterval = 30;
//    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    self.webView.navigationDelegate = self;

    [self.webView loadRequest:request];

    self.webView.backgroundColor = AWColorFromRGB(247, 247, 247);
    
    [HNProgressHUDHelper showHUDAddedTo:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    //    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [HNProgressHUDHelper hideHUDForView:self.view animated:YES];
    
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //    [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    [HNProgressHUDHelper hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
//    NSLog(@"%@, %d", request, navigationAction.navigationType);
    if ( [[request.URL absoluteString] isEqualToString:@"qms://back"] ) {
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ( [[request.URL absoluteString] hasPrefix:@"qms://openflow"] ) {
//        [self.navigationController popViewControllerAnimated:YES];
        
        NSString *ids = [[[request.URL absoluteString] componentsSeparatedByString:@"="] lastObject];
        
        NSDictionary *params = @{
                                 @"item": @{ @"mid": ids ?: @"0" },
                                 @"has_action": @(YES),
                                 @"state": @"todo"};
        
        UIViewController *detailVC = [[AWMediator sharedInstance] openVCWithName:@"OADetailVC"
                                                                          params:params];
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ( [[request.URL absoluteString] hasPrefix:@"tel:"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[request.URL absoluteString]]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
