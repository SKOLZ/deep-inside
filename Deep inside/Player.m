//
//  Player.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/19/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import "Player.h"
#import "textures.h"
#import "categories.h"
#import "MassRelation.h"

@implementation Player
+(instancetype)playerWithPosition: (CGPoint) pos {
    Player* p = [[Player alloc] initWithTexture: PLAYER_WALK1];
    p.position = pos;
    p.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(p.frame.size.width/2, p.frame.size.height)];
    p.physicsBody.dynamic = YES;
    p.physicsBody.allowsRotation = NO;
    p.physicsBody.categoryBitMask = playerCategory;
    p.physicsBody.contactTestBitMask = floorCategory;
    p.physicsBody.mass = PLAYER_MASS;
    return p;
}

-(void)run {
    self.state = PLAYER_RUNNING;
    [self setTexture:PLAYER_WALK1];
    SKAction* run = [SKAction repeatActionForever:[SKAction animateWithTextures:@[PLAYER_WALK1, PLAYER_WALK2, PLAYER_WALK3, PLAYER_WALK4] timePerFrame: 0.1]];
    [self removeAllActions];
    [self runAction: run];
}

-(void)jump {
    if (self.state == PLAYER_JUMPING) return;
    self.state = PLAYER_JUMPING;
    [self setTexture:PLAYER_JUMP1];
    SKAction* _jump = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_JUMP1, PLAYER_JUMP2, PLAYER_JUMP3, PLAYER_JUMP4] timePerFrame: 0.1] count: 1];
    [self.physicsBody applyImpulse:CGVectorMake(0, 1200)];
    [self removeAllActions];
    [self runAction:_jump completion:^{
        [self setTexture: PLAYER_JUMP4];
    }];
}

-(void)disappear {
    self.state = PLAYER_DISAPPEARED;
    [self setTexture:PLAYER_SMOKE1];
    SKAction* smoke = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_SMOKE1, PLAYER_SMOKE2, PLAYER_SMOKE3, PLAYER_SMOKE4, PLAYER_SMOKE5, PLAYER_SMOKE6, PLAYER_SMOKE7, PLAYER_SMOKE8] timePerFrame: 0.0625] count: 1];
    self.physicsBody.dynamic = NO;
    [self runAction:smoke completion:^{
        self.physicsBody.dynamic = YES;
        [self setTexture: NULL];
        [self removeAllActions];
        [self performSelector:@selector(appear) withObject:nil afterDelay: 1.0];
    }];
}

-(void)appear {
    [self setTexture:PLAYER_SMOKE8];
    SKAction* unsmoke = [SKAction repeatAction:[SKAction animateWithTextures:@[PLAYER_SMOKE8, PLAYER_SMOKE7, PLAYER_SMOKE6, PLAYER_SMOKE5, PLAYER_SMOKE4] timePerFrame: 0.0625] count: 1];
    [self removeAllActions];
    [self runAction:unsmoke completion:^{
        [self run];
    }];
}

@end
