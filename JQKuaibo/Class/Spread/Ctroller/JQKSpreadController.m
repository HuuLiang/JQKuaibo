//
//  JQKSpreadController.m
//  JQKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKSpreadController.h"
#import "JQKSpreadCell.h"
#import "JQKSpreadModel.h"
#import "JQKSystemConfigModel.h"

static NSString *const kSpreadCellIdentifier = @"kspreadcellidentifer";

@interface JQKSpreadController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIImageView *_headerImageView;//头部视图
    UILabel *_priceLabel;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain)JQKSpreadModel *appSpreadModel;

@end

@implementation JQKSpreadController
DefineLazyPropertyInitialization(JQKSpreadModel,appSpreadModel);

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification) name:kPaidNotificationName object:nil];
    if (![JQKUtil isPaid]) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.userInteractionEnabled = YES;
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14.];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_headerImageView addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_headerImageView);
                make.top.equalTo(_headerImageView.mas_centerY);
                make.width.equalTo(_headerImageView).multipliedBy(0.1);
                
            }];
        }
        //点击_headerImageView付费
        @weakify(self);
        [_headerImageView bk_whenTapped:^{
            @strongify(self);
            if (![JQKUtil isPaid]) {
                [self payForPayPointType:JQKPayPointTypeVIP];
            };
        }];
        [self.view addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.equalTo(_headerImageView.mas_width).multipliedBy(210./900);
            }];
        }
    }
    
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_layoutCollectionView reloadData];
}
//设置collectionView
- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor clearColor];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[JQKSpreadCell class] forCellWithReuseIdentifier:kSpreadCellIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_headerImageView?_headerImageView.mas_bottom:self.view);
    }];
    }
    @weakify(self);
    [_layoutCollectionView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadHeaderImage];
        [self loadSpreadModel];
    }];
    [_layoutCollectionView JQK_triggerPullToRefresh];
    
    

}

//根据是否支付来判断_headerImageView是否显示
- (void)onPaidNotification {
    [_headerImageView removeFromSuperview];
    _headerImageView = nil;
    
    [_layoutCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)payForPayPointType:(JQKPayPointType)payPointType {
    JQKProgram *program = [[JQKProgram alloc] init];
    program.payPointType = @(payPointType);
    [self payForProgram:program];
}
//获取模型数据
- (void)loadSpreadModel {
    @weakify(self);
    [self.appSpreadModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView JQK_endPullToRefresh];
        
        if (success) {
            [self->_layoutCollectionView reloadData];
        }
    }];
}
/**
 *  获取头部视图以及价格信息
 */
- (void)loadHeaderImage {
    if ([JQKUtil isPaid]) {
        return ;
    }
    @weakify(self);
    JQKSystemConfigModel *systemConfigModel = [JQKSystemConfigModel sharedModel];
    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (success) {
            @weakify(self);
            [self->_headerImageView sd_setImageWithURL:[NSURL URLWithString:systemConfigModel.spreadTopImage]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 @strongify(self);
                 if (!self) {
                     return ;
                 }
                 
                 if (image) {
                     NSUInteger showPrice = systemConfigModel.payAmount;
                     BOOL showInteger = showPrice % 100 == 0;
                     self->_priceLabel.text = showInteger ? [NSString stringWithFormat:@"%ld", showPrice/100] : [NSString stringWithFormat:@"%.2f", showPrice/100.];
                 } else {
                     self->_priceLabel.text = nil;
                 }
             }];
        }
    }];
}


#pragma mark _collectionView Datasource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _appSpreadModel.fetchedSpreads.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell
    JQKSpreadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSpreadCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    
    if (indexPath.item < self.appSpreadModel.fetchedSpreads.count) {
        JQKProgram *appSpread = self.appSpreadModel.fetchedSpreads[indexPath.item];
        cell.imageURL = [NSURL URLWithString:appSpread.coverImg];
        cell.isInstalled = NO;
        
        [JQKUtil checkAppInstalledWithBundleId:appSpread.specialDesc completionHandler:^(BOOL installed) {
            if (installed) {
                cell.isInstalled = YES;
            }
        }];
        
    }else {
        cell.imageURL = nil;
        cell.isInstalled = NO;

    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds) - layout.sectionInset.left - layout.sectionInset.right;
    //    const CGFloat itemWidth = (fullWidth - 2 * layout.minimumInteritemSpacing) / 3;
    //    const CGFloat itemHeight = itemWidth + 20;
    return CGSizeMake(fullWidth, fullWidth * 0.4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKProgram *program = _appSpreadModel.fetchedSpreads[indexPath.item];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
}

@end
