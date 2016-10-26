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
#import "JQKSpreadModel.h"
#import "JQKAppCell.h"
#import "JQKManualActivationManager.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";


@interface JQKMinViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    JQKTableViewCell *_bannerCell;
    JQKTableViewCell *_vipCell;
    JQKTableViewCell *_activateCell;
    JQKTableViewCell *_protocolCell;
    JQKTableViewCell *_telCell;
    
    UITableViewCell *_appCell;
    UICollectionView *_appCollectionView;
    
    NSInteger currentSection;
}
@property (nonatomic,retain)JQKSpreadModel *appSpreadModel;
@property (nonatomic) NSMutableArray *fetchedSpreads;
@end

@implementation JQKMinViewController
QBDefineLazyPropertyInitialization(JQKSpreadModel, appSpreadModel)
QBDefineLazyPropertyInitialization(NSMutableArray, fetchedSpreads)

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
                
                [self payForProgram:nil programLocation:indexPath.section inChannel:nil];
            }
        }else if (cell == self-> _activateCell){
            [[JQKManualActivationManager shareManager] doActivate];
        
        } else if (cell == self->_protocolCell) {
            NSString *urlString = [JQK_BASE_URL stringByAppendingString:[JQKUtil isPaid]?JQK_AGREEMENT_PAID_URL:JQK_AGREEMENT_NOTPAID_URL];
            JQKWebViewController *webVC = [[JQKWebViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
            webVC.title = @"用户协议";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
            [self contactCustomerService];
        }
    };
    
    
    
    [self.layoutTableView JQK_addPullToRefreshWithHandler:^{
        [self loadSpreadModel];
    }];
    
    [self.layoutTableView JQK_triggerPullToRefresh];
    
    [self initCells];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [JQK_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JQK_BASE_URL.length-6) withString:@"******"];
        [[JQKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@", baseURLString, JQK_CHANNEL_NO, JQK_PACKAGE_CERTIFICATE, JQK_REST_PV]];
    }];
}

- (void)contactCustomerService {
    NSString *contactScheme = [JQKSystemConfigModel sharedModel].contactScheme;
    NSString *contactName = [JQKSystemConfigModel sharedModel].contactName;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onPaidNotification:(NSNotification *)notification {
    if ([JQKUtil isPaid]) {
        [self removeAllLayoutCells];
        [self loadSpreadModel];
        [self initCells];
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
        
        [self setHeaderHeight:10 inSection:section];
        
        _activateCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_activate"] title:@"自助激活"];
        _activateCell.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        _activateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _activateCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self setLayoutCell:_activateCell cellHeight:44 inRow:0 andSection:section++];
    }
    
    [self setHeaderHeight:10 inSection:section];
    
    _protocolCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_protocol_icon"] title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:0 andSection:section++];
    
    if ([JQKUtil isPaid]) {
        [self setHeaderHeight:10 inSection:section];
        _telCell = [[JQKTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_tel_icon"] title:@"客服热线"];
        _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _telCell.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self setLayoutCell:_telCell cellHeight:44 inRow:0 andSection:section++];
    }
    currentSection = section;
//    [self.layoutTableView reloadData];
}

- (void)loadSpreadModel {
    @weakify(self);
    [self.appSpreadModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        [self.layoutTableView JQK_endPullToRefresh];
        if (success) {
            [self.fetchedSpreads removeAllObjects];
            [self.fetchedSpreads addObjectsFromArray:obj];
            if (self.fetchedSpreads.count > 0) {
                [self initAppCell:currentSection];
            }
        }
    }];
}

- (void)initAppCell:(NSInteger)section {
    [self setHeaderHeight:kWidth(10) inSection:section];
    
    _appCell = [[UITableViewCell alloc] init];
    _appCell.backgroundColor = [UIColor clearColor];
    
    _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self createLayout]];
    _appCollectionView.backgroundColor = [UIColor clearColor];
    _appCollectionView.delegate = self;
    _appCollectionView.dataSource = self;
    _appCollectionView.scrollEnabled = NO;
    _appCollectionView.showsVerticalScrollIndicator = NO;
    [_appCollectionView registerClass:[JQKAppCell class] forCellWithReuseIdentifier:kMoreCellReusableIdentifier];
    [_appCell addSubview:_appCollectionView];
    {
        [_appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_appCell);
        }];
    }
    
    [self setLayoutCell:_appCell cellHeight:(self.fetchedSpreads.count * kScreenWidth/5 + (self.fetchedSpreads.count - 1)*kWidth(3)) inRow:0 andSection:section];
    
    [self.layoutTableView reloadData];
}

- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(3);
    layout.minimumInteritemSpacing = kWidth(3);
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenWidth/5);
    return layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMoreCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.fetchedSpreads.count) {
        JQKAppProgram *app = self.fetchedSpreads[indexPath.item];
        cell.imgUrl = app.coverImg;
        [JQKUtil checkAppInstalledWithBundleId:app.specialDesc completionHandler:^(BOOL isInstalled) {
            cell.isInstalled = isInstalled;
        }];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedSpreads.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.fetchedSpreads.count) {
        JQKProgram *program = self.fetchedSpreads[indexPath.item];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
        [[JQKStatsManager sharedManager] statsCPCWithProgram:(JQKProgram *)program programLocation:indexPath.row inChannel:(JQKChannels*)_appSpreadModel.appSpreadResponse andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forSlideCount:1];
    
}



@end
