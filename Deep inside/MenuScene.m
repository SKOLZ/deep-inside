#import "MenuScene.h"
#import "textures.h"
#import "GameScene.h"
#import "Music.h"

@interface MenuScene () {
    AVPlayer *mediaPlayer;
}
@end

@implementation MenuScene

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor blackColor];
    
    mediaPlayer = [[AVPlayer alloc] initWithPlayerItem: MENU_MUSIC];
    [mediaPlayer play];
    
    mediaPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[mediaPlayer currentItem]];
    
    // create menu background
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithTexture:MENU_BACKGROUND_TEXTURE1];
    background.scale = 2.4;
    background.zPosition = -20;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    SKAction* bgAnim = [SKAction repeatActionForever:[SKAction animateWithTextures:@[
        MENU_BACKGROUND_TEXTURE1,
        MENU_BACKGROUND_TEXTURE2,
        MENU_BACKGROUND_TEXTURE3,
        MENU_BACKGROUND_TEXTURE4,
        MENU_BACKGROUND_TEXTURE5,
        MENU_BACKGROUND_TEXTURE6,
        MENU_BACKGROUND_TEXTURE7,
        MENU_BACKGROUND_TEXTURE8,
        MENU_BACKGROUND_TEXTURE9,
        MENU_BACKGROUND_TEXTURE10,
        MENU_BACKGROUND_TEXTURE11,
        MENU_BACKGROUND_TEXTURE12,
        MENU_BACKGROUND_TEXTURE13,
        MENU_BACKGROUND_TEXTURE14,
        MENU_BACKGROUND_TEXTURE15,
        MENU_BACKGROUND_TEXTURE16
    ] timePerFrame: 0.07]];
    [background runAction: bgAnim];
    [self addChild:background];
    
    // create game logo
    
    SKSpriteNode* logo = [SKSpriteNode spriteNodeWithTexture:LOGO];
    logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    [self addChild:logo];
    
    // create play button
    SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithTexture:PLAY];
    playButton.position = CGPointMake(CGRectGetMidX(self.frame) - 150, CGRectGetMidY(self.frame) - 150);
    playButton.name = @"play";
    playButton.zPosition = 1.0;
    [self addChild: playButton];
    
    // create exit button
    SKSpriteNode* quitButton = [SKSpriteNode spriteNodeWithTexture:QUIT];
    quitButton.position = CGPointMake(CGRectGetMidX(self.frame) + 150, CGRectGetMidY(self.frame) - 150);
    quitButton.name = @"quit";
    quitButton.zPosition = 1.0;
    [self addChild: quitButton];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    
    if ([node.name isEqualToString:@"play"]) {
        [self playGame];
    } else if ([node.name isEqualToString:@"quit"]) {
        [self quit];
    }

}

-(void)playGame {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *fadeOut = [SKTransition fadeWithDuration:0.5];
    // Present the scene.
    [skView presentScene:scene transition:fadeOut];
}

-(void)quit {
    exit(0);
}

-(void)update:(NSTimeInterval)currentTime {

}

@end
