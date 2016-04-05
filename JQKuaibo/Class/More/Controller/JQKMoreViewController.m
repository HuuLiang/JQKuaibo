//
//  JQKMoreViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMoreViewController.h"

@interface JQKMoreViewController () <UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation JQKMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [JQK_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JQK_BASE_URL.length-6) withString:@"******"];
        [[JQKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@", baseURLString, JQK_CHANNEL_NO, JQK_PACKAGE_CERTIFICATE, JQK_REST_PV]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *urlString = [JQK_BASE_URL stringByAppendingString:[JQKUtil isPaid]?JQK_AGREEMENT_PAID_URL:JQK_AGREEMENT_NOTPAID_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
