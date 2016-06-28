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

@implementation Monster
    +(instancetype)monsterWithPosition: (CGPoint) pos andTexture: (SKTexture *)texture {
        Monster* m = [[Monster alloc] initWithTexture: texture];
        m.position = pos;
        m.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:m.frame.size];
        m.physicsBody.categoryBitMask = monsterCategory;
        m.physicsBody.contactTestBitMask = playerCategory;
        return m;
    }
@end
