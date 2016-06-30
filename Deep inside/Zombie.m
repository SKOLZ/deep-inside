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

+(instancetype)initWithPos: (CGPoint) pos {
    return [super monsterWithPosition: pos andTexture: ZOMBIE1];
}

-(void)animate {
    SKAction* walk = [SKAction repeatActionForever:[SKAction animateWithTextures:@[ZOMBIE1, ZOMBIE2, ZOMBIE3, ZOMBIE4, ZOMBIE5] timePerFrame: 0.2]];
    [self runAction: walk];
}
@end
