//
//  JQKWebViewController.h
//  JQKVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@interface JQKWebViewController : JQKBaseViewController
@property (nonatomic) NSURL *url;
- (instancetype)initWithURL:(NSURL *)url;
@end
