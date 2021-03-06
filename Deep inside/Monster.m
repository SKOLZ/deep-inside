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

#define HEIGHT_REDUCTION 0.8
#define WIDTH_REDUCTION 0.7

@implementation Monster
    +(instancetype)monsterWithPosition: (CGPoint) pos andTexture: (SKTexture *)texture {
        Monster* m = [[[self class] alloc] initWithTexture: texture];
        m.position = CGPointMake(pos.x, pos.y);
        m.physicsBody = [SKPhysicsBody
                         bodyWithRectangleOfSize:CGSizeMake(m.frame.size.width * WIDTH_REDUCTION, m.frame.size.height * HEIGHT_REDUCTION)
                         center:CGPointMake(0, - m.frame.size.height * 0.5 * (1- HEIGHT_REDUCTION))
                        ];
        m.physicsBody.dynamic = NO;
        m.physicsBody.allowsRotation = NO;
        m.physicsBody.affectedByGravity = NO;
        m.physicsBody.categoryBitMask = monsterCategory;
        m.physicsBody.contactTestBitMask = playerCategory | floorCategory;
        return m;
    }

-(void)animate {
}
@end
