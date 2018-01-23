//
//  JQKProgramViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKProgramViewController.h"
#import "JQKChannelProgramModel.h"
//#import "JQKChannel.h"
#import "JQKProgramCell.h"

static const NSUInteger kDefaultPageSize = 18;
static NSString *const kProgramCellReusableIdentifier = @"ProgramCellReusableIdentifier";

@interface JQKProgramViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) JQKChannelProgramModel *programModel;
@property (nonatomic,retain) NSMutableArray<JQKProgram *> *programs;
@property (nonatomic) NSUInteger currentPage;
@end

@implementation JQKProgramViewController

DefineLazyPropertyInitialization(JQKChannelProgramModel, programModel)
DefineLazyPropertyInitialization(NSMutableArray, programs)

- (instancetype)initWithChannel:(JQKChannels *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.channel.name;
    
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = [UIColor whiteColor];
    
    //    _layoutTableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1];
    //    _layoutTableView.rowHeight = kScreenHeight * 0.18;
    _layoutTableView.rowHeight = kScreenWidth *0.45*0.6+3;
    //    _layoutTableView.tableFooterView = [[UIView alloc] init];
    // 去掉多余的分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [_layoutTableView setTableFooterView:view];
    [_layoutTableView registerClass:[JQKProgramCell class] forCellReuseIdentifier:kProgramCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView JQK_addPullToRefreshWithHandler:^{
        @strongify(self);
        
        self.currentPage = 0;
        [self.programs removeAllObjects];
        [self loadPrograms];
    }];
    [_layoutTableView JQK_triggerPullToRefresh];
    
    [_layoutTableView JQK_addPagingRefreshWithIsChangeFooter:YES withHandler:^{
        @strongify(self);
        if ([JQKUtil isPaid]) {
            
            [self loadPrograms];
        }else {
            [_layoutTableView JQK_endPullToRefresh];
            [self payForProgram:nil programLocation:0 inChannel:nil];
        }
    }];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回"
//                                                                                style:UIBarButtonItemStylePlain
//                                                                              handler:^(id sender)
//                                             {
//                                                 @strongify(self);
//                                                 [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//                                             }];
//    [self.navigationItem.leftBarButtonItem setTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.barTintColor = _layoutTableView.backgroundColor;
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.],
//                                                                    NSForegroundColorAttributeName:[UIColor blackColor]};
    
    //    
    //    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.bounds)-1,
    //                                                                    CGRectGetWidth(self.navigationController.navigationBar.bounds), 1)];
    //    bottomBorder.backgroundColor = _layoutTableView.separatorColor;
    //    [self.navigationController.navigationBar addSubview:bottomBorder];
}

- (void)loadPrograms {
    @weakify(self);
    [self.programModel fetchProgramsWithColumnId:self.channel.columnId
                                          pageNo:++self.currentPage
                                        pageSize:kDefaultPageSize
                               completionHandler:^(BOOL success, JQKChannels *programs) {
                                   @strongify(self);
                                   
                                   if (!self) {
                                       return;
                                   }
                                   
                                   if (success && programs.programList) {
                                       [self.programs addObjectsFromArray:programs.programList];
                                       [self->_layoutTableView reloadData];
                                   }
                                   
                                   [self->_layoutTableView JQK_endPullToRefresh];
                                   
                                   if (self.programs.count >= programs.items.unsignedIntegerValue) {
                                       [self->_layoutTableView JQK_pagingRefreshNoMoreData];
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
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQKProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:kProgramCellReusableIdentifier
                                                           forIndexPath:indexPath];
    //    cell.backgroundColor = tableView.backgroundColor;
    
    if (indexPath.row < self.programs.count) {
        JQKProgram *program = self.programs[indexPath.row];
        cell.title = program.title;
        cell.subtitle = program.specialDesc;
        cell.thumbImageURL = [NSURL URLWithString:program.coverImg];
        
        NSDictionary *tags = @{@(JQKVideoSpecHot):@"hot_tag",
                               @(JQKVideoSpecNew):@"new_tag",
                               @(JQKVideoSpecHD):@"hd_tag"};
        cell.tagImage = [UIImage imageNamed:tags[program.spec]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.programs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JQKProgram *program = self.programs[indexPath.row];
//    [self switchToPlayProgram:program];
    [self switchToPlayProgram:program programLocation:indexPath.row inChannel:_programModel.fetchedPrograms];
    [[JQKStatsManager sharedManager] statsCPCWithProgram:program programLocation:indexPath.row inChannel:self.programModel.fetchedPrograms andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    
//    if (![JQKUtil isPaid]) {
//        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//    }
}

@end
