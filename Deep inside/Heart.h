
//
//  Heart.h
//  Deep inside
//
//  Created by Agustin Pagnoni on 6/30/16.
//  Copyright © 2016 White Stone. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>

@interface Heart : SKSpriteNode

+(Heart*)initWithPos: (CGPoint) pos;
-(void)animate;

@end