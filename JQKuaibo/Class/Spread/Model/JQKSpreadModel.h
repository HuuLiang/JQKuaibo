//
//  JQKSpreadModel.h
//  JQKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
//#import "JQKProgram.h"

@interface JQKAppProgram : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *offUrl;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSInteger spec;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *videoUrl;
@end


@interface JQKAppSpreadResponse : JQKURLResponse
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *success;
@property (nonatomic) NSNumber *type;
@property (nonatomic,retain)NSArray <JQKAppProgram*>*programList;
@end

@interface JQKSpreadModel : JQKEncryptedURLRequest

@property (nonatomic,retain) JQKAppSpreadResponse *appSpreadResponse;
- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler;

@end
