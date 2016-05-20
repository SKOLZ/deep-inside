//
//  GameScene.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/11/16.
//  Copyright (c) 2016 White Stone. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"
#import "textures.h"

#define PLAYER_INITIAL_Y GROUND_TEXTURE.size.height + _player.size.height / 2
#define DELTA 5
#define SCREEN_HALF_WIDTH [UIScreen mainScreen].bounds.size.width / 2

@interface GameScene () {
    Player* _player;
    SKColor* _skyColor;
    
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    // Create background color
    
    _skyColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self setBackgroundColor:_skyColor];
    
    // Create background
    
    SKAction* moveSkylineSprite = [SKAction moveByX:-BACKGROUND_TEXTURE.size.width y:0 duration:0.08 * BACKGROUND_TEXTURE.size.width];
    SKAction* resetSkylineSprite = [SKAction moveByX:BACKGROUND_TEXTURE.size.width y:0 duration:0];
    SKAction* moveSkylineSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkylineSprite, resetSkylineSprite]]];
    
    for( int i = 0; i < 2 + self.frame.size.width / ( BACKGROUND_TEXTURE.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:BACKGROUND_TEXTURE];
        [sprite setScale:0.8];
        sprite.zPosition = -20;
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
        [sprite runAction:moveSkylineSpritesForever];
        [self addChild:sprite];
    }
    
    // Create ground
    
    SKAction* moveGroundSprite = [SKAction moveByX:-GROUND_TEXTURE.size.width y:0 duration:0.015 * GROUND_TEXTURE.size.width];
    SKAction* resetGroundSprite = [SKAction moveByX:GROUND_TEXTURE.size.width y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for( int i = 0; i < 2 + self.frame.size.width / ( GROUND_TEXTURE.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:GROUND_TEXTURE];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height);
        [sprite runAction:moveGroundSpritesForever];
        [self addChild:sprite];
    }
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0, GROUND_TEXTURE.size.height - 5);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1)];
    dummy.physicsBody.dynamic = NO;
    
    [self addChild:dummy];
    
    // Create player
    
    _player = [Player playerWithPosition:CGPointMake(self.frame.size.width / 4, PLAYER_INITIAL_Y)];
    [_player run];
    [self addChild:_player];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (point.x < SCREEN_HALF_WIDTH && _player.state == PLAYER_RUNNING) {
        [_player jump];
    } else if (point.x > SCREEN_HALF_WIDTH && _player.state != PLAYER_DISAPPEARED) {
        [_player disappear];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    CGFloat a = PLAYER_INITIAL_Y;
    if (_player.position.y < PLAYER_INITIAL_Y && _player.state == PLAYER_JUMPING) {
        [_player run];
    }
    
}



@end
