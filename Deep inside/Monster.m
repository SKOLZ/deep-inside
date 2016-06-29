//
//  Monster.m
//  Deep inside
//
//  Created by Gabriel Zanzotti on 6/28/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"
#import "textures.h"
#import "categories.h"
#import "MassRelation.h"

@implementation Monster
    +(instancetype)monsterWithPosition: (CGPoint) pos andTexture: (SKTexture *)texture {
        Monster* m = [[[self class] alloc] initWithTexture: texture];
        m.position = pos;
        m.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:m.frame.size];
        m.physicsBody.allowsRotation = NO;
        m.physicsBody.categoryBitMask = monsterCategory;
        m.physicsBody.contactTestBitMask = playerCategory;
        m.physicsBody.mass = MONSTER_MASS;
        return m;
    }
@end
