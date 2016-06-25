//
//  JQKHotVideoViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHotVideoViewController.h"
#import "JQKHotVideoModel.h"
#import "JQKHotVideoCell.h"
#import "JQKSystemConfigModel.h"

static NSString *const kHotVideoCellReusableIdentifier = @"HotVideoCellReusableIdentifier";
CGFloat const kHotVideoSpace = 4;

static NSString *kHotAttentionArr = @"khotattentionarr";

@interface JQKHotVideoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    //    UIImageView *_headerImageView;
    //    UILabel *_priceLabel;
    
    UICollectionView *_layoutTableView;
}
@property (nonatomic,retain) JQKHotVideoModel *videoModel;
@property (nonatomic,retain) NSMutableArray<JQKProgram *> *videos;

@property (nonatomic,retain)NSArray *attentArr;//关注人数
@property (nonatomic,retain)NSArray *changePerson;//
@end

@implementation JQKHotVideoViewController

DefineLazyPropertyInitialization(JQKHotVideoModel, videoModel)
DefineLazyPropertyInitialization(NSMutableArray, videos)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _attentArr = [defaults objectForKey:kHotAttentionArr];
    if (!_attentArr) {
        
        NSMutableArray *attarr = [NSMutableArray array];
        
        for (int i = 0; i<250; i++) {
            NSInteger temp = (arc4random()%10 + 2)*100;
            NSString *str = [NSString stringWithFormat:@"%ld",(long)temp];
            [attarr addObject:str];
            
        }
        _attentArr = attarr;
        [defaults setObject:attarr forKey:kHotAttentionArr];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    
    //    if (![JQKUtil isPaid]) {
    //        _headerImageView = [[UIImageView alloc] init];
    //        _headerImageView.userInteractionEnabled = YES;
    //        
    //        _priceLabel = [[UILabel alloc] init];
    //        _priceLabel.font = [UIFont systemFontOfSize:14.];
    //        _priceLabel.textColor = [UIColor redColor];
    //        _priceLabel.textAlignment = NSTextAlignmentCenter;
    //        [_headerImageView addSubview:_priceLabel];
    //        {
    //            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.left.equalTo(_headerImageView).mas_offset(2);
    //                make.top.equalTo(_headerImageView.mas_centerY).mas_offset(-15);
    //                make.width.equalTo(_headerImageView).multipliedBy(0.1);
    //                
    //            }];
    //        }
    //        
    //        @weakify(self);
    //        [_headerImageView bk_whenTapped:^{
    //            @strongify(self);
    //            if (![JQKUtil isPaid]) {
    //                [self payForProgram:nil];
    //            };
    //        }];
    //        [self.view addSubview:_headerImageView];
    //        {
    //            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.top.left.right.equalTo(self.view);
    //                make.height.equalTo(_headerImageView.mas_width).multipliedBy(250./900);
    //            }];
    //        }
    //    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kHotVideoSpace;
    layout.minimumInteritemSpacing = kHotVideoSpace;
    _layoutTableView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    
    //    _layoutTableView.rowHeight = kScreenWidth*0.7;
    //    _layoutTableView.tableFooterView = [[UIView alloc] init];
    //    _layoutTableView.separatorColor = [UIColor blackColor];
    //    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTableView registerClass:[JQKHotVideoCell class] forCellWithReuseIdentifier:kHotVideoCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.right.bottom.equalTo(self.view);
            //            make.top.equalTo(_headerImageView?_headerImageView.mas_bottom:self.view);
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadVideosWithPage:1];
        //        [self loadHeaderImage];
        NSMutableArray *changeArr = [NSMutableArray array];
        for (int i = 0; i<250; i++) {
            NSInteger change = arc4random_uniform(60)+40;
            NSString *changeStr = [NSString stringWithFormat:@"%ld",(long)change];
            [changeArr addObject:changeStr];
        }
        self.changePerson = changeArr.copy;
    }];
    [_layoutTableView JQK_triggerPullToRefresh];
    
    [_layoutTableView JQK_addPagingRefreshWithIsChangeFooter:NO withHandler:^{
        @strongify(self);
        
        NSUInteger currentPage = self.videoModel.fetchedVideos.page.unsignedIntegerValue;
        [self loadVideosWithPage:currentPage+1];
    }];
}

