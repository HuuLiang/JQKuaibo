//
//  JQKDetailViewController.h
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKLayoutViewController.h"
#import "JQKTorrentModel.h"

@interface JQKDetailViewController : JQKLayoutViewController
@property (nonatomic,retain) JQKProgram *programs;
@property (nonatomic,retain) JQKChannels *channels;

- (instancetype)initWithProgramInfo:(JQKTorrentResponse *)column index:(NSUInteger)index;

@end
