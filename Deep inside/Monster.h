//
//  Monster.h
//  Deep inside
//
//  Created by Gabriel Zanzotti on 6/28/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Monster : SKSpriteNode

+(instancetype)monsterWithPosition: (CGPoint) pos andTexture: (SKTexture *)texture;
-(void)animate;

@end