//- (void)loadHeaderImage {
//    if ([JQKUtil isPaid]) {
//        return ;
//    }
//    
//    @weakify(self);
//    JQKSystemConfigModel *systemConfigModel = [JQKSystemConfigModel sharedModel];
//    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        
//        if (success) {
//            @weakify(self);
//            [self->_headerImageView sd_setImageWithURL:[NSURL URLWithString:systemConfigModel.channelTopImage]
//                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//            {
//                @strongify(self);
//                if (!self) {
//                    return ;
//                }
//                
//                if (image) {
//                    double showPrice = systemConfigModel.payAmount;
//                    BOOL showInteger = (NSUInteger)(showPrice * 100) % 100 == 0;
//                    self->_priceLabel.text = showInteger ? [NSString stringWithFormat:@"%ld", (NSUInteger)showPrice] : [NSString stringWithFormat:@"%.2f", showPrice];
//                } else {
//                    self->_priceLabel.text = nil;
//                }
//            }];
//        }
//    }];
//    
//}

//- (void)onPaidNotification:(NSNotification *)notification {
////    [_headerImageView removeFromSuperview];
////    _headerImageView = nil;
//    
//    [_layoutTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//}

- (void)loadVideosWithPage:(NSUInteger)page {
    @weakify(self);
    [self.videoModel fetchVideosWithPageNo:page completionHandler:^(BOOL success, JQKVideos *videos) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTableView JQK_endPullToRefresh];
        
        if (success) {
            if (page == 1) {
                [self.videos removeAllObjects];
            }
            [self.videos addObjectsFromArray:videos.programList];
            [self->_layoutTableView reloadData];
            
            if (videos.items.unsignedIntegerValue == self.videos.count) {
                [self->_layoutTableView JQK_pagingRefreshNoMoreData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:0 forSlideCount:1];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKHotVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotVideoCellReusableIdentifier forIndexPath:indexPath];
    JQKProgram *program = self.videos[indexPath.item];
    cell.imageURL = [NSURL URLWithString:program.coverImg];
    cell.title = program.title;
    NSString *attentText = @"";
    if (indexPath.item < self.attentArr.count) {
        NSString *attent = self.attentArr[indexPath.item];
        NSString *change = self.changePerson[indexPath.item];
        attentText = [NSString stringWithFormat:@"%ld",(attent.integerValue + change.integerValue)];
    }else {
        attentText = @"0";
    }
    cell.attentTitle = attentText;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wiedth = (kScreenWidth - kHotVideoSpace*3)/2;
    CGFloat height = wiedth *4/5;
    return CGSizeMake(wiedth, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[JQKStatsManager sharedManager] statsCPCWithProgram:self.videos[indexPath.item] programLocation:indexPath.item inChannel:_videoModel.fetchedVideos andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    
    if (indexPath.row < self.videos.count) {
        JQKProgram *video = self.videos[indexPath.item];
        [self switchToPlayProgram:video programLocation:indexPath.item inChannel:_videoModel.fetchedVideos];
    }
}


//#pragma mark - UITableViewDataSource,UITableViewDelegate

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    JQKHotVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotVideoCellReusableIdentifier forIndexPath:indexPath];
//    
//    if (indexPath.row < self.videos.count) {
//        JQKProgram *video = self.videos[indexPath.row];
//        cell.imageURL = [NSURL URLWithString:video.coverImg];
//        cell.title = video.title;
//        //cell.subtitle = video.specialDesc;
//        
////        @weakify(self);
////        cell.playAction = ^{
////            @strongify(self);
////            [self switchToPlayProgram:video];
////        };
//    }
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.videos.count;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < self.videos.count) {
//        JQKProgram *video = self.videos[indexPath.row];
//        [self switchToPlayProgram:video];
//    }
//}
@end
