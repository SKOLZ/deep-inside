//
//  Music.h
//  Deep inside
//
//  Created by Gabriel Zanzotti on 6/28/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#ifndef Music_h
#define Music_h
#import <AVFoundation/AVFoundation.h>

#define  TRACK1 [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"I Don't Want To Set The World On Fire-The Ink Spots" ofType:@"mp3"]]]
#define  TRACK2 [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ink Spots - If I Didn't Care" ofType:@"mp3"]]]
#define  TRACK3 [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"The Ink Spots - Maybe" ofType:@"mp3"]]]
#define  TRACK4 [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"The Ink Spots - It's All Over But The Crying" ofType:@"mp3"]]]
#define  TRACK5 [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"The Ink Spots - Into Each Life Some Rain Must Fall" ofType:@"mp3"]]]

#define  MENU_MUSIC [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"deep_inside_menu" ofType:@"mp3"]]]

#endif /* Music_h */
