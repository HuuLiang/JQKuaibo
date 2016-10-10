//
//  JQKBaseViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"
#import "JQKProgram.h"
#import "JQKPaymentViewController.h"
#import "JQKVideoPlayerViewController.h"
#import "JQKSystemConfigModel.h"

@import MediaPlayer;
@import AVKit;
@import AVFoundation.AVPlayer;
@import AVFoundation.AVAsset;
@import AVFoundation.AVAssetImageGenerator;

@interface JQKBaseViewController ()
//- (UIViewController *)playerVCWithVideo:(JQKVideo *)video;
@property (nonatomic,weak) UIButton *refreshBtn;
@end

@implementation JQKBaseViewController

- (NSUInteger)currentIndex {
    return NSNotFound;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)switchToPlayProgram:(JQKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKChannels *)channel{
//    program.videoUrl = @"http://dnmb.clxbb.com/hv5io/91ss/20160824zsdy40.mp4";
    if (![JQKUtil isPaid]) {
        [self payForProgram:program programLocation:programLocation inChannel:channel];
    } else if (program.type.unsignedIntegerValue == JQKProgramTypeVideo) {
        [self playVideo:program];
    }
}

- (void)playVideo:(JQKVideo *)video {
    [self playVideo:video withTimeControl:YES shouldPopPayment:NO withProgramLocation:0 inChannel:nil];
}

- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment withProgramLocation:(NSInteger)programLocation inChannel:(JQKChannels *)channel{
//    video.videoUrl = @"http://dnmb.clxbb.com/hv5io/91ss/20160824zsdy40.mp4";
    if (hasTimeControl) {
        
        @weakify(self);
        [[JQKVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
            @strongify(self);
            if (!self) {
                return ;
            }
            [self.view endProgressing];
            
            if (success) {
                #ifdef YYK_DISPLAY_VIDEO_URL
                NSString *url = [[JQKVideoTokenManager sharedManager] videoLinkWithOriginalLink:video.videoUrl];
                NSString *str = [NSURL URLWithString:url].absoluteString;
                [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:str cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
                #endif
                //            [self loadVideo:[NSURL URLWithString:[[JFVideoTokenManager sharedManager]videoLinkWithOriginalLink:_videoUrl]]];
                NSString *videoUrl = [[JQKVideoTokenManager sharedManager] videoLinkWithOriginalLink:video.videoUrl];
                UIViewController *videoPlayVC = [self playerVCWithVideoUrl:videoUrl];
                videoPlayVC.hidesBottomBarWhenPushed = YES;
                [self presentViewController:videoPlayVC animated:YES completion:nil];
            } else {
                [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            }
        }];

//        UIViewController *videoPlayVC = [self playerVCWithVideo:video];
//        videoPlayVC.hidesBottomBarWhenPushed = YES;
//        [self presentViewController:videoPlayVC animated:YES completion:nil];
    } else {
        JQKVideoPlayerViewController *playerVC = [[JQKVideoPlayerViewController alloc] initWithVideo:video];
        playerVC.hidesBottomBarWhenPushed = YES;
        playerVC.programLocation = programLocation;
        playerVC.channel = channel;
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}

- (void)payForProgram:(JQKProgram *)program
      programLocation:(NSUInteger)programLocation
            inChannel:(JQKChannels *)channel{
    [self payForProgram:program inView:self.view.window programLocation:programLocation inChannel:channel];
}

- (void)payForProgram:(JQKProgram *)program inView:(UIView *)view      programLocation:(NSUInteger)programLocation
            inChannel:(JQKChannels *)channel{
    [[JQKPaymentViewController sharedPaymentVC] popupPaymentInView:view forProgram:program programLocation:programLocation inChannel:channel withCompletionHandler:nil];
}

- (void)onPaidNotification:(NSNotification *)notification {}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)playerVCWithVideoUrl:(NSString *)videoUrl {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoUrl]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}
- (void)player:(AVPlayer *)player loadVideo:(NSURL *)videoUrl {
    //    player = [[AVPlayer alloc] initWithURL:videoUrl];
    //    [self.view insertSubview:_videoPlayer atIndex:0];
    //    {
    //        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.edges.equalTo(self.view);
    //        }];
    //    }
#ifdef JQK_DISPLAY_VIDEO_URL
    NSString *url = videoUrl.absoluteString;
    [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:url cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
#endif
}

- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(JQKAction) action;{
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn = refreshBtn;
    //    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(9.)];
    [refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(kScreenWidth/2.-kWidth(20.), (kScreenHeight-113.)/2. -kWidth(20.), kWidth(40.),kWidth(40.));
    refreshBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:refreshBtn];
    [UIView animateWithDuration:0.3 animations:^{
        //       refreshBtn.frame = CGRectMake(kScreenWidth/2.-kWidth(40.), (kScreenHeight-108.)/2.-kWidth(40.), kWidth(80.), kWidth(80.));
        refreshBtn.transform = CGAffineTransformMakeScale(1.6, 1.6);
        //        refreshBtn.frame
    }];
    [refreshBtn bk_addEventHandler:^(id sender) {
        if (action) {
            action(refreshBtn);
        }
        //        [refreshBtn removeFromSuperview];
        //        refreshBtn.enabled = NO;
        if (![JQKSystemConfigModel sharedModel].loaded) {
            [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:nil];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)removeCurrentRefreshBtn{
    if (self.refreshBtn) {
        [self.refreshBtn removeFromSuperview];
    }
    
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
