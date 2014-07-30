//
//  CatCase.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "CatCase.h"
#import "NSObject+Expansion.h"
@implementation CatCase
@synthesize catSexState;
@synthesize currentDirectionState;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        currentDirectionState = [self catDefaultDirection];
        catSexState = [self catSexState];
        if (catSexState == CatSexStateMale) {
            catView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"maleCat"]];
        }else
        {
            catView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"femaleCat"]];
        }
        
        CGRect rect = self.frame;
        catView.frame = CGRectMake(rect.size.width/2-10, rect.size.height/2-10, 20, 20);
        [self addSubview:catView];
        [self addGestureRecognizer];
    }
    return self;
}

//返回随机方向
-(DirectionState)catDefaultDirection
{

    switch ([NSObject getRandomNumber]%4) {
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

    int sexState = [NSObject getRandomNumber]%2;
    switch (sexState) {
        case 0:
            catSexState = CatSexStateMale;
            break;
        case 1:
            catSexState = CatSexStateFemale;
            break;
            
          
    }
      return catSexState;
}

//给猫添加手势
-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:recognizer];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp)
    {
        self.currentDirectionState = DirectionStateUP;
    }else if(recognizer.direction==UISwipeGestureRecognizerDirectionDown)
    {
        self.currentDirectionState = DirectionStateDown;
    }else if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        self.currentDirectionState = DirectionStateLeft;
    }
    else if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        self.currentDirectionState = DirectionStateRight;
    }
}
@end
