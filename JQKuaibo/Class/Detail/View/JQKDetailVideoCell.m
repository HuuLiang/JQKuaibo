//
//  JQKDetailVideoCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKDetailVideoCell.h"

@interface JQKDetailVideoCell ()
{
    UIImageView *_videoImgV;
}

@end

@implementation JQKDetailVideoCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithHexString:@"#979797"] CGColor];
        self.layer.masksToBounds = YES;
        
        _videoImgV = [[UIImageView alloc] init];
        [self addSubview:_videoImgV];

        
        UIImage *image = [UIImage imageNamed:@"detail_play"];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imgV];
        
        {
            [_videoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];

            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(80)));
            }];
        }
        
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_videoImgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

@end
