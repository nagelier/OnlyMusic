//
//  ViewController.h
//  OnlyMusic
//
//  Created by zte on 16/12/13.
//  Copyright © 2016年 zte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UISlider *playingSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIView *playAndPauseView;
@property (weak, nonatomic) IBOutlet UIScrollView *pointScorllView;

@end

