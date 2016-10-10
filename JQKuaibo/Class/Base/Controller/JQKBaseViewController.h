//
//  JQKBaseViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JQKProgram;
@class JQKVideo;

@interface JQKBaseViewController : UIViewController

//- (void)switchToPlayProgram:(JQKProgram *)program;
//- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment;
//- (void)payForProgram:(JQKProgram *)program;

- (void)switchToPlayProgram:(JQKProgram *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKChannels *)channel;
- (void)playVideo:(JQKVideo *)video;

- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment withProgramLocation:(NSInteger)programLocation inChannel:(JQKChannels *)channel;

- (void)payForProgram:(JQKProgram *)program
      programLocation:(NSUInteger)programLocation
            inChannel:(JQKChannels *)channel;
- (void)onPaidNotification:(NSNotification *)notification;

- (NSUInteger)currentIndex;
- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(JQKAction) action;
- (void)removeCurrentRefreshBtn;
@end
