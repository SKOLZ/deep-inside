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

#define HEIGHT_REDUCTION 0.7

@implementation Monster
    +(instancetype)monsterWithPosition: (CGPoint) pos andTexture: (SKTexture *)texture {
        Monster* m = [[[self class] alloc] initWithTexture: texture];
        m.position = CGPointMake(pos.x, pos.y * HEIGHT_REDUCTION);
        m.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(m.frame.size.width * 0.9, m.frame.size.height * HEIGHT_REDUCTION)];
        m.physicsBody.dynamic = YES;
        m.physicsBody.allowsRotation = NO;
        m.physicsBody.categoryBitMask = monsterCategory;
        m.physicsBody.contactTestBitMask = playerCategory | floorCategory;
        m.physicsBody.mass = MONSTER_MASS;
        return m;
    }
@end
