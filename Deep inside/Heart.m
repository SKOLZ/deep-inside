//
//  Heart.m
//  Deep inside
//
//  Created by Agustin Pagnoni on 6/30/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Heart.h"
#import "textures.h"
#import "categories.h"

#define HEIGHT_REDUCTION 0.9
#define WIDTH_REDUCTION 0.9

@implementation Heart
+(instancetype)initWithPos: (CGPoint) pos {
    Heart* m = [[Heart alloc] initWithTexture: HEART1];
    m.position = CGPointMake(pos.x, pos.y);
    m.physicsBody = [SKPhysicsBody
                     bodyWithRectangleOfSize:CGSizeMake(m.frame.size.width * WIDTH_REDUCTION, m.frame.size.height * HEIGHT_REDUCTION)
                     center:CGPointMake(0, - m.frame.size.height * 0.5 * (1- HEIGHT_REDUCTION))
                     ];
    m.physicsBody.dynamic = NO;
    m.physicsBody.allowsRotation = NO;
    m.physicsBody.affectedByGravity = NO;
    m.physicsBody.categoryBitMask = heartCategory;
    m.physicsBody.contactTestBitMask = playerCategory;
    m.physicsBody.collisionBitMask = 0xFFFFFFFF;
    m.scale = 0.7;
    return m;
}

-(void)animate {
    SKAction* animation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[HEART1, HEART2, HEART3, HEART4, HEART5, HEART6, HEART7] timePerFrame: 0.1428]];
    [self runAction: animation];
}
@end