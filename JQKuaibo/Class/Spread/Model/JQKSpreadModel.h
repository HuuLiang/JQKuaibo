//
//  JQKSpreadModel.h
//  JQKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKProgram.h"

@interface JQKAppSpreadResponse : JQKURLResponse

@property (nonatomic,retain)NSArray <JQKProgram*>*programList;
@end

@interface JQKSpreadModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly)NSArray <JQKProgram*>*fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler;

@end
