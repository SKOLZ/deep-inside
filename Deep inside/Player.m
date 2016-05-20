//
//  Player.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/19/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import "Player.h"
#import "textures.h"

@implementation Player
+(instancetype)playerWithPosition: (CGPoint) pos {
    Player* p = [[Player alloc] initWithTexture: PLAYER_WALK1];
    p.position = pos;
    p.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:PLAYER_WALK1.size.height / 2];
    p.physicsBody.dynamic = YES;
    p.physicsBody.allowsRotation = NO;
    return p;
}

-(void)run {
    self.state = PLAYER_RUNNING;
    [self setTexture:PLAYER_WALK1];
    SKAction* run = [SKAction repeatActionForever:[SKAction animateWithTextures:@[PLAYER_WALK1, PLAYER_WALK2, PLAYER_WALK3, PLAYER_WALK4] timePerFrame: 0.125]];
    [self runAction: run];
}

-(void)jump {
    self.state = PLAYER_JUMPING;
    [self setTexture:PLAYER_JUMP1];
    SKAction* _jump = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_JUMP1, PLAYER_JUMP2, PLAYER_JUMP3, PLAYER_JUMP4] timePerFrame: 0.1] count: 1];
    [self.physicsBody applyImpulse:CGVectorMake(0, 900)];
    [self runAction:_jump completion:^{
        [self setTexture: PLAYER_JUMP4];
    }];
}

-(void)disappear {
    self.state = PLAYER_DISAPPEARED;
    [self setTexture:PLAYER_SMOKE1];
    SKAction* smoke = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_SMOKE1, PLAYER_SMOKE2, PLAYER_SMOKE3, PLAYER_SMOKE4, PLAYER_SMOKE5, PLAYER_SMOKE6, PLAYER_SMOKE7, PLAYER_SMOKE8] timePerFrame: 0.0625] count: 1];
    [self runAction:smoke completion:^{
        [self setTexture: NULL];
        [self removeAllActions];
    }];
}

-(void)appear {
    [self setTexture:PLAYER_SMOKE8];
    SKAction* unsmoke = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_SMOKE8, PLAYER_SMOKE7, PLAYER_SMOKE6, PLAYER_SMOKE5, PLAYER_SMOKE4] timePerFrame: 0.1] count: 1];
    [self runAction:unsmoke completion:^{
        [self run];
    }];
}

@end
