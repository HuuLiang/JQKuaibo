//
//  JQKVideoPlayer.m
//  ShowTime
//
//  Created by Sean Yue on 16/1/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoPlayer.h"

@import AVFoundation;

@interface JQKVideoPlayer ()
{
    UILabel *_loadingLabel;
}
@property (nonatomic,retain) AVPlayer *player;
@property (nonatomic,retain) NSTimer *avTimer;
@end

@implementation JQKVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [self init];
    if (self) {
        _videoURL = videoURL;
        
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.text = @"加载中...";
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_loadingLabel];
        {
            [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
        
        self.player = [AVPlayer playerWithURL:videoURL];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndPlay) name:AVPlayerItemDidPlayToEndTimeNotification  object:nil];

         @weakify(self);
        self.avTimer = [NSTimer bk_scheduledTimerWithTimeInterval:0.5 block:^(NSTimer *timer) {
            float startSeconds = CMTimeGetSeconds(self.player.currentItem.currentTime);
            if (startSeconds >= 20.) {
                @strongify(self);
                [self didEndPlay];
                [self pause];
                [timer invalidate];
            }
        } repeats:YES];
         
        
    }
    return self;
}

- (void)didEndPlay {
    if (self.endPlayAction) {
        self.endPlayAction(self);
    }
}
- (void)startToPlay {
    [self.player play];
}

- (void)pause {
    [self.player pause];
    
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.avTimer invalidate];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusReadyToPlay:
                _loadingLabel.hidden = YES;
                break;
            default:
                _loadingLabel.hidden = NO;
                _loadingLabel.text = @"加载失败";
                break;
        }
    }
}
@end
