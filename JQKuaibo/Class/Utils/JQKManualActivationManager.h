//
//  JQKManualActivationManager.h
//  JQKuaibo
//
//  Created by ylz on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQKManualActivationManager : NSObject

+ (instancetype)shareManager;
- (void)doActivate;

@end
