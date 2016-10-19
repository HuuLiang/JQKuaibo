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
#import "JQKDetailViewController.h"

static NSString *const kTorrentVideoCellReusableIdentifier = @"TorrentVideoCellReusableIdentifier";

@interface JQKTorrentViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) JQKTorrentModel *torrentModel;
@property (nonatomic) JQKTorrentResponse *reponse;
@end

@implementation JQKTorrentViewController
QBDefineLazyPropertyInitialization(JQKTorrentModel, torrentModel)
QBDefineLazyPropertyInitialization(JQKTorrentResponse, reponse)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.backgroundColor = [UIColor clearColor];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        if (self.reponse.programList.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
//                [self loadData];
        [self->_layoutTableView JQK_triggerPullToRefresh];
            }];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)loadData {
    
    @weakify(self);
    [self.torrentModel fetchTorrentsCompletionHandler:^(BOOL success, JQKTorrentResponse * obj) {
        @strongify(self);
        [_layoutTableView JQK_endPullToRefresh];
        if (success) {
            self.reponse = obj;
            [self removeCurrentRefreshBtn];
            [_layoutTableView reloadData];
        }
//        else {
//            if (self.reponse.programList.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self loadData];
//                }];
//            }
//        }
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reponse.programList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKTorrentCell *cell = [tableView dequeueReusableCellWithIdentifier:kTorrentVideoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.reponse.programList.count) {
        JQKTorrentProgram *program = self.reponse.programList[indexPath.row];
        cell.tagStr = [[program.tag componentsSeparatedByString:@"|"] lastObject];
        cell.tagColor = [UIColor colorWithHexString:[[program.tag componentsSeparatedByString:@"|"] firstObject]];
        cell.userNameStr = [[program.spare componentsSeparatedByString:@"|"] firstObject];
        cell.titleStr = program.title;
        cell.urlsArr = program.imgurls;;
        @weakify(self);
        cell.action = ^(id sender) {
            @strongify(self);
            JQKProgram *pro = [[JQKProgram alloc] init];
            pro.programId = @(program.programId);
            pro.type = @(program.type);
            
            JQKChannels *channels = [[JQKChannels alloc] init];
            channels.type = @(self.reponse.type);
            channels.realColumnId = @(self.reponse.realColumnId);
            
            [self payForProgram:pro programLocation:indexPath.row inChannel:channels];
        };
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.reponse.programList.count - 1) {
        return kWidth(193);
    } else {
        return kWidth(198);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.reponse.programList.count) {
        JQKTorrentProgram *program = self.reponse.programList[indexPath.row];
        JQKDetailViewController *detailVC = [[JQKDetailViewController alloc] initWithProgramInfo:self.reponse index:indexPath.row];
        detailVC.title = program.title;
        JQKChannels *channels = [[JQKChannels alloc] init];
        channels.type = @(self.reponse.type);
        channels.realColumnId = @(self.reponse.realColumnId);
        [[JQKStatsManager sharedManager] statsCPCWithChannel:channels inTabIndex:self.tabBarController.selectedIndex];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


@end
