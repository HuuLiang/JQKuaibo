//
//  JQKTorrentViewController.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTorrentViewController.h"
#import "JQKTorrentCell.h"
#import "JQKTorrentModel.h"

static NSString *const kTorrentVideoCellReusableIdentifier = @"TorrentVideoCellReusableIdentifier";

@interface JQKTorrentViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) JQKTorrentModel *torrentModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation JQKTorrentViewController
QBDefineLazyPropertyInitialization(JQKTorrentModel, torrentModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.backgroundColor = [UIColor clearColor];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[JQKTorrentCell class] forCellReuseIdentifier:kTorrentVideoCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_layoutTableView JQK_triggerPullToRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self loadData];
            }];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)loadData {
    [_layoutTableView reloadData];
//    @weakify(self);
//    [self.torrentModel fetchTorrentsCompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
//        if (success) {
//            
//        } else {
//            if (obj) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self loadData];
//                }];
//            }
//        }
//        
//    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKTorrentCell *cell = [tableView dequeueReusableCellWithIdentifier:kTorrentVideoCellReusableIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        return kWidth(193);
    } else {
        return kWidth(198);
    }
    
}


@end
