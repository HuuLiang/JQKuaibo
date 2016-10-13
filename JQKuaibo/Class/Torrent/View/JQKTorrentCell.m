//
//  JQKTorrentCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTorrentCell.h"

@interface JQKTorrentCell()
{
    UILabel *_tagLabel;
    UILabel *_titleLabel;
    UIButton *_vipBtn;
    
    UIImageView *_imgVA;
    UIImageView *_imgVB;
    UIImageView *_imgVC;
    
    UIImageView *_userImgV;
    UILabel *_nameLabel;
    
    UILabel *_notiLabel;
    UILabel *_bdLabel;
}

@end

@implementation JQKTorrentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#asdasd"];
        self.backgroundColor = [UIColor redColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#edebeb"];
        [self addSubview:view];
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tagLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_titleLabel];
        
        _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipBtn setTitle:@"购买VIP直接发种子" forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [self addSubview:_vipBtn];
        
        _imgVA = [[UIImageView alloc] init];
        [self addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        [self addSubview:_imgVB];
        
        _imgVC = [[UIImageView alloc] init];
        [self addSubview:_imgVC];
        
        _userImgV = [[UIImageView alloc] init];
        [self addSubview:_userImgV];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:kWidth(20)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        [self addSubview:_nameLabel];
        
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.text = @"提取码VIP用户可见";
        _notiLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        _notiLabel.font = [UIFont systemFontOfSize:kWidth(20)];
        [self addSubview:_notiLabel];
        
        _bdLabel = [[UILabel alloc] init];
        _bdLabel.font = [UIFont systemFontOfSize:kWidth(20)];
        _bdLabel.textColor = [UIColor colorWithHexString:@"#f8f8f8"];
        _bdLabel.text = @"百度云观看";
        _bdLabel.layer.cornerRadius = kWidth(16);
        _bdLabel.layer.masksToBounds = YES;
        [self addSubview:_bdLabel];
        
        
        
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(kWidth(193));
            }];
            
            
            
            
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    
}

@end
