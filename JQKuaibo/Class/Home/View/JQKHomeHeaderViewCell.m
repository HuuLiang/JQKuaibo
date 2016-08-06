//
//  JQKHomeHeaderViewCell.m
//  JQKuaibo
//
//  Created by ylz on 16/8/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeHeaderViewCell.h"

@interface JQKHomeHeaderViewCell ()

@property (nonatomic,weak)UILabel *channelLabel;
@end

@implementation JQKHomeHeaderViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        //        UIView *self = [[UIView alloc] init];
        //        self.backgroundColor = [UIColor whiteColor];
        //        [self addSubview:self];
        
        UILabel *channelLabel = [[UILabel alloc] init];
        _channelLabel = channelLabel;
        channelLabel.text = @"热门频道";
        channelLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        channelLabel.font = [UIFont systemFontOfSize:kWidth(18.)];
        [self addSubview:channelLabel];
        
        UIImageView * leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeheader"]];
        [self addSubview:leftView];
        
        UIImageView * rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeheader"]];
        [self addSubview:rightView];
        
        {
            
            [channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.centerY.mas_equalTo(self).mas_offset(kWidth(8.));
                make.height.mas_equalTo(kWidth(22.));
            }];
            
            [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(channelLabel);
                make.right.mas_equalTo(channelLabel.mas_left).mas_offset(-kWidth(10.));
                make.size.mas_equalTo (CGSizeMake(kWidth(15.), kWidth(15.)));
            }];
            
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(channelLabel);
                make.left.mas_equalTo(channelLabel.mas_right).mas_offset(kWidth(10.));
                make.size.mas_equalTo (CGSizeMake(kWidth(15.), kWidth(15.)));
            }];
        }   
    }
    
    return self;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    _channelLabel.text = titleName;

}


@end
