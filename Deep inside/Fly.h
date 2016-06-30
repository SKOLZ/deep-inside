//
//  Fly.h
//  Deep inside
//
//  Created by Agustin Pagnoni on 6/29/16.
//  Copyright © 2016 White Stone. All rights reserved.
//

#import "Monster.h"

@interface Fly : Monster

+(Fly*)initWithPos: (CGPoint) pos;
-(void)fly;

@end
