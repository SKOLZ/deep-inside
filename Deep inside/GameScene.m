//
//  GameScene.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/11/16.
//  Copyright (c) 2016 White Stone. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
    SKSpriteNode* _player;
    SKSpriteNode* _smoke;
    SKColor* _skyColor;
    SKAction* _dissappear;
    SKAction* _appear;
    SKAction* _run;
    BOOL smoked;
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    // Create background color
    
    _skyColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self setBackgroundColor:_skyColor];
    
    // Create background
    
    SKTexture* backgroundTexture = [SKTexture textureWithImageNamed:@"game_background"];
    //
    //    // The +2 is to give a little more just to help preload the last part of a frame
    //    // We did not multipy background *2 because we have an already duplicated background image
    SKAction* moveSkylineSprite = [SKAction moveByX:-backgroundTexture.size.width y:0 duration:0.08 * backgroundTexture.size.width];
    SKAction* resetSkylineSprite = [SKAction moveByX:backgroundTexture.size.width y:0 duration:0];
    SKAction* moveSkylineSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkylineSprite, resetSkylineSprite]]];
    
    for( int i = 0; i < 2 + self.frame.size.width / ( backgroundTexture.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:0.8];
        sprite.zPosition = -20;
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
        [sprite runAction:moveSkylineSpritesForever];
        [self addChild:sprite];
    }
    
    // Create ground
    
    SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"game_ground"];
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width y:0 duration:0.015 * groundTexture.size.width];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for( int i = 0; i < 2 + self.frame.size.width / ( groundTexture.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height);
        [sprite runAction:moveGroundSpritesForever];
        [self addChild:sprite];
    }
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, groundTexture.size.height - 5);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    // Create player
    
    
    SKTexture* playerTexture1 = [SKTexture textureWithImageNamed:@"player_walk1"];
    _player = [SKSpriteNode spriteNodeWithTexture:playerTexture1];
    [_player setScale:1];
    _player.position = CGPointMake(self.frame.size.width / 4, groundTexture.size.height + _player.size.height / 2 - 5);
    [_player runAction:[self _run]];
    
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_player.size.height / 2];
    _player.physicsBody.dynamic = YES;
    _player.physicsBody.allowsRotation = NO;
    
    
    SKTexture* smokeTexture1 = [SKTexture textureWithImageNamed:@"smoke1"];
    _smoke = [SKSpriteNode spriteNodeWithTexture:smokeTexture1];
    [_smoke setScale:1];
    _smoke.position = _player.position;
    smoked = NO;
    
    [self addChild:_player];
}

-(SKAction*)_run {
    SKTexture* playerTexture1 = [SKTexture textureWithImageNamed:@"player_walk1"];
    SKTexture* playerTexture2 = [SKTexture textureWithImageNamed:@"player_walk2"];
    SKTexture* playerTexture3 = [SKTexture textureWithImageNamed:@"player_walk3"];
    SKTexture* playerTexture4 = [SKTexture textureWithImageNamed:@"player_walk4"];
    
    SKAction* run = [SKAction repeatActionForever:[SKAction animateWithTextures:@[playerTexture1, playerTexture2, playerTexture3, playerTexture4] timePerFrame: 0.125]];
    return run;
}

-(SKAction*)_appear {
    SKTexture* smokeTexture4 = [SKTexture textureWithImageNamed:@"smoke4"];
    SKTexture* smokeTexture5 = [SKTexture textureWithImageNamed:@"smoke5"];
    SKTexture* smokeTexture6 = [SKTexture textureWithImageNamed:@"smoke6"];
    SKTexture* smokeTexture7 = [SKTexture textureWithImageNamed:@"smoke7"];
    SKTexture* smokeTexture8 = [SKTexture textureWithImageNamed:@"smoke8"];
    
    SKAction* smoke = [SKAction repeatAction:[SKAction animateWithTextures:@[smokeTexture8, smokeTexture7, smokeTexture6, smokeTexture5, smokeTexture4] timePerFrame: 0.1] count: 1];
    
    return smoke;
}

-(void)showPlayerAfterSmoke {
    [_smoke runAction: [self _appear] completion:^{
        [_player runAction: [self _run]];
        [_smoke runAction: [SKAction stop]];
        [self addChild:_player];
        [self removeChildrenInArray:@[_smoke]];
    }];
}


-(SKAction*)_dissappear {
    SKTexture* smokeTexture1 = [SKTexture textureWithImageNamed:@"smoke1"];
    SKTexture* smokeTexture2 = [SKTexture textureWithImageNamed:@"smoke2"];
    SKTexture* smokeTexture3 = [SKTexture textureWithImageNamed:@"smoke3"];
    SKTexture* smokeTexture4 = [SKTexture textureWithImageNamed:@"smoke4"];
    SKTexture* smokeTexture5 = [SKTexture textureWithImageNamed:@"smoke5"];
    SKTexture* smokeTexture6 = [SKTexture textureWithImageNamed:@"smoke6"];
    SKTexture* smokeTexture7 = [SKTexture textureWithImageNamed:@"smoke7"];
    SKTexture* smokeTexture8 = [SKTexture textureWithImageNamed:@"smoke8"];
    
    SKAction* smoke = [SKAction repeatAction:[SKAction animateWithTextures:@[smokeTexture1, smokeTexture2, smokeTexture3, smokeTexture4, smokeTexture5, smokeTexture6, smokeTexture7, smokeTexture8] timePerFrame: 0.0625] count: 1];
    return smoke;
}

-(void)jump {
    SKTexture* jumpTexture1 = [SKTexture textureWithImageNamed:@"player_jump1"];
    SKTexture* jumpTexture2 = [SKTexture textureWithImageNamed:@"player_jump2"];
    SKTexture* jumpTexture3 = [SKTexture textureWithImageNamed:@"player_jump3"];
    SKTexture* jumpTexture4 = [SKTexture textureWithImageNamed:@"player_jump4"];
    
    SKAction* _jump = [SKAction repeatAction:[SKAction animateWithTextures:@[jumpTexture1, jumpTexture2, jumpTexture3, jumpTexture4] timePerFrame: 0.1] count: 1];
    
    [_player removeAllActions];
    [_player.physicsBody applyImpulse:CGVectorMake(0, 900)];
    [_player runAction:_jump completion:^{
        [_player removeAllActions];
        [_player runAction:_run];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self jump];
    //[_player runAction:];
    //_player.physicsBody.velocity = CGVectorMake(0, 0);
//        [_player runAction: [SKAction stop] completion: ^{
//            [self removeChildrenInArray:@[_player]];
//            [self addChild:_smoke];
//            [_smoke runAction:[self _dissappear] completion:^{
//                [self performSelector:@selector(showPlayerAfterSmoke) withObject:nil afterDelay: 1.0];
//            }];
//        }];
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
