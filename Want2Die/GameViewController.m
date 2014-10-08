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
#define TAG_SETTING_VIEW 200;

#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)-(isIOS7?0:20)
#define TOP_BAR_HEIGHT (isIOS7?[UIApplication sharedApplication].statusBarFrame.size.height+44.0:44.0)
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


@interface GameViewController ()
{
    UIView *settingViewBG;
    UIView *aboutViewBG;
    UIButton *beginButton;
    UIButton *settingButton;
    UIButton *abloutButton;
    UILabel *musicLabel;
    UIButton *musicButton;
    UIButton *gradeButton;
    UILabel *gradeLabel;
    UIButton *supportButton;
    UILabel *supportLabel;
    UIButton *rankListButton;
     UILabel *rankListLabel;
    
    
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
    
    int musicState;//音乐开关状态 1：开 0：关
    int gradeState;//等级 1：简单 2：一般 3：困难
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
#pragma mark - UI
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
    
    settingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingButton.frame = CGRectMake(10, 10, 25, 25);
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    abloutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    abloutButton.frame = CGRectMake(310-25, 10, 25, 25);
    [abloutButton setBackgroundImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
    [abloutButton addTarget:self action:@selector(aboutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:abloutButton];
    
    beginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    beginButton.frame = CGRectMake(115, 50, 100, 40);
//    beginButton.center =  self.view.center;
    [beginButton setTitle:@"点击开始" forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    
    //初始一家人
    [self addCatFamliy];
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
        [self addCatFamliy];
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

#pragma mark - 事件
//设置按钮点击
- (void)settingButtonClick{
    beginButton.hidden=YES;
    settingButton.hidden = YES;
    abloutButton.hidden = YES;
    
    settingViewBG = [[UIView alloc]initWithFrame:self.view.frame];
    settingViewBG.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.5];
    [self.view addSubview:settingViewBG];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingBackHome)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [settingViewBG addGestureRecognizer:tap];
    
    UIView *settingView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, FUll_VIEW_WIDTH, 66)];
    settingView.tag = TAG_SETTING_VIEW;
    settingView.backgroundColor = [UIColor colorWithRed:75/255 green:75/255 blue:75/255 alpha:0.6];
    [settingViewBG addSubview:settingView];
    settingView.userInteractionEnabled = YES;
    
    musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicButton setBackgroundImage:[UIImage imageNamed:@"openMusic"] forState:UIControlStateNormal];
    [musicButton setBackgroundImage:[UIImage imageNamed:@"openMusic"] forState:UIControlStateHighlighted];
    [musicButton addTarget:self action:@selector(musicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    musicButton.frame = CGRectMake(50, 12, 32, 32);
    [settingView addSubview:musicButton];
    
    musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 50, 100, 15)];
    musicLabel.text = @"音乐 开";
    musicState = 1;
    musicLabel.font = [UIFont systemFontOfSize:12];
    musicLabel.textColor = [UIColor whiteColor];
    [settingView addSubview:musicLabel];
    
    gradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_easy"] forState:UIControlStateNormal];
    [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_easy"] forState:UIControlStateHighlighted];
    [gradeButton addTarget:self action:@selector(gradeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    gradeButton.frame = CGRectMake(114, 12, 32, 32);
    [settingView addSubview:gradeButton];
    
    gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 50, 100, 15)];
    gradeLabel.text = @"简单";
    gradeState=1;
    gradeLabel.font = [UIFont systemFontOfSize:12];
    gradeLabel.textColor = [UIColor whiteColor];
    [settingView addSubview:gradeLabel];
    
    supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [supportButton setBackgroundImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
    [supportButton addTarget:self action:@selector(supportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    supportButton.frame = CGRectMake(178, 12, 32, 32);
    [settingView addSubview:supportButton];
    
    supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(179, 50, 100, 15)];
    supportLabel.text = @"打分";
    supportLabel.font = [UIFont systemFontOfSize:12];
    supportLabel.textColor = [UIColor whiteColor];
    [settingView addSubview:supportLabel];
 
    
    
    rankListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankListButton setBackgroundImage:[UIImage imageNamed:@"rankList"] forState:UIControlStateNormal];
    [rankListButton addTarget:self action:@selector(supportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rankListButton.frame = CGRectMake(242, 12, 32, 32);
    [settingView addSubview:rankListButton];
    
    rankListLabel = [[UILabel alloc]initWithFrame:CGRectMake(242, 50, 100, 15)];
    rankListLabel.text = @"排行榜";
    rankListLabel.font = [UIFont systemFontOfSize:12];
    rankListLabel.textColor = [UIColor whiteColor];
    [settingView addSubview:rankListLabel];

    
}
-(void)aboutButtonClick
{
    beginButton.hidden = YES;
    settingButton.hidden = YES;
    abloutButton.hidden = YES;
    aboutViewBG = [[UIView alloc]initWithFrame:self.view.frame];
    aboutViewBG.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.5];
    [self.view addSubview:aboutViewBG];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutBackHome)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [aboutViewBG addGestureRecognizer:tap];
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(15, 230, 290, 200)];
    aboutView.backgroundColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:0.5];
    [aboutViewBG addSubview:aboutView];
    
    CatCase *cat = [[CatCase alloc]initWithFrame:CGRectMake(25,80, 120, 120) andSex:CatSexStateMale];
    [aboutViewBG addSubview:cat];

}
-(void)settingBackHome
{

    beginButton.hidden = NO;
    settingButton.hidden = NO;
    abloutButton.hidden = NO;
    [settingViewBG removeFromSuperview];
    
}
-(void)aboutBackHome
{
    beginButton.hidden = NO;
    settingButton.hidden = NO;
    abloutButton.hidden = NO;
    [aboutViewBG removeFromSuperview];
}
-(void)supportButtonClick
{
    //应用内评分
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",490062954];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
-(void)gradeButtonClick
{
    if (gradeState==1) {
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_medium"] forState:UIControlStateNormal];
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_medium"] forState:UIControlStateHighlighted];
        gradeLabel.text = @"一般";
        gradeState++;
    }else if(gradeState==2)
    {
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_difficult"] forState:UIControlStateNormal];
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_difficult"] forState:UIControlStateHighlighted];
        gradeLabel.text = @"困难";
        gradeState++;

    }else if (gradeState==3)
    {
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_easy"] forState:UIControlStateNormal];
        [gradeButton setBackgroundImage:[UIImage imageNamed:@"grade_easy"] forState:UIControlStateHighlighted];
         gradeLabel.text = @"简单";
        gradeState=1;
    }

    
}
-(void)musicButtonClick
{
    if (musicState==1) {
        [musicButton setBackgroundImage:[UIImage imageNamed:@"closeMusic"] forState:UIControlStateNormal];
        [musicButton setBackgroundImage:[UIImage imageNamed:@"closeMusic"] forState:UIControlStateHighlighted];
        musicLabel.text = @"音乐 关";
        musicState=0;
    }else if (musicState==0)
    {
        [musicButton setBackgroundImage:[UIImage imageNamed:@"openMusic"] forState:UIControlStateNormal];
        [musicButton setBackgroundImage:[UIImage imageNamed:@"openMusic"] forState:UIControlStateHighlighted];
        musicLabel.text = @"音乐 开";
        musicState=1;
    }
   
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

#pragma mark - CAT
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
#pragma mark youmidelegateAD

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

#pragma mark--
#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(touch.view.tag==200)
    {
        return NO;
    }
    return YES;
}


@end
