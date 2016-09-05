//
//  JQKURLResponse.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JQKResponseParsable <NSObject>

@optional
- (Class)JQK_classOfProperty:(NSString *)propName;
- (NSString *)JQK_propertyOfParsing:(NSString *)parsingName;

@end


@interface JQKURLResponse : NSObject

@property (nonatomic) NSNumber *success;
@property (nonatomic) NSString *resultCode;
@property (nonatomic) NSNumber *code;


- (void)parseResponseWithDictionary:(NSDictionary *)dic;

@end
