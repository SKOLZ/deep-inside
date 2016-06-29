//
//  GameScene.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 5/11/16.
//  Copyright (c) 2016 White Stone. All rights reserved.
//

#import "GameScene.h"
#import "MenuScene.h"
#import "Player.h"
#import "Monster.h"
#import "Zombie.h"
#import "textures.h"
#import "categories.h"

#define PLAYER_INITIAL_Y GROUND_TEXTURE.size.height + _player.size.height / 2
#define DELTA 5
#define SCREEN_WIDTH self.frame.size.width
#define SCREEN_HALF_WIDTH self.frame.size.width / 2
#define FIXED_PLAYER_POS_X self.frame.size.width / 4
#define CYCLES_WAIT_RANGE 200
#define CYCLES_MIN_WAIT 50
#define CYCLES_WAIT_RANGE_ZOMBIE 100
#define CYCLES_MIN_WAIT_ZOMBIE 30



@interface GameScene () <SKPhysicsContactDelegate> {
    Player* _player;
    SKColor* _skyColor;
    SKAction* _moveGroundSpritesForever;
    int _floaters_cooldown;
    int _zombies_cooldown;
    SKLabelNode* heartLabel;
    int hearts;
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.physicsWorld.contactDelegate = self;
    hearts = 0;
    _floaters_cooldown = -1; // 2 seconds
    _zombies_cooldown = -1;
    // Create background color
    
    _skyColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self setBackgroundColor:_skyColor];
    
    // Create background
    
    SKAction* moveSkylineSprite = [SKAction moveByX:-BACKGROUND_TEXTURE.size.width y:0 duration:0.02 * BACKGROUND_TEXTURE.size.width];
    SKAction* resetSkylineSprite = [SKAction moveByX:(BACKGROUND_TEXTURE.size.width - 5) y:0 duration:0];
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
    
    SKAction* moveGroundSprite = [SKAction moveByX:-GROUND_TEXTURE.size.width y:0 duration:0.003 * GROUND_TEXTURE.size.width];
    SKAction* resetGroundSprite = [SKAction moveByX:GROUND_TEXTURE.size.width y:0 duration:0];
    _moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];

    for( int i = 0; i < 2 + self.frame.size.width / ( GROUND_TEXTURE.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:GROUND_TEXTURE];
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height);
        [sprite runAction:_moveGroundSpritesForever];
        [self addChild:sprite];
    }
    
    // Create ground physics container
    
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(SCREEN_HALF_WIDTH, GROUND_TEXTURE.size.height - 5);
    dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(SCREEN_WIDTH, 1)];
    dummy.physicsBody.dynamic = NO;
    dummy.physicsBody.categoryBitMask = floorCategory;
    dummy.physicsBody.contactTestBitMask = playerCategory;
    
    [self addChild:dummy];
    
    // Create player
    
    _player = [Player playerWithPosition: CGPointMake(FIXED_PLAYER_POS_X, PLAYER_INITIAL_Y)];
    [_player run];
    [self addChild:_player];
    
    // Create exit button
    
    SKSpriteNode* exitButton = [SKSpriteNode spriteNodeWithTexture:EXIT_TEXTURE];
    exitButton.position = CGPointMake(self.frame.size.width - exitButton.size.width, self.frame.size.height - 2 * exitButton.size.height);
    exitButton.name = @"exit";
    exitButton.zPosition = 1.0;
    [self addChild: exitButton];
    
    // Create heart counter icon
    
    SKSpriteNode* heartIcon = [SKSpriteNode spriteNodeWithTexture:HEART_ICON];
    heartIcon.position = CGPointMake(heartIcon.size.width/2 + 20, self.frame.size.height - 2 * heartIcon.size.height - 20);
    heartIcon.zPosition = 1.0;
    [self addChild: heartIcon];
    
    // Create heart counter label
    
    SKSpriteNode *heartLabelWrapper = [[SKSpriteNode alloc] init];//parent
    heartLabelWrapper.zPosition = 1.0;
    
    heartLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
    heartLabel.text = [NSString stringWithFormat:@"%d", hearts];
    heartLabel.fontSize = 36;
    heartLabel.fontColor = [SKColor whiteColor];
    heartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    heartLabel.position = CGPointMake(0, 0);
    
    [heartLabelWrapper addChild:heartLabel];
    heartLabelWrapper.anchorPoint = CGPointMake(1.0,1.0);
    heartLabelWrapper.position = CGPointMake(heartIcon.size.width/2 + 70, self.frame.size.height - 2 * heartIcon.size.height - 35);
    
    [self addChild:heartLabelWrapper];
}

