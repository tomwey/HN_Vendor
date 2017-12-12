//
//  AppDelegate.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"
#import "GuideVC.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *appTabBarController;

@end

@implementation AppDelegate

@synthesize appRootController = _appRootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [APIServiceConfig defaultConfig].apiServer = API_HOST;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:MAIN_THEME_COLOR];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: MAIN_THEME_COLOR } forState:UIControlStateSelected];
    
    BOOL canShow = [GuideVC canShowGuide];
    
    [self showGuide:canShow];
    
    [self.window makeKeyAndVisible];
    
    [[VersionCheckService sharedInstance] startCheckWithSilent:YES];
    
    if ( !canShow ) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    }
    
    return YES;
}

- (void)showGuide:(BOOL)yesOrNo
{
    if ( yesOrNo ) {
        GuideVC *guideVC = [[GuideVC alloc] init];
        self.window.rootViewController = guideVC;
    } else {
        UINavigationController *nav =
        [[UINavigationController alloc] initWithRootViewController:[self rootVC]];
        nav.navigationBarHidden = YES;
        
        self.window.rootViewController = nav;
    }
}

- (UIViewController *)rootVC
{
    UIViewController *rootVC = nil;
    
    id currentUser = [[UserService sharedInstance] currentUser];
    if (currentUser) {
        rootVC = self.appRootController;
    } else {
        rootVC = [[NSClassFromString(@"LoginVC") alloc] init];
    }
    return rootVC;
}

- (UIViewController *)appRootController
{
    if ( !self.appTabBarController ) {
        self.appTabBarController = [[UITabBarController alloc] init];
        self.appTabBarController.delegate = self;
        
        UIViewController *workVC = [UIViewController createControllerWithName:@"WorkVC"];
        UIViewController *oaVC = [UIViewController createControllerWithName:@"OAListVC"];
        UIViewController *messageVC = [UIViewController createControllerWithName:@"PlanListVC"];
        UIViewController *contactsVC = [UIViewController createControllerWithName:@"ContactVC"];
        UIViewController *settingVC = [UIViewController createControllerWithName:@"SettingVC"];
        
        self.appTabBarController.viewControllers = @[workVC, oaVC, messageVC, contactsVC, settingVC];
        
        self.appTabBarController.selectedIndex = 0;
    }
    
    return self.appTabBarController;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    [HNNewFlowCountService sharedInstance].canFetch = self.appTabBarController.selectedIndex != 1;
//}

- (void)resetRootController
{
    self.appTabBarController = nil;
}

@end

@implementation UIWindow (NavBar)

- (UINavigationController *)navController
{
    return (UINavigationController *)self.rootViewController;
}

@end
