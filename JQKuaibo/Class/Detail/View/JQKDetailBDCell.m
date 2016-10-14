//
//  JQKDetailBDCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKDetailBDCell.h"

@interface JQKDetailBDCell ()
{
    UIButton *_vipBtn;
    UIButton *_bdBtn;
    UILabel *_label;
    UITextField *_textField;
    UIButton *_copyBtn;
}
@end

@implementation JQKDetailBDCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipBtn setTitle:@"非VIP只能试看20秒，成为VIP获种子" forState:UIControlStateNormal];
        [_vipBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
        _vipBtn.layer.cornerRadius = kWidth(8);
        _vipBtn.layer.masksToBounds = YES;
        _vipBtn.backgroundColor = [UIColor colorWithHexString:@"#D0021B"];
        [self addSubview:_vipBtn];
        
        _bdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bdBtn setTitle:@"百度云观看" forState:UIControlStateNormal];
        [_bdBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _bdBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
        [_bdBtn setBackgroundColor:[UIColor colorWithHexString:@"#4c75c1"]];
        _bdBtn.layer.cornerRadius = kWidth(8);
        _bdBtn.layer.masksToBounds = YES;
        [self addSubview:_bdBtn];
        
        _label = [[UILabel alloc] init];
        _label.text = @"提取码vip会员可见";
        _label.textColor = [UIColor colorWithHexString:@"#000000"];
        _label.font = [UIFont systemFontOfSize:kWidth(17)];
        [self addSubview:_label];
        
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
        _textField.layer.cornerRadius = kWidth(8);
        _textField.layer.masksToBounds = YES;
        _textField.enabled = NO;
        [self addSubview:_textField];
        
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        _copyBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
        [self addSubview:_copyBtn];
        
        @weakify(self);
        [_vipBtn bk_addEventHandler:^(id sender) {
            @strongify(self)
            self.vipAction();
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_bdBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.bdAction();
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_copyBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.copyAction();
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(15));
                make.right.equalTo(self.mas_right).offset(-kWidth(15));
                make.top.equalTo(self).offset(kWidth(17));
                make.height.mas_equalTo(kWidth(47));
            }];
            
            [_bdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(15));
                make.top.equalTo(_vipBtn.mas_bottom).offset(kWidth(11));
                make.size.mas_equalTo(CGSizeMake(kWidth(138), kWidth(44)));
            }];

            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_bdBtn);
                make.left.equalTo(_bdBtn.mas_right).offset(kWidth(17));
                make.height.mas_equalTo(kWidth(20));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(15));
                make.top.equalTo(_bdBtn.mas_bottom).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(293), kWidth(44)));
            }];
            
            [_copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_textField);
                make.left.equalTo(_textField.mas_right).offset(kWidth(11));
                make.height.mas_equalTo(kWidth(20));
            }];
        }
        
    }
    return self;
}

- (void)setBdUrlStr:(NSString *)bdUrlStr {
    _textField.text = bdUrlStr;
}

- (void)setBdPasswordStr:(NSString *)bdPasswordStr {
    _label.text = bdPasswordStr;
}

@end
