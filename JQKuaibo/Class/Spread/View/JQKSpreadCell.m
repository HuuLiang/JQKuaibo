//
//  JQKSpreadCell.m
//  JQKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKSpreadCell.h"

@interface JQKSpreadCell ()
{
    UIImageView *_thumbImageView;
}
@property (nonatomic,retain) UIView *installedView;
@end

@implementation JQKSpreadCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }

    }
    return self;
}

- (UIView *)installedView {
    if (_installedView) {
        return _installedView;
    }
    
    _installedView = [[UIView alloc] init];
    _installedView.hidden = YES;
    _installedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_thumbImageView addSubview:_installedView];
    {
        [_installedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_thumbImageView);
        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"已安装";
    label.font = [UIFont systemFontOfSize:20.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [_installedView addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_installedView);
        }];
    }
    return _installedView;
}


- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

- (void)setIsInstalled:(BOOL)isInstalled {
    _isInstalled = isInstalled;
    
    if (isInstalled) {
        self.installedView.hidden = NO;
    } else {
        _installedView.hidden = YES;
    }
}



@end
