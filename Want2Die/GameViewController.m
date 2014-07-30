//
//  GameViewController.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "GameViewController.h"
#import "CatCase.h"
#import "NSObject+Expansion.h"
#define WIDTH 20
#define MOVE_LEN 5

@interface GameViewController ()
{

    UIButton * beginButton;
//    CatCase *cat;

    NSTimer *timer;
    NSTimer *addCatTimer;
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
//开始
-(void)launchView
{
    beginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    beginButton.frame = CGRectMake(20, 20, 100, 40);
    [beginButton setTitle:@"开始" forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    [self addCat];
    [self addCat];
}
-(void)addCat
{
    //一定范围内的随机位置
    CGPoint catPoint = [self catDefaltLocation];
    //初始猫
    CatCase *cat = [[CatCase alloc]initWithFrame:CGRectMake(catPoint.x, catPoint.y, 100, 100)];
    cat.userInteractionEnabled = YES;
    
    [self.view addSubview:cat];
    [catArray addObject:cat];
    
}

//一定范围内的随机位置
-(CGPoint)catDefaltLocation
{
    //m + rand()%(n-m)
    CGPoint center = self.view.center;
    int minX = center.x-40;
    int maxX = center.x+40;
    int minY = center.y-40;
    int maxY = center.y+40;
    int catX = minX + [NSObject getRandomNumber]%(maxX-minX);
    int catY = minY + [NSObject getRandomNumber]%(maxY-minY);
    
    CGPoint catPoint= CGPointMake(catX, catY);
    return catPoint;
}
//开始按钮点击
- (void)beginButtonClick:(id)sender {
  
    static BOOL isPlaying = NO;
    beginButton.hidden = YES;
    beginButton.enabled = NO;
    if (!isPlaying) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(catMove) userInfo:nil repeats:YES];
        addCatTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(addCat) userInfo:nil repeats:YES];

    }
 
    isPlaying = !isPlaying;
}

//  定时器调用
-(void)catMove
{
    CatCase *cat;
    for (NSInteger i=0; i<[catArray count]; i++) {
        cat = [catArray objectAtIndex:i];
        CGPoint orign = cat.center;
        switch (cat.currentDirectionState) {
            case DirectionStateUP:
                cat.center = CGPointMake(orign.x, orign.y-MOVE_LEN);
                break;
            case DirectionStateDown:
                cat.center = CGPointMake(orign.x, orign.y+MOVE_LEN);
                break;
            case DirectionStateLeft:
                cat.center = CGPointMake(orign.x-MOVE_LEN, orign.y);
                break;
            case DirectionStateRight:
                cat.center = CGPointMake(orign.x+MOVE_LEN, orign.y);
            default:
                break;
        }
        //判断是否出边界
        [self isBeyondBorder:orign];
        [self catMeet];
    }
    
    
}
//判断两猫相遇
-(void)catMeet
{
    CatCase *cat1;
    CatCase *cat2;
  
    for (int i = 0; i<[catArray count]; i++) {
      
        for (int j = 1; j<[catArray count]; j++) {
            cat1 = [catArray objectAtIndex:i];
            cat2 = [catArray objectAtIndex:j];
            //判断性别
            if (cat1.catSexState!=cat2.catSexState) {
                CGRect rect1 = cat1.catView.frame;
                CGRect rect2 = cat2.catView.frame;
                BOOL ismeet = CGRectIntersectsRect(rect1,rect2);
                 NSLog(@"ifReadOnly value: %@" ,ismeet?@"YES":@"NO");
                if (ismeet) {
                    [catArray removeObject:cat2];
                    
                }
            }
        }
    }
}
//判断是否出边界
-(void)isBeyondBorder:(CGPoint)point
{
    int height = self.view.frame.size.height;

    if(point.x>320||point.x<0||point.y<90||point.y>(height-90))
    {
        [self failView];
        NSLog(@"x:%f  y:%f",point.x,point.y);
    }
    
}
// 失败
-(void)failView
{
    NSLog(@"失败");

    if ([timer isValid]) {
        [timer invalidate];
    }
    
    if ([addCatTimer isValid]) {
        [addCatTimer invalidate];
    }

}

@end
