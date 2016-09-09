//
//  YYKWebViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@interface JQKOrderWebViewController : JQKBaseViewController

@property (nonatomic,readonly) NSURL *url;
@property (nonatomic,readonly) NSURL *standbyUrl;
@property (nonatomic,readonly) NSString *htmlString;

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl;
- (instancetype)initWithHTML:(NSString *)htmlString;

@end
