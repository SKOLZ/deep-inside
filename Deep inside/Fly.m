//
//  Fly.m
//  Deep inside
//
//  Created by Agustin Pagnoni on 6/29/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Fly.h"
#include "Monster.h"
#include "textures.h"
#include "categories.h"


@implementation Fly

+(instancetype)initWithPos: (CGPoint) pos {
    Fly* f = [super monsterWithPosition: pos andTexture: FLY1];
    f.scale = 0.8;
    return f;
}

-(void)fly {
    SKAction* fly = [SKAction repeatActionForever:[SKAction animateWithTextures:@[FLY1, FLY2, FLY3, FLY4, FLY5, FLY6, FLY7, FLY8, FLY9, FLY10] timePerFrame: 0.1]];
    [self runAction: fly];
}
@end
