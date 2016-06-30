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
#import "Fly.h"
#import "Heart.h"
#import "Zombie.h"
#import "textures.h"
#import "categories.h"
#import "Music.h"

#define PLAYER_INITIAL_Y GROUND_TEXTURE.size.height + _player.size.height / 2
#define DELTA 5
#define SCREEN_WIDTH self.frame.size.width
#define SCREEN_HALF_WIDTH self.frame.size.width / 2
#define FIXED_PLAYER_POS_X self.frame.size.width / 4
#define CYCLES_WAIT_RANGE 200
#define CYCLES_MIN_WAIT 50
#define CYCLES_WAIT_RANGE_HEART 200
#define CYCLES_MIN_WAIT_HEART 100
#define CYCLES_WAIT_RANGE_ZOMBIE 100
#define CYCLES_MIN_WAIT_ZOMBIE 30
#define DISSAPPEAR_COOLDOWN 60
#define MUSIC_TRACK_SIZE 5
#define MIN_DURATION 3
#define INITIAL_DURATION 6


@interface GameScene () <SKPhysicsContactDelegate> {
    Player* _player;
    SKColor* _skyColor;
    int _floaters_cooldown;
    int _monsters_cooldown;
    int _hearts_cooldown;
    int _dissappear_cooldown;
    SKLabelNode* heartLabel;
    int _hearts;
    NSInteger currentSoundsIndex;
    AVPlayer *mediaPlayer;
    NSMutableArray<AVPlayerItem *> *soundList;
    BOOL lost;
    int _difficulty;
    int _score;
}
@end

@implementation GameScene

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    currentSoundsIndex++;
    if (currentSoundsIndex == MUSIC_TRACK_SIZE) {
        currentSoundsIndex = 0;
    }
    [self playNextAudio];
}

- (void)playNextAudio {
    [mediaPlayer replaceCurrentItemWithPlayerItem:[soundList objectAtIndex:currentSoundsIndex]];
    [mediaPlayer play];
    mediaPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[mediaPlayer currentItem]];
}

-(void)didMoveToView:(SKView *)view {
    currentSoundsIndex = 0;
    soundList = [NSMutableArray arrayWithObjects: TRACK1, TRACK2, TRACK3, TRACK4, TRACK5, nil];

    NSUInteger count = [soundList count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        unsigned long nElements = count - i;
        unsigned long n = (arc4random() % nElements) + i;
        [soundList exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    mediaPlayer = [[AVPlayer alloc] init];
    [self playNextAudio];

    self.physicsWorld.contactDelegate = self;
    _hearts = 0;
    _floaters_cooldown = -1; // 2 seconds
    _monsters_cooldown = -1;
    _hearts_cooldown = arc4random() % CYCLES_WAIT_RANGE_HEART + CYCLES_MIN_WAIT_HEART;
    _dissappear_cooldown = -1;
    _difficulty = 1;
    _score = 0;
    // Create background color

    _skyColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self setBackgroundColor:_skyColor];

    // Create background

    SKAction* moveSkylineSprite = [SKAction moveByX:-BACKGROUND_TEXTURE.size.width/2 y:0 duration:0.02 * BACKGROUND_TEXTURE.size.width];
    SKAction* resetSkylineSprite = [SKAction moveByX:BACKGROUND_TEXTURE.size.width/2 y:0 duration:0];
    SKAction* _moveSkylineSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkylineSprite, resetSkylineSprite]]];

    for( int i = 0; i < 2 + self.frame.size.width / ( BACKGROUND_TEXTURE.size.width ); i++ ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:BACKGROUND_TEXTURE size: self.frame.size];
        sprite.zPosition = -20;
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
        [sprite runAction: _moveSkylineSpritesForever];
        [self addChild:sprite];
    }

    // Create ground

    SKAction* moveGroundSprite = [SKAction moveByX:-GROUND_TEXTURE.size.width y:0 duration:0.003 * GROUND_TEXTURE.size.width];
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

    heartLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [self updateHeartLabel];
    heartLabel.fontSize = 36;
    heartLabel.fontColor = [SKColor whiteColor];
    heartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    heartLabel.position = CGPointMake(0, 0);

    [heartLabelWrapper addChild:heartLabel];
    heartLabelWrapper.anchorPoint = CGPointMake(1.0,1.0);
    heartLabelWrapper.position = CGPointMake(heartIcon.size.width/2 + 70, self.frame.size.height - 2 * heartIcon.size.height - 35);

    [self addChild:heartLabelWrapper];
}

-(void)updateHeartLabel {
    heartLabel.text = [NSString stringWithFormat:@"%d", _hearts];
}

