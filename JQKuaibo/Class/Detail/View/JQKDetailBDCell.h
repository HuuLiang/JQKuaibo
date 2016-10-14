//
//  JQKDetailBDCell.h
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickAction)(void);

@interface JQKDetailBDCell : UITableViewCell

@property (nonatomic) NSString *bdUrlStr;
@property (nonatomic) NSString *bdPasswordStr;

@property (nonatomic) clickAction vipAction;
@property (nonatomic) clickAction bdAction;
@property (nonatomic) clickAction copyAction;

@end