-(void)goToMenu {
    MenuScene *menuScene = [MenuScene nodeWithFileNamed:@"MenuScene"];
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:menuScene transition:transition];
}

-(void)goToFinishGame:(BOOL)won {
    if (!won) {
//        GameOverScene *gameOverScene = [GameOverScene nodeWithFileNamed:@"GameOverScene"];
//        gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
//        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
//        [self.view presentScene:gameOverScene transition:transition];
        [self goToMenu];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    
    if ([node.name isEqualToString:@"exit"]) {
        [self goToMenu];
    } else {
        if (point.x < SCREEN_HALF_WIDTH && _player.state == PLAYER_RUNNING) {
            [_player jump];
        } else if (point.x > SCREEN_HALF_WIDTH && _player.state != PLAYER_DISAPPEARED) {
            [_player disappear];
        }
    }
}

-(void)spawnFloatGround {
    // ***** Decision making
    
    if  (_floaters_cooldown < 0) {
        _floaters_cooldown = (arc4random() % CYCLES_WAIT_RANGE) + CYCLES_MIN_WAIT; // +1 to avoid double instant spawn
    } else return;
    
    // ***** Ok to spawn, keep going
    
    int random_width = (2 + arc4random_uniform(3)) * 100;
    SKSpriteNode* random_block = [SKSpriteNode spriteNodeWithTexture:GRASS_PLATFORM size:CGSizeMake(random_width, 50)];
    random_block.position = CGPointMake(SCREEN_WIDTH * 1.1, PLAYER_INITIAL_Y * 2.5);
    random_block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(random_width * 0.84, 20)];
    random_block.physicsBody.affectedByGravity = NO;
    random_block.physicsBody.dynamic = NO;
    random_block.physicsBody.categoryBitMask = floorCategory;
    random_block.physicsBody.contactTestBitMask = playerCategory;
    [random_block runAction:_moveGroundSpritesForever];
    [self addChild:random_block];
    [self performSelector: @selector(killFloatGround:) withObject: random_block afterDelay: 4];
}

-(void)killFloatGround:(SKSpriteNode*) floatingGround {
    [self removeChildrenInArray:[NSArray arrayWithObject:floatingGround]];
}

-(void)spawnMonster {
    // ***** Decision making
    
    if  (_zombies_cooldown < 0) {
        _zombies_cooldown = (arc4random() % CYCLES_WAIT_RANGE_ZOMBIE) + CYCLES_MIN_WAIT_ZOMBIE;
    } else return;
    
    // ***** Ok to spawn, keep going
    
    // Create sprite
    
    Zombie* monster = [Zombie initWithPos:CGPointMake(SCREEN_WIDTH * 1.1, PLAYER_INITIAL_Y)];
    
    // Create the monster slightly off-screen along the right edge,
    [monster walk];
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, PLAYER_INITIAL_Y) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

-(void)update:(NSTimeInterval)currentTime {
    [self spawnFloatGround];
    [self spawnMonster];
    [self applyCountdowns];
}

-(void)applyCountdowns {
    _zombies_cooldown--;
    _floaters_cooldown--;
}

- (void)didSimulatePhysics {
    
    CGPoint fixedXPos = _player.position;
    fixedXPos.x = FIXED_PLAYER_POS_X;
    
    [_player setPosition:fixedXPos];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // **** Possible contacts begin
    
    // Player hits floor
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & floorCategory) != 0) {
        if (_player.state != PLAYER_DISAPPEARED) {
            [_player run];
        }
    }
    // Player hits monster
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & monsterCategory) != 0) {
        if (_player.state != PLAYER_DISAPPEARED) {
            [self goToFinishGame:NO];
        }
    }
    
}

@end
