//
//  JQKVideoPlayerViewController.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoPlayerViewController.h"
#import "JQKVideoPlayer.h"
#import "JQKVideo.h"
#import "JQKPaymentViewController.h"

@interface JQKVideoPlayerViewController ()
{
    JQKVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
}
@end

@implementation JQKVideoPlayerViewController

- (instancetype)initWithVideo:(JQKVideo *)video {
    self = [self init];
    if (self) {
        _video = video;
        _shouldPopupPaymentIfNotPaid = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
//    [self.view beginProgressingWithTitle:@"加载中..." subtitle:nil];
    @weakify(self);
//    [[JQKVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        [self.view endProgressing];
//        if (success) {
//            [self loadVideo:[NSURL URLWithString:[[JQKVideoTokenManager sharedManager] videoLinkWithOriginalLink:self.video.videoUrl]]];
//        }
    
//    }];
    
    [self loadVideo:[NSURL URLWithString:[JQKUtil encodeVideoUrlWithVideoUrlStr:self.video.videoUrl]]];
//    [self loadVideo:[NSURL URLWithString:[JQKUtil encodeVideoUrlWithVideoUrlStr:@"http://7xtjbc.com1.z0.glb.clouddn.com/tnmb/A895389AF31EDA0D5C644DBC87433891.mp4"]]];
    
    _videoPlayer.endPlayAction = ^(id sender) {
        @strongify(self);
        [self dismissAndPopPayment];
    };
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
        }];
    }
    
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_videoPlayer pause];
        [self dismissAndPopPayment];
        //        if (_shouldPopupPaymentIfNotPaid && ![JQKUtil isPaid]) {
        //            [[JQKPaymentViewController sharedPaymentVC] popupPaymentInView:self.view forProgram:(JQKProgram *)self.video
        //                                                           programLocation:_programLocation
        //                                                                 inChannel:_channel withCompletionHandler:^{
        //                                                                     @strongify(self);
        //                                                                     [self dismissViewControllerAnimated:YES completion:nil];
        //                                                                 }];
        //        } else {
        //            [self dismissViewControllerAnimated:YES completion:nil];
        //        }
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadVideo:(NSURL *)videoUrl {
    _videoPlayer = [[JQKVideoPlayer alloc] initWithVideoURL:videoUrl];
    [self.view insertSubview:_videoPlayer atIndex:0];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
#ifdef JQK_DISPLAY_VIDEO_URL
    NSString *url = videoUrl.absoluteString;
    [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:url cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
#endif
}


- (void)dismissAndPopPayment {
    [self payForProgram:(JQKProgram *)_video programLocation:_programLocation inChannel:_channel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer startToPlay];
}

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}

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
