//
//  GameViewController.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "GameViewController.h"
#import "CatCase.h"
#import "YouMiView.h"
#import "DXAlertView.h"
#define WIDTH 20
#define MOVE_LEN 5

#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)-(isIOS7?0:20)
#define TOP_BAR_HEIGHT (isIOS7?[UIApplication sharedApplication].statusBarFrame.size.height+44.0:44.0)
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


@interface GameViewController ()
{
    UIButton * beginButton;
    NSTimer *moveTimer;
    NSTimer *addCatTimer;
    NSTimer *gameTimer;
    NSMutableArray *catArray;
    
    int maleCatCount;
    int femaleCatCount;
    int kidCatCount;
    
    int grade;//游戏等级
    float catMoveTime;//猫移动时间
    int addCatTime;//增加猫的间隔
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
        maleCatCount=0;
        femaleCatCount=0;
        
        grade = 1;
        catMoveTime = 0.08;
        addCatTime = 4;
        
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
    
 //   [self addAd];
    [self launchView];
}

//广告条显示
-(void)addAd
{
    YouMiView *adView320x50=[[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:self];
    adView320x50.frame = CGRectMake(0, 0, CGRectGetWidth(adView320x50.bounds), CGRectGetHeight(adView320x50.bounds));
    adView320x50.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    adView320x50.tag = 301;
    [adView320x50 start];
    
    [self.view addSubview:adView320x50];
}
//开始
-(void)launchView
{
    self.view.backgroundColor =RGB(234, 134, 48);
    
    beginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    beginButton.frame = CGRectMake(20, 20, 100, 40);
    [beginButton setTitle:@"开始" forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    
    //初始一家人
    [self addCatFamliy];
}
-(void)addCatFamliy
{

    CatCase *cat = [[CatCase alloc]initWithFrame:CGRectMake(25,80, 120, 120) andSex:CatSexStateMale];
    CatCase *cat2 = [[CatCase alloc]initWithFrame:CGRectMake(25+90,80+30, 90, 90) andSex:CatSexStateKid];
    CatCase *cat3 = [[CatCase alloc]initWithFrame:CGRectMake(25+150,80, 120, 120) andSex:CatSexStateFemale];
    [self.view addSubview:cat];
    [catArray addObject:cat];
    
    [self.view addSubview:cat2];
    [catArray addObject:cat2];
    
    [self.view addSubview:cat3];
    [catArray addObject:cat3];
}


-(void)addCat
{
    //一定范围内的随机位置
    CGPoint catPoint = [self randomCatDefaltLocation];
    //初始猫
    CatCase *cat = [[CatCase alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    cat.center = catPoint;
    cat.userInteractionEnabled = YES;
    [self.view addSubview:cat];
    [catArray addObject:cat];
}

//一定范围内的随机位置
-(CGPoint)randomCatDefaltLocation
{
    //m + rand()%(n-m)
//    CGPoint center = self.view.center;
    int minX = 45;
    int maxX = self.view.frame.size.width-45;
    int minY = 45;
    int maxY = self.view.frame.size.height-45;
    int catX = minX + arc4random()%(maxX-minX);
    int catY = minY + arc4random()%(maxY-minY);
    
    CGPoint catPoint= CGPointMake(catX, catY);
    return catPoint;
}

//开始按钮点击
- (void)beginButtonClick{
  

    beginButton.hidden = YES;
    beginButton.enabled = NO;

    [UIView animateWithDuration:1 animations:^{   //新封面渐显效果
        for (CatCase *cat in catArray) {
            CGPoint point = [self randomCatDefaltLocation];
            cat.frame = CGRectMake(point.x,point.y, 45, 45);
            cat.catView.frame =   CGRectMake(0,0, 45, 45);
        }
    }];
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:catMoveTime target:self selector:@selector(catMove) userInfo:nil repeats:YES];
    addCatTimer = [NSTimer scheduledTimerWithTimeInterval:addCatTime target:self selector:@selector(addCat) userInfo:nil repeats:YES];

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
            if ((cat1.catSexState!=cat2.catSexState)&&cat1.catSexState!=CatSexStateKid&&cat2.catSexState!=CatSexStateKid) {
                CGPoint cat1center = cat1.center;
                CGPoint cat2center = cat2.center;
                CGRect rect1 = CGRectMake(cat1center.x-10, cat1center.y-10, 20, 20);
                CGRect rect2 = CGRectMake(cat2center.x-10, cat2center.y-10, 20, 20);
                BOOL ismeet = CGRectIntersectsRect(rect1,rect2);
                if (ismeet) {
                    [cat1 removeFromSuperview];
                    [cat2 removeFromSuperview];
                    [catArray removeObject:cat1];
                    [catArray removeObject:cat2];
                    
                    [self addCat];
                    break;
                    
                }
            }
        }
    }
}
//判断是否出边界
-(void)isBeyondBorder:(CGPoint)point
{
    if(point.x>FUll_VIEW_WIDTH||point.x<0||point.y<0||point.y>FUll_VIEW_HEIGHT)
    {
        [self failView];
        NSLog(@"x:%f  y:%f",point.x,point.y);
    }
    
}
// 失败
-(void)failView
{
    NSString *string = [NSString stringWithFormat:@"恭喜你,闯了%d关",grade];
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"游戏结束" contentText:string leftButtonTitle:@"炫耀" rightButtonTitle:@"重来"];
    [alert show];
    alert.leftBlock = ^() {
        
        NSLog(@"left button clicked");
        
    };
    alert.rightBlock = ^() {
        [catArray removeAllObjects];
        for (CatCase *cat in  self.view.subviews) {
            if (cat.tag!=302&&cat.tag!=301) {
                [cat removeFromSuperview];
            }
        
        }
    
        [self beginButtonClick];
        

    };
    
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };

    
    if ([moveTimer isValid]) {
        [moveTimer invalidate];
        moveTimer = nil;
    }
    
    if ([addCatTimer isValid]) {
        [addCatTimer invalidate];
        addCatTimer = nil;
    }
    
    if ([gameTimer isValid]) {
        [gameTimer invalidate];
        gameTimer = nil;
    }
    
}
#pragma youmidelegate

- (void)didReceiveAd:(YouMiView *)adView {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 获得广告\n",adView.contentSizeIdentifier];
}

- (void)didFailToReceiveAd:(YouMiView *)adView  error:(NSError *)error {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 获取广告失败\n",adView.contentSizeIdentifier];
}

- (void)willPresentScreen:(YouMiView *)adView {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 将要显示全屏广告\n",adView.contentSizeIdentifier];
}

- (void)didPresentScreen:(YouMiView *)adView {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 已显示全屏广告\n",adView.contentSizeIdentifier];
}

- (void)willDismissScreen:(YouMiView *)adView {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 将要退出全屏广告\n",adView.contentSizeIdentifier];
}

- (void)didDismissScreen:(YouMiView *)adView {
//    textView.text = [textView.text stringByAppendingFormat:@"%u 已退出全屏广告\n",adView.contentSizeIdentifier];
}

@end
