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
#import "JQKTorrentViewController.h"
#import "JQKLaunchView.h"
#import "JQKMinViewController.h"
#import <QBNetworkingConfiguration.h>
#import <QBNetworkInfo.h>
#import <QBPaymentConfig.h>


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
    
    JQKTorrentViewController *torrentVC        = [[JQKTorrentViewController alloc] init];
    torrentVC.title                          = @"种子";
    
    UINavigationController *torrentNav       = [[UINavigationController alloc] initWithRootViewController:torrentVC];
    torrentNav.tabBarItem                    = [[UITabBarItem alloc] initWithTitle:torrentVC.title
                                                                           image:[[UIImage imageNamed:@"hot_video_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   selectedImage:[[UIImage imageNamed:@"hot_video_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKMinViewController *moreVC        = [[JQKMinViewController alloc] init];
    moreVC.title                         = @"我的";
    
    UINavigationController *moreNav      = [[UINavigationController alloc] initWithRootViewController:moreVC];
    moreNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:moreVC.title
                                                                         image:[[UIImage imageNamed:@"more_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 selectedImage:[[UIImage imageNamed:@"more_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,videoNav,torrentNav,moreNav];
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
//        [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];//测试支付

    [JQKUtil setDefaultPrice];
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JQK_REST_APP_ID paymentPv:JQK_PAYMENT_PV channelNo:JQK_CHANNEL_NO urlScheme:@"comsimiyingyuan2016appalipayurlscheme" defaultConfig:[self setDefaultPaymentConfig]];
    [[JQKErrorHandler sharedHandler] initialize];
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^(BOOL reachable) {
        if (reachable && ![JQKSystemConfigModel sharedModel].loaded) {
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        if (reachable && ![JQKUtil isRegistered]) {
            [[JQKActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
                if (success) {
                    [JQKUtil setRegisteredWithUserId:userId];
                    [[JQKUserAccessModel sharedModel] requestUserAccess];
                       [[JQKVideoTokenManager sharedManager] requestTokenWithCompletionHandler:nil];
                }
            }];
        } else {
            [[JQKUserAccessModel sharedModel] requestUserAccess];
             [[JQKVideoTokenManager sharedManager] requestTokenWithCompletionHandler:nil];
        }
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![JQKUtil isRegistered] || ![JQKSystemConfigModel sharedModel].loaded)) {
            
            
            if ([JQKUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
                //                [[CRBHudManager manager] showHudWithText:@"请检查您的网络连接!"];
            }else {
            [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            }}
    };

    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    [self setupMobStatistics];
    [self setupCommonStyles];
    
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
    }
//    
//    if (![JQKUtil isRegistered]) {
//        [[JQKActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
//            if (success) {
//                [JQKUtil setRegisteredWithUserId:userId];
//                [[JQKUserAccessModel sharedModel] requestUserAccess];
//            }
//        }];
//    } else {
//        [[JQKUserAccessModel sharedModel] requestUserAccess];
//    }
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
//                    statsTimeInterval = 20;
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

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3006339410";
    iAppPayConfig.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCylTy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlltV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    
    //    //海豚默认配置
    QBHTPayConfig *htpayConfig = [[QBHTPayConfig alloc] init];
    htpayConfig.mchId = @"10014";
    htpayConfig.key = @"55f4f728b7a01c2e57a9f767fd34cb8e";
    htpayConfig.appid = @"wxf1fa52ed49c4c7da";//@"wxdea87ffa75dfb0fa";
    htpayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyHtPay.json";
    htpayConfig.payType = @"z";
    configDetails.htpayConfig = htpayConfig;
    
    //WJPAY
//    QBWJPayConfig *wjPayCofig = [[QBWJPayConfig alloc] init];
//    wjPayCofig.mchId = @"50000009";
//    wjPayCofig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyWujism.json";
//    wjPayCofig.signKey = @"B0C65DF81AA7EA85";
//    configDetails.wjPayConfig = wjPayCofig;
    
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = @"IAPPPAY";
    payConfig.wechat = @"HAITUN";
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    
    [config setAsCurrentConfig];
    return config;
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
