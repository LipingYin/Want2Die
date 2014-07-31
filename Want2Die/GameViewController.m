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
#define WIDTH 20
#define MOVE_LEN 5

@interface GameViewController ()
{

    UIButton * beginButton;
    NSTimer *timer;
    NSTimer *addCatTimer;
    NSMutableArray *catArray;
    
    int maleCatCount;
    int femaleCatCount;
    int kidCatCount;
    
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
    [self addAd];
    [self launchView];
}
//广告条显示
-(void)addAd
{
    YouMiView *adView320x50=[[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:self];
    adView320x50.frame = CGRectMake(0, 0, CGRectGetWidth(adView320x50.bounds), CGRectGetHeight(adView320x50.bounds));
    adView320x50.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [adView320x50 start];
    
    [self.view addSubview:adView320x50];
    
    YouMiView *adView2=[[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:self];
    adView2.frame = CGRectMake(0, self.view.frame.size.height-50, CGRectGetWidth(adView2.bounds), CGRectGetHeight(adView2.bounds));
    adView2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [adView2 start];
    
    [self.view addSubview:adView2];

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
    [self addCat];
}
-(void)addCat
{
    //一定范围内的随机位置
    CGPoint catPoint = [self randomCatDefaltLocation];
    //初始猫
    CatCase *cat = [[CatCase alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    cat.center = catPoint;
    cat.userInteractionEnabled = YES;
    [self.view addSubview:cat];
    [catArray addObject:cat];
    cat.tag = 100+catArray.count;
    for (CatCase *cat in catArray) {
        if (cat.catSexState ==CatSexStateMale) {
            maleCatCount++;
        }else if(cat.catSexState == CatSexStateFemale)
        {
            femaleCatCount++;
        }else if(cat.catSexState == CatSexStateKid)
        {
            kidCatCount++;
        }
    }
    
    cat.catSexState = maleCatCount>femaleCatCount?CatSexStateFemale:CatSexStateMale;
    
}

//一定范围内的随机位置
-(CGPoint)randomCatDefaltLocation
{
    //m + rand()%(n-m)
    CGPoint center = self.view.center;
    int minX = center.x-40;
    int maxX = center.x+40;
    int minY = center.y-40;
    int maxY = center.y+40;
    int catX = minX + arc4random()%(maxX-minX);
    int catY = minY + arc4random()%(maxY-minY);
    
    CGPoint catPoint= CGPointMake(catX, catY);
    return catPoint;
}
//开始按钮点击
- (void)beginButtonClick:(id)sender {
  
    static BOOL isPlaying = NO;
    beginButton.hidden = YES;
    beginButton.enabled = NO;
    if (!isPlaying) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(catMove) userInfo:nil repeats:YES];
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
