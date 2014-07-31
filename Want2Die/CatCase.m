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
@synthesize catView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        currentDirectionState = [self randomCatDefaultDirection];
        //新生猫的状态为kid，5秒钟以后随机男女
        catSexState = CatSexStateKid;
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(randomCatSexState) userInfo:nil repeats:NO];
        catView = [[UIImageView alloc]init];
        [self setCatImage];
        CGRect rect = self.frame;
        catView.frame = CGRectMake(rect.size.width/2-10, rect.size.height/2-10, 20, 20);
        [self addSubview:catView];
        [self addGestureRecognizer];
    }
    return self;
}
//设置猫图
-(void)setCatImage
{
    if (catSexState == CatSexStateMale &&currentDirectionState ==DirectionStateUP) {
        catView.image =  [UIImage imageNamed:@"upCat_Male"];
    }else if (catSexState == CatSexStateMale &&currentDirectionState ==DirectionStateDown) {
        catView.image =  [UIImage imageNamed:@"downCat_Male"];
    }else if (catSexState == CatSexStateMale &&currentDirectionState ==DirectionStateLeft) {
        catView.image =  [UIImage imageNamed:@"leftCat_Male"];
    }else if (catSexState == CatSexStateMale &&currentDirectionState ==DirectionStateRight) {
        catView.image =  [UIImage imageNamed:@"rightCat_Male"];
    }else if (catSexState == CatSexStateFemale &&currentDirectionState ==DirectionStateUP) {
        catView.image =  [UIImage imageNamed:@"upCat_Female"];
    }else if (catSexState == CatSexStateFemale &&currentDirectionState ==DirectionStateDown) {
        catView.image =  [UIImage imageNamed:@"downCat_Female"];
    }else if (catSexState == CatSexStateFemale &&currentDirectionState ==DirectionStateLeft) {
        catView.image =  [UIImage imageNamed:@"leftCat_Female"];
    }else if (catSexState == CatSexStateFemale &&currentDirectionState ==DirectionStateRight) {
        catView.image =  [UIImage imageNamed:@"rightCat_Female"];
    }
    else if (catSexState == CatSexStateKid) {
        catView.image =  [UIImage imageNamed:@"kidCat"];
    }
}

//返回随机方向
-(DirectionState)randomCatDefaultDirection
{

    switch (arc4random()%4) {
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
-(void)randomCatSexState
{

    int sexState = arc4random()%2;
    switch (sexState) {
        case 0:
            catSexState = CatSexStateMale;
            break;
        case 1:
            catSexState = CatSexStateFemale;
            break;
 
    }
    [self setCatImage];
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
    
    [self setCatImage];
}
@end
