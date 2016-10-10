//
//  JQKAppDelegate.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKAppDelegate.h"
#import "JQKHomeViewController.h"
#import "JQKHotVideoViewController.h"
#import "JQKSpreadController.h"
#import "MobClick.h"
#import "JQKActivateModel.h"
#import "JQKUserAccessModel.h"
#import "JQKSystemConfigModel.h"
#import "JQKPaymentViewController.h"
#import "JQKMovieViewController.h"
#import "JQKLaunchView.h"
#import "JQKMinViewController.h"
#import <QBNetworkingConfiguration.h>
#import <QBNetworkInfo.h>


static NSString *const kHTPaySchemeUrl = @"wxd3c9c179bb827f2c";

@interface JQKAppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic,retain) UIViewController *rootViewController;
@end

@implementation JQKAppDelegate

- (UIViewController *)rootViewController {
    if (_rootViewController) {
        return _rootViewController;
    }
    
    JQKHomeViewController *homeVC        = [[JQKHomeViewController alloc] init];
    homeVC.title                         = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    
    UINavigationController *homeNav      = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:@"资源"
                                                                         image:[[UIImage imageNamed:@"home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 selectedImage:[[UIImage imageNamed:@"home_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKHotVideoViewController *videoVC   = [[JQKHotVideoViewController alloc] init];
    videoVC.title                        = @"精选";
    
    UINavigationController *videoNav     = [[UINavigationController alloc] initWithRootViewController:videoVC];
    videoNav.tabBarItem                = [[UITabBarItem alloc] initWithTitle:videoVC.title
                                                                       image:[[UIImage imageNamed:@"show_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                               selectedImage:[[UIImage imageNamed:@"show_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKMovieViewController *movieVC        = [[JQKMovieViewController alloc] init];
    movieVC.title                          = @"电影";
    
    UINavigationController *movieNav       = [[UINavigationController alloc] initWithRootViewController:movieVC];
    movieNav.tabBarItem                    = [[UITabBarItem alloc] initWithTitle:movieVC.title
                                                                           image:[[UIImage imageNamed:@"hot_video_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   selectedImage:[[UIImage imageNamed:@"hot_video_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKSpreadController *spreadVC = [[JQKSpreadController alloc] init];
    spreadVC.title = @"更多";
    UINavigationController *spreadNav = [[UINavigationController alloc] initWithRootViewController:spreadVC];
    spreadNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:spreadVC.title image:[UIImage imageNamed:@"tabbar_spread_normal"] selectedImage:[UIImage imageNamed:@"tabbar_spread_normal"]];
    
    
    //    JQKMineViewController *mineVC        = [[JQKMineViewController alloc] init];
    //    mineVC.title                         = @"我的";
    //
    //    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
    //    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
    //                                                                          image:[[UIImage imageNamed:@"mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    //                                                                 selectedImage:[[UIImage imageNamed:@"mine_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKMinViewController *moreVC        = [[JQKMinViewController alloc] init];
    moreVC.title                         = @"我的";
    
    UINavigationController *moreNav      = [[UINavigationController alloc] initWithRootViewController:moreVC];
    moreNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:moreVC.title
                                                                         image:[[UIImage imageNamed:@"more_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 selectedImage:[[UIImage imageNamed:@"more_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,videoNav,spreadNav,moreNav];
    tabBarController.tabBar.translucent     = NO;
    tabBarController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.95 alpha:1]];
    tabBarController.delegate = self;
    _rootViewController = tabBarController;
    return _rootViewController;
}


- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    
    return _window;
}




- (void)setupCommonStyles {
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationController.navigationBar.translucent = NO;
                                   thisVC.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1];
                                   thisVC.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.]};
                                   
                                   thisVC.navigationController.navigationBar.tintColor = [UIColor blackColor];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStyleBordered handler:nil];
                               } error:nil];
    
    //    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
    //                                    withOptions:AspectPositionInstead
    //                                     usingBlock:^(id<AspectInfo> aspectInfo){
    //                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
    //                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
    //                                     } error:nil];
    //    
    //    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
    //                              withOptions:AspectPositionInstead
    //                               usingBlock:^(id<AspectInfo> aspectInfo){
    //                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
    //                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
    //                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:JQK_UMENG_APP_ID reportPolicy:BATCH channelId:JQK_CHANNEL_NO];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JQKUtil accumateLaunchSeq];
    [QBNetworkingConfiguration defaultConfiguration].baseURL = JQK_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].channelNo = JQK_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = JQK_REST_PV;
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = JQK_REST_APP_ID;
#ifdef DEBUG
    //    [QBNetworkingConfiguration defaultConfiguration].logEnabled = YES;
