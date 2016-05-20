//
//  Player.h
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/19/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, PlayerState) {
    PLAYER_RUNNING,
    PLAYER_JUMPING,
    PLAYER_DISAPPEARED
};
@interface Player : SKSpriteNode

+(instancetype)playerWithPosition: (CGPoint) pos;
-(void)disappear;
-(void)jump;
-(void)run;
-(void)appear;
//-(void)showPlayerAfterSmoke;

@property (nonatomic) PlayerState state;

@end
