//
//  JQKAppCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKAppCell.h"

@interface JQKAppCell ()
{
    UIImageView *_imgV;
}
@end

@implementation JQKAppCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        _imgV = [[UIImageView alloc] init];
        _imgV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(kScreenWidth/5);
            }];
        }
        
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"place_51"]];
}

- (void)setIsInstalled:(BOOL)isInstalled {
    if (isInstalled) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"已安装";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        label.font = [UIFont systemFontOfSize:kWidth(40)];
        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:label];
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(kScreenWidth/5);
            }];
        }
    }
}

@end
