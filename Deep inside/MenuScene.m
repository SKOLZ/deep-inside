#import "MenuScene.h"
#import "textures.h"
#import "GameScene.h"

@interface MenuScene () {
}
@end

@implementation MenuScene

-(void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor blackColor];
    
    // create menu background
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithTexture:MENU_BACKGROUND_TEXTURE];
    background.scale = 0.9;
    background.zPosition = -20;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    // create game logo
    
    SKSpriteNode* logo = [SKSpriteNode spriteNodeWithTexture:LOGO];
    logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 150);
    [self addChild:logo];
    
    // create play button
    SKSpriteNode* playButton = [SKSpriteNode spriteNodeWithTexture:PLAY];
    playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    playButton.name = @"play";
    playButton.zPosition = 1.0;
    [self addChild: playButton];
    
    // create exit button
    SKSpriteNode* quitButton = [SKSpriteNode spriteNodeWithTexture:QUIT];
    quitButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150);
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
    
    // Create and configure the scene.
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void)quit {
    exit(0);
}

-(void)update:(NSTimeInterval)currentTime {

}

@end
