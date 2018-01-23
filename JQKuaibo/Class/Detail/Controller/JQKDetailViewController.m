//
//  JQKDetailViewController.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKDetailViewController.h"
#import "JQKDetailHeaderCell.h"
#import "JQKDetailVideoCell.h"
#import "JQKDetailBDCell.h"
#import "JQKDetailPhotoCell.h"

@interface JQKDetailViewController ()
{
    JQKTorrentProgram *_program;
    JQKTorrentResponse *_response;
    JQKDetailHeaderCell *_headerCell;
    JQKDetailVideoCell *_videoCell;
    JQKDetailBDCell *_bdCell;
    JQKDetailPhotoCell *_photoCell;
//    NSUInteger _index;
}
@property (nonatomic,assign)NSInteger index;
@end

@implementation JQKDetailViewController

- (instancetype)initWithProgramInfo:(JQKTorrentResponse *)column index:(NSUInteger)index {
    if (self = [super init]) {
        _index = index;
        _response = column;
        _program = column.programList[index];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
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
        if (cell == self->_videoCell) {
            
            JQKProgram *program = [[JQKProgram alloc] init];
            program.type = @(self->_program.type);
            program.programId = @(self->_program.programId);
            program.videoUrl = self->_program.videoUrl;
            
            JQKChannels *channels = [[JQKChannels alloc] init];
            channels.type = @(self->_response.type);
            channels.realColumnId = @(self->_response.realColumnId);
            
            JQKVideo *video = [[JQKVideo alloc] init];
            video.videoUrl = self->_program.videoUrl;
            [[JQKStatsManager sharedManager] statsCPCWithProgram:self.programs programLocation:self.index inChannel:self.channels andTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound];
            
            if ([JQKUtil isPaid]) {
                [self playVideo:video];
            } else {
                [self playVideo:program withTimeControl:NO shouldPopPayment:YES withProgramLocation:self->_index inChannel:channels];
            }
        }
    };
    
    [self initCells];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
}

- (void)onPaidNotification:(NSNotification *)notification {
    [self initCells];
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    [self initVideoCellInSection:section++];
    [self initBDCellInSection:section++];
    [self initPhotoCellInSection:section++];
}

- (void)initHeaderCellInSection:(NSInteger)section {
    _headerCell = [[JQKDetailHeaderCell alloc] init];
    _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerCell.tagStr = [[_program.tag componentsSeparatedByString:@"|"] lastObject];
    _headerCell.tagColor = [UIColor colorWithHexString:[[_program.tag componentsSeparatedByString:@"|"] firstObject]];
    _headerCell.titleStr = _program.title;
    [self setLayoutCell:_headerCell cellHeight:kWidth(47) inRow:0 andSection:section];
}

- (void)initVideoCellInSection:(NSInteger)section {
    _videoCell = [[JQKDetailVideoCell alloc] init];
    _videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _videoCell.imgUrlStr = _program.detailsCoverImg;
    [self setLayoutCell:_videoCell cellHeight:kWidth(206) inRow:0 andSection:section];
}

- (void)initBDCellInSection:(NSInteger)section {
    _bdCell = [[JQKDetailBDCell alloc] init];
    NSArray *array = [_program.spare componentsSeparatedByString:@"|"];
    if (array[1]) {
        _bdCell.bdUrlStr = array[1];
    }
    if (array[2] && [JQKUtil isPaid]) {
        _bdCell.bdPasswordStr = array[2];
    }
    @weakify(self);
    _bdCell.vipAction = ^ {
        @strongify(self);
        JQKProgram *program = [[JQKProgram alloc] init];
        program.type = @(self->_program.type);
        program.programId = @(self->_program.programId);
        
        JQKChannels *channels = [[JQKChannels alloc] init];
        channels.type = @(self->_response.type);
        channels.realColumnId = @(self->_response.realColumnId);
        
        if (![JQKUtil isPaid]) {
            [self payForProgram:program programLocation:self->_program.payPointType inChannel:channels];
        }else {
            [[JQKHudManager manager] showHudWithText:@"您已经是VIP用户"];
        }
    };
    
    _bdCell.bdAction = ^ {
        if (array[1]) {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:array[1]]];
        }
    };
    
    _bdCell.copyAction = ^ {
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = array[1] ? array[1] : @"";
        if (array[1]) {
            [[JQKHudManager manager] showHudWithText:@"复制成功"];
        }
    };
    
    [self setLayoutCell:_bdCell cellHeight:kWidth(173) inRow:0 andSection:section];
}

- (void)initPhotoCellInSection:(NSInteger)section {
    _photoCell = [[JQKDetailPhotoCell alloc] init];
    _photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_photoCell cellHeight:kWidth(40) inRow:0 andSection:section++];
    
    for (NSString *str in self->_program.imgurls) {
        [self setHeaderHeight:kWidth(5) inSection:section];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView * imgV = [[UIImageView alloc] init];
        [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
        [imgV setContentMode:UIViewContentModeScaleAspectFill];
        imgV.clipsToBounds = YES;
        [cell addSubview:imgV];
        {
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell);
            }];
        }
        
        [self setLayoutCell:cell cellHeight:(kScreenWidth - kWidth(30))*1.25 inRow:0 andSection:section++];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JQKStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
