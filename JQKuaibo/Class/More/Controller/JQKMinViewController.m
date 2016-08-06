//
//  JQKMinViewController.m
//  JQKuaibo
//
//  Created by ylz on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMinViewController.h"
#import "JQKTableViewCell.h"
#import "JQKWebViewController.h"
#import "JQKSystemConfigModel.h"

@interface JQKMinViewController ()
{
    JQKTableViewCell *_bannerCell;
    JQKTableViewCell *_vipCell;
    JQKTableViewCell *_protocolCell;
    JQKTableViewCell *_telCell;
    
    NSInteger currentSection;
}
@end

@implementation JQKMinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layoutTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell || cell == self->_bannerCell) {
            if (![JQKUtil isPaid]) {
                
                [self payForProgram:nil programLocation:NSNotFound inChannel:nil];
            }
        } else if (cell == self->_protocolCell) {
             NSString *urlString = [JQK_BASE_URL stringByAppendingString:[JQKUtil isPaid]?JQK_AGREEMENT_PAID_URL:JQK_AGREEMENT_NOTPAID_URL];
            JQKWebViewController *webVC = [[JQKWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
            webVC.title = @"用户协议";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
            [UIAlertView bk_showAlertViewWithTitle:nil message:@"4006296682" cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006296682"]];
                }
            }];
        }
    };

    [self initCells];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [JQK_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JQK_BASE_URL.length-6) withString:@"******"];
        [[JQKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@", baseURLString, JQK_CHANNEL_NO, JQK_PACKAGE_CERTIFICATE, JQK_REST_PV]];
    }];
}

- (void)onPaidNotification:(NSNotification *)notification {
    if ([JQKUtil isPaid]) {
        [self removeAllLayoutCells];
        [self initCells];
        [self.layoutTableView reloadData];
    }
}
- (void)initCells {
    NSUInteger section = 0;
    
    _bannerCell = [[JQKTableViewCell alloc] init];
    _bannerCell.accessoryType = UITableViewCellAccessoryNone;
    _bannerCell.selectionStyle = [JQKUtil isPaid] ? UITableViewCellSelectionStyleNone :UITableViewCellSelectionStyleGray;
    _bannerCell.backgroundColor = [UIColor whiteColor];
//    _bannerCell.backgroundImageView.image = [UIImage imageNamed:@"setting_banner.jpg"];
    NSString *imageUrl = [JQKUtil isPaid] ? [JQKSystemConfigModel sharedModel].vipImage : [JQKSystemConfigModel sharedModel].ktVipImage;
    _bannerCell.imageUrl = [NSURL URLWithString:imageUrl];
    [self setLayoutCell:_bannerCell cellHeight:kScreenWidth*0.55 inRow:0 andSection:section++];
    
    if (![JQKUtil isPaid]) {
        _vipCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_vip_icon"] title:@"开通VIP"];
        _vipCell.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _vipCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self setLayoutCell:_vipCell cellHeight:44 inRow:0 andSection:section++];
    }
    
    [self setHeaderHeight:10 inSection:section];
    
    _protocolCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_protocol_icon"] title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:0 andSection:section++];
    
//    UITableViewCell *lineCell = [[UITableViewCell alloc] init];
//    lineCell.backgroundColor = [UIColor colorWithHexString:@"#575757"];
//    [self setLayoutCell:lineCell cellHeight:0.5 inRow:0 andSection:section++];
    
    if ([JQKUtil isPaid]) {
        [self setHeaderHeight:10 inSection:section];
        _telCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_tel_icon"] title:@"客服热线"];
        _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _telCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self setLayoutCell:_telCell cellHeight:44 inRow:0 andSection:section++];
    }
    currentSection = section;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
