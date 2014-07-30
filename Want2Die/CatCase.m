//
//  CatCase.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "CatCase.h"

@implementation CatCase
@synthesize catSexState;
@synthesize currentDirectionState;
-(id)init
{
    self = [super init];
    if (self) {
       
        catView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cat"]];
        catView.frame = self.frame;
        [self addSubview:catView];
         currentDirectionState = [self catDefaultDirection];
        catSexState = [self catSexState];
    }
    return self;
}
//返回随机方向
-(DirectionState)catDefaultDirection
{
    
    switch (rand()%4) {
        case 0:
            currentDirectionState = DirectionStateUP;
            break;
        case 1:
            currentDirectionState = DirectionStateDown;
            break;
        case 2:
            currentDirectionState = DirectionStateLeft;
            break;
        case 3:
            currentDirectionState = DirectionStateRight;
            break;
        default:
            break;
    }
    
    return currentDirectionState;
}
//返回随机性别
-(CatSexState)catSexState
{
    switch (rand()%2) {
        case 0:
            catSexState = CatSexStateMale;
            break;
        case 1:
            catSexState = CatSexStateFemale;
            break;
            
          
    }
      return catSexState;
}
-(void)catMoveUp
{

}
-(void)catMoveDown
{

}
-(void)catMoveLeft
{

}
-(void)catMoveRight
{

}
@end
