//
//  AppDelegate.h
//  WhackwhoNew
//
//  Created by Bob Li on 12-06-22.
//  Copyright (c) 2012 Waterloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate> {
    UserInfo *usr;
    
    AVAudioPlayer *_backgroundMusicPlayer;
	BOOL _backgroundMusicPlaying;
	BOOL _backgroundMusicInterrupted;
	UInt32 _otherMusicIsPlaying;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UserInfo *usr;
@property (nonatomic,assign) BOOL appUsageCheckEnabled;

- (void)tryPlayMusic;

@end