#endif
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];//测试支付
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JQK_REST_APP_ID
                                                     paymentPv:JQK_PAYMENT_PV
                                                     channelNo:JQK_CHANNEL_NO
                                                     urlScheme:@"comsimiyingyuan2016appalipayurlscheme"];
    [[JQKErrorHandler sharedHandler] initialize];
    [self setupMobStatistics];
    [self setupCommonStyles];
    //    [[JQKNetworkInfo sharedInfo] startMonitoring];
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^(BOOL reachable) {
        if (reachable && ![JQKSystemConfigModel sharedModel].loaded) {
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
    };
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    BOOL requestedSystemConfig = NO;
    //    #ifdef JQK_IMAGE_TOKEN_ENABLED
    NSString *imageToken = [JQKUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
        self.window.rootViewController = self.rootViewController;
        [self.window makeKeyAndVisible];
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            self.window.rootViewController = self.rootViewController;
        }];
//        requestedSystemConfig = [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//            [self.window endProgressing];
//            
//            if (success) {
//                NSString *fetchedToken = [JQKSystemConfigModel sharedModel].imageToken;
//                [JQKUtil setImageToken:fetchedToken];
//                if (fetchedToken) {
//                    [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
//                }
//                
//            }
//            
//            self.window.rootViewController = self.rootViewController;
//            
//            NSUInteger statsTimeInterval = 180;
//            if ([JQKSystemConfigModel sharedModel].loaded && [JQKSystemConfigModel sharedModel].statsTimeInterval > 0) {
//                statsTimeInterval = [JQKSystemConfigModel sharedModel].statsTimeInterval;
//            }
//            [[JQKStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
//        }];
    }
    //    #else
    //        self.window.rootViewController = self.rootViewController;
    //        [self.window makeKeyAndVisible];
    //    #endif
    
    
    
    //    [self.window makeKeyWindow];
    //    self.window.hidden = NO;
    JQKLaunchView *launchView = [[JQKLaunchView alloc] init];
    [launchView show];
    
    if (![JQKUtil isRegistered]) {
        [[JQKActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            if (success) {
                [JQKUtil setRegisteredWithUserId:userId];
                [[JQKUserAccessModel sharedModel] requestUserAccess];
            }
        }];
    } else {
        [[JQKUserAccessModel sharedModel] requestUserAccess];
    }
    if (!requestedSystemConfig) {
        
        [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            //#ifdef JQK_IMAGE_TOKEN_ENABLED
            if (success) {
                [JQKUtil setImageToken:[JQKSystemConfigModel sharedModel].imageToken];
            }
            //#endif
            NSUInteger statsTimeInterval = 180;
            if ([JQKSystemConfigModel sharedModel].loaded && [JQKSystemConfigModel sharedModel].statsTimeInterval > 0) {
                statsTimeInterval = [JQKSystemConfigModel sharedModel].statsTimeInterval;
            }
            //        statsTimeInterval = 20;
            [[JQKStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
            //        if ([JQKSystemConfigModel sharedModel].notificationLaunchSeq >0) {
            //            [self registerUserNotification];
            //        }
            
            if (!success) {
                return ;
            }
            if ([JQKSystemConfigModel sharedModel].startupInstall.length == 0
                || [JQKSystemConfigModel sharedModel].startupPrompt.length == 0) {
                return ;
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].startupInstall]];
        }];
    }
    [[JQKVideoTokenManager sharedManager] requestTokenWithCompletionHandler:nil];
    return YES;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [JQKSystemConfigModel sharedModel].imageToken;
            [JQKUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
            }
            
        }
        
        NSUInteger statsTimeInterval = 180;
        [[JQKStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        SafelyCallBlock(completionHandler, success);
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
    //    if (![JQKUtil isAllVIPs]) {
    //        [[JQKPaymentManager sharedManager] checkPayment];
    //    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DLog(@"receive local notification");
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[JQKStatsManager sharedManager] statsTabIndex:tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[JQKStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    return YES;
}
@end