-(void)goToMenu {
    MenuScene *menuScene = [MenuScene nodeWithFileNamed:@"MenuScene"];
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fadeOut = [SKTransition fadeWithDuration:2];
    self.view.ignoresSiblingOrder = YES;
    [mediaPlayer pause];
    [self.view presentScene:menuScene transition:fadeOut];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];

    if ([node.name isEqualToString:@"exit"]) {
        [self goToMenu];
    } else {
        if (_player.state != PLAYER_DEAD) {
            if (point.x < SCREEN_HALF_WIDTH && _player.state == PLAYER_RUNNING) {
                [_player jump];
            } else if (point.x > SCREEN_HALF_WIDTH && _player.state != PLAYER_DISAPPEARED) {
                if (_dissappear_cooldown < 0) {
                    [_player disappear];
                    _dissappear_cooldown = DISSAPPEAR_COOLDOWN;
                }
            }
        }
    }
}

-(void)spawnFloatGround {
    int random_width = (2 + arc4random_uniform(3)) * 100;
    SKSpriteNode* random_block = [SKSpriteNode spriteNodeWithTexture:GRASS_PLATFORM size:CGSizeMake(random_width, 50)];
    random_block.position = CGPointMake(SCREEN_WIDTH + GRASS_PLATFORM.size.width, PLAYER_INITIAL_Y * 2.5);
    random_block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(random_width * 0.84, 20)];
    random_block.physicsBody.affectedByGravity = NO;
    random_block.physicsBody.dynamic = NO;
    random_block.physicsBody.categoryBitMask = floorCategory;
    random_block.physicsBody.contactTestBitMask = playerCategory;
    
    [self spawnGeneric:random_block cooldown:&_floaters_cooldown cycleMinWait:CYCLES_MIN_WAIT cycleRangeWait:CYCLES_WAIT_RANGE];
}

-(void)spawnGeneric:(SKSpriteNode*)node cooldown:(int*)cooldown cycleMinWait:(int)minWait cycleRangeWait:(int)rangeWait {
    // ***** Decision making
    
    if  (*cooldown < 0) {
        *cooldown = (arc4random() % rangeWait) + minWait;
    } else return;
    
    // ***** Ok to spawn, keep going
    
    int actualDuration = MAX(MIN_DURATION, INITIAL_DURATION - 0.2 * _difficulty);
    SKAction* moveRandomBlock = [SKAction moveToX:-node.size.width duration: actualDuration];
    SKAction* removeBlock = [SKAction removeFromParent];
    [node runAction:[SKAction sequence:@[moveRandomBlock, removeBlock]]];
    [self addChild:node];
}

-(Monster*)newMonster {
    Monster* monster;
    if (arc4random() % 3 >= 2) {
        monster = [Fly initWithPos:CGPointMake(SCREEN_WIDTH * 1.1, PLAYER_INITIAL_Y * 4)];
    } else {
        monster = [Zombie initWithPos:CGPointMake(SCREEN_WIDTH * 1.1, PLAYER_INITIAL_Y)];
    }
    [monster animate];
    return monster;
}

-(Heart*)newHeart {
    float random_height = ((arc4random() % 3)/2 * PLAYER_INITIAL_Y) + PLAYER_INITIAL_Y;
    Heart* heart = [Heart initWithPos:CGPointMake(SCREEN_WIDTH * 1.1, random_height * 0.8)];
    [heart animate];
    return heart;
}

-(void)update:(NSTimeInterval)currentTime {
    [self setGameScore];
    // Spawn stuff begin
    
    [self spawnFloatGround];
    [self spawnGeneric:[self newMonster] cooldown:&_monsters_cooldown cycleMinWait:CYCLES_MIN_WAIT_ZOMBIE cycleRangeWait:CYCLES_WAIT_RANGE_ZOMBIE];
    [self spawnGeneric:[self newHeart] cooldown:&_hearts_cooldown cycleMinWait:CYCLES_MIN_WAIT_HEART cycleRangeWait:CYCLES_WAIT_RANGE_HEART];
    
    // Spawn stuff end
    [self applyCountdowns];
}

-(void)setGameScore {
    _score += 1;
    if (_score > 200 * _difficulty) {
        _difficulty += 1;
    }
//    NSLog(@"difficulty: %i, score: %i", _difficulty, _score);
}

-(void)applyCountdowns {
    _monsters_cooldown--;
    _floaters_cooldown--;
    _hearts_cooldown--;
    _dissappear_cooldown--;
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
        if (_player.state != PLAYER_DISAPPEARED && _player.state != PLAYER_DEAD) {
            [_player run];
        }
    }
    // Player hits monster
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & monsterCategory) != 0) {
        if (_player.state != PLAYER_DISAPPEARED) {
            [_player die];
            [self performSelector:@selector(goToMenu) withObject:nil afterDelay:1.5];
        }
    }
    
    // Player hits heart
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & heartCategory) != 0) {
        if (_player.state != PLAYER_DISAPPEARED) {
            [secondBody.node removeFromParent];
            _hearts += 1;
            [self updateHeartLabel];
        }
    }

}

@end
