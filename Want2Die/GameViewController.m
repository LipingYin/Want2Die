//
//  GameViewController.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "GameViewController.h"
#import "CatCase.h"
#define WIDTH 20
#define MOVE_LEN 5

@interface GameViewController ()
{
    UIView * baseView;
    UIButton * beginButton;
    CatCase *cat;
    NSTimer * timer;
    NSMutableArray *catArray;
    

}
@end

@implementation GameViewController
#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //存放猫
        catArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self launchView];
}
#pragma mark - UI
//开始
-(void)launchView
{
    beginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    beginButton.frame = CGRectMake(20, 20, 100, 40);
    [beginButton setTitle:@"开始" forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    
    //初始猫
    cat = [[CatCase alloc]init];
    cat.frame = CGRectMake(100, 250, 20, 20);
    
    [self.view addSubview:cat];


}
//开始按钮点击
- (void)beginButtonClick:(id)sender {
  
    static BOOL isPlaying = NO;
    beginButton.hidden = YES;
    beginButton.enabled = NO;
    if (!isPlaying) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(catMove) userInfo:nil repeats:YES];
    }
    else{
            if ([timer isValid]) {
                [timer invalidate];
            }
    }
    isPlaying = !isPlaying;
}

//  定时器调用
-(void)catMove
{
    CGPoint orign = cat.center;
    switch (cat.currentDirectionState) {
        case DirectionStateUP:
            cat.center = CGPointMake(orign.x+ MOVE_LEN, orign.y);

            break;
        case DirectionStateDown:
            break;
        case DirectionStateLeft:
    
            break;
        case DirectionStateRight:
          
        default:
            break;
    }

    
//    for (int i = [tailArray count]-1; i >= 0; i--) {
//        UIImageView * tail = [tailArray objectAtIndex:i];
//        if (i == 0) {
//            tail.center = orign;
//            
//        }else{
//            UIImageView * prevTail = [tailArray objectAtIndex:i-1];
//            tail.center = CGPointMake(prevTail.center.x, prevTail.center.y);
//        }
//    }
//    
//    CGRect headRect = CGRectMake(head.frame.origin.x, head.frame.origin.y, head.frame.size.width, head.frame.size.height);
//    CGRect fruitRect = CGRectMake(fruit.frame.origin.x, fruit.frame.origin.y, fruit.frame.size.width, fruit.frame.size.height);
//    
//    if ([self isRectsInteract:headRect other:fruitRect]) {
//        
//        [self changeFruitLocation];
//        [self addTail];
//    }
//    else if ([self isSnakeTouchItself]) {
//        [self reStartGame];
//    }
//    
//    [self isSnakeBeyongdBounce];
    
    
    
}


-(NSUInteger)getCurrentTime
{
    NSDate * startDate = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
    NSSecondCalendarUnit | NSDayCalendarUnit  |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    NSUInteger second = [cps second];
    return second;
}


@end
