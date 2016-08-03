//
//  JQKHomeHeaderViewCell.m
//  JQKuaibo
//
//  Created by ylz on 16/8/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeHeaderViewCell.h"

@implementation JQKHomeHeaderViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        UILabel *channelLabel = [[UILabel alloc] init];
        channelLabel.text = @"热门频道";
        channelLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        channelLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kWidth(16.)];
        [backView addSubview:channelLabel];
        
        UIImageView * leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeheader"]];
        [backView addSubview:leftView];
        
        UIImageView * rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeheader"]];
        [backView addSubview:rightView];
        
        {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self);
                make.top.mas_equalTo(self).mas_offset(kWidth(10.));
            }];
            
            [channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(backView);
                make.height.mas_equalTo(kWidth(22.));
            }];
            
            [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(channelLabel);
                make.right.mas_equalTo(channelLabel.mas_left).mas_offset(-kWidth(10.));
            }];
        
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(channelLabel);
                make.left.mas_equalTo(channelLabel.mas_right).mas_offset(kWidth(10.));
            }];
        }
        
        
    }
    
    return self;
}


@end
