//
//  ViewController.m
//  OnlyMusic
//
//  Created by zte on 16/12/13.
//  Copyright © 2016年 zte. All rights reserved.
//
#define tag_play  100
#define tag_pause  101
#define marker_width  70
#define marker_height  40

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@property AVAudioPlayer * player;
@property NSInteger markerCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //播放音频之前先要设置AVAudioSession模式 是它可以后台播放
    //并且要在plist文件中 添加required background modes这个key项，并选择"App plays audio or streams audio/video using AirPlay"这个value项。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.playBtn.tag = tag_play;
    [self addTopLine:self.replayBtn];
    [self addBorder:self.playBtn isBlue:NO];
    [self addBorder:self.pauseBtn isBlue:YES];
    
    self.playAndPauseView.backgroundColor = [UIColor clearColor];
    
    [self initPlayer];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initPlayer{
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bangbangbang" ofType:@"mp3"]] error:nil];//使用本地URL创建
    
    self.player.volume =0.8;//0.0-1.0之间
    
    //2、循环次数
    self.player.numberOfLoops = 2;//默认只播放一次
    
    // 3、播放位置
    self.player.currentTime = 0;//可以指定从任意位置开始播放
    
    //4、声道数
    NSUInteger channels = self.player.numberOfChannels;//只读属性
    
    //5、持续时间
    NSTimeInterval duration = self.player.duration;//获取持续时间
    
    //三、播放声音
    [self.player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if  (player == self.player && flag == YES) {
        NSLog(@"Playback finish.");
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    //解码错误执行的动作
}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    //处理中断的代码
}

//audioPlayerEndInterruption:，当程序被应用外部打断之后，重新回到应用程序的时候触发。在这里当回到此应用程序的时候，继续播放音乐。
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    
}

-(NSString*)getPlayTimeStr{
    NSString * timeStr;
    NSTimeInterval time = self.player.currentTime;
    
    NSInteger minutes = time/60;
    NSInteger second = time-minutes*60;
    NSString * secondPrex = second < 10 ? @"0" : @"";
    NSString * minutesStr = (time/60 > 0) ? [NSString stringWithFormat:@"0%ld", minutes] : @"00";
    NSString * secondStr = (time > 0) ? [NSString stringWithFormat:@"%@%ld", secondPrex, second] : @"00";
    
    timeStr = [NSString stringWithFormat:@"%@:%@",minutesStr, secondStr];
    
    
    NSLog(@"Playing...%f", self.player.currentTime);
    return timeStr;
}

-(void)playMusic{
    
    if (!self.player.playing) {
        [self.player play];
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
    }
    
}

-(void)pauseMusic{
    // if playing, pause
    if  (self.player.playing) {
        [self.player pause];
    }
}

-(void)replayMusic{
    self.player.currentTime = 0;
    [self playMusic];
}


-(void)processChanged
{
    NSInteger currentTime = self.playingSlider.value*self.player.duration;
    [self.player setCurrentTime:currentTime];
    self.timeLb.text = [self getPlayTimeStr];
}

-(void)updateSliderValue
{
    self.playingSlider.value = self.player.currentTime/self.player.duration;
    self.timeLb.text = [self getPlayTimeStr];
}


- (IBAction)sliderChanged:(id)sender {
    [self processChanged];
}

- (IBAction)playMusic:(id)sender {
    if (self.playBtn.tag == tag_play) {
        self.playBtn.tag = tag_pause;
        [self.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self playMusic];
    }else{
        self.playBtn.tag = tag_play;
        [self.playBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self pauseMusic];
    }
}

//"标记事件"
- (IBAction)pauseMusic:(id)sender {
    [self addPointMarker];
}

- (IBAction)replayMusic:(id)sender {
    if (self.player.playing) {
        [self.player pause];
    }
    self.playBtn.tag = tag_pause;
    [self.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [self performSelector:@selector(replayMusic) withObject:nil afterDelay:2.0];
    
}


-(void)addTopLine:(UIView*) view{
    //创建分割线
    UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    vlabel.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0f];
    [view addSubview:vlabel];
}

-(void)addBorder:(UIView*) contentView isBlue:(BOOL) isBlue{
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = !isBlue ? [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0f].CGColor : [UIColor colorWithRed:9/255.0 green:80/255.0 blue:208/255.0 alpha:1.0f].CGColor;
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;

}

-(void)addPointMarker{

    NSInteger xValue = _markerCount * marker_width + 15*(_markerCount+1);
    
    UIButton *markerBtn = [[UIButton alloc] initWithFrame:CGRectMake(xValue, 20, marker_width, marker_height)];
    NSTimeInterval time = self.player.currentTime;
    markerBtn.tag = time;
    [markerBtn addTarget:self action:@selector(markerAction:) forControlEvents:UIControlEventTouchUpInside];//点击事件
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //设置最少按下的持续时间
    longGR.minimumPressDuration = 0.5;
    [markerBtn addGestureRecognizer:longGR];//添加长按事件
    
    [markerBtn setTitle:[self getPlayTimeStr] forState:UIControlStateNormal];
    [markerBtn setTitleColor:[UIColor colorWithRed:9/255.0 green:80/255.0 blue:208/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self addBorder:markerBtn isBlue:YES];
    [self.pointScorllView addSubview:markerBtn];
    _markerCount ++;
    
    self.pointScorllView.contentSize = CGSizeMake(xValue + marker_width + 10, marker_height);
}

//标记点的点击事件
-(void)markerAction:(UIButton*)sender{
    NSInteger currentTime = sender.tag;
    [self.player setCurrentTime:currentTime];
}

-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"start gestureRecognizer");
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"end gestureRecognizer");
        //NSInteger tag = self.player.currentTime;
        UIButton * longPressButton = (UIButton*)gestureRecognizer.view;
        [longPressButton removeFromSuperview];
        
        [self resetScorollViewSubviews];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"gestureRecognizer changed");
    }
    
}

-(void)resetScorollViewSubviews{
    NSArray * views = self.pointScorllView.subviews;
    _markerCount = views.count;
    
    for (int i = 0; i < views.count; i++) {
        UIButton * btn = (UIButton*)[views objectAtIndex:i];
        
        [btn removeFromSuperview];
        NSInteger xValue = i * marker_width + 15*(i+1);
        
        UIButton *markerBtn = [[UIButton alloc] initWithFrame:CGRectMake(xValue, 20, marker_width, marker_height)];
        markerBtn.tag = btn.tag;
        [markerBtn addTarget:self action:@selector(markerAction:) forControlEvents:UIControlEventTouchUpInside];//点击事件
        UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        //设置最少按下的持续时间
        longGR.minimumPressDuration = 0.5;
        [markerBtn addGestureRecognizer:longGR];//添加长按事件
        
        [markerBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [markerBtn setTitleColor:[UIColor colorWithRed:9/255.0 green:80/255.0 blue:208/255.0 alpha:1.0f] forState:UIControlStateNormal];
        [self addBorder:markerBtn isBlue:YES];
        [self.pointScorllView addSubview:markerBtn];
    }
}

@end
