//
//  CatCase.h
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DirectionState)
{
    DirectionStateUP =0,
    DirectionStateDown,
    DirectionStateLeft,
    DirectionStateRight
};

typedef NS_ENUM(NSInteger, CatSexState)
{
    CatSexStateMale=0,
    CatSexStateFemale
};
typedef struct Cat
{
    NSInteger x;
    NSInteger y;
}__cat;
@interface CatCase : UIView
{
    UIImageView *catView;
    DirectionState currentDirectionState;
    CatSexState catSexState;
}
@property (nonatomic)DirectionState currentDirectionState;
@property (nonatomic) CatSexState catSexState;
-(void)catMoveUp;
-(void)catMoveDown;
-(void)catMoveLeft;
-(void)catMoveRight;
-(DirectionState)catDefaultDirection;
-(CatSexState)catSexState;
@end
