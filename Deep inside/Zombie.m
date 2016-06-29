//
//  Zombie.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 6/28/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Zombie.h"
#include "Monster.h"
#include "textures.h"
#include "categories.h"


@implementation Zombie

+(instancetype)monsterWithPosition: (CGPoint) pos {
    
    Zombie* m = [super monsterWithPosition: pos andTexture: ZOMBIE1];
    m.position = pos;
    m.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:m.frame.size];
    m.physicsBody.categoryBitMask = monsterCategory;
    m.physicsBody.contactTestBitMask = playerCategory;
    return m;
}

-(void)walk {
    SKAction* walk = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ZOMBIE1, ZOMBIE2, ZOMBIE3, ZOMBIE4, ZOMBIE5] timePerFrame: 0.2]];
    [self runAction: walk];
}
@end