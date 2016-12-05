
//
//  VoiceView.m
//  WeiXinChar
//
//  Created by guan song on 15/11/22.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "VoiceView.h"
#import "TimeModel.h"
@implementation VoiceView

-(instancetype)initWithFrame:(CGRect)frame andRecordeBlock:(sendVoiceBlock)sendVoice
{
    if ( self=[super  initWithFrame:frame])
    {
        self.saveSendBlock=sendVoice;
        [self  createRecordeImageView];
        self.backgroundColor=[UIColor colorWithWhite:0.960 alpha:1.000];
    }
    return self;
}
-(void)createRecordeImageView
{
   CGFloat  w= [UIScreen mainScreen].bounds.size.width;
    //创建语音图片
     imgV=[[UIImageView  alloc]initWithFrame:CGRectMake((w-120)/2, (self.frame.size.height-120)/2, 120, 120)];

    //用户交互打开
    imgV.userInteractionEnabled=YES;
    //添加图片
    imgV.image=[UIImage  imageNamed:@"voice_btn_normal"];
    
    
    //创建图片长按手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer  alloc]initWithTarget:self action:@selector(recorderAction:)];
    //添加
    [imgV  addGestureRecognizer:longPress];
    
    [self  addSubview:imgV];
    
}
-(void)recorderAction:(UILongPressGestureRecognizer  *)sender
{
    //    NSLog(@"长按-----");
    if (sender.state==UIGestureRecognizerStateBegan)
    {
        imgV.image = [UIImage imageNamed:@"voice_btn_press"];
        //录音
        //创建存放错误信息
        NSError *err=nil;
        //初始化对象
        self.recorder=[[AVAudioRecorder  alloc]initWithURL:[self  getPath] settings:[self  getAudioSetting] error:&err];
        if (err)
        {
            NSLog(@"error:%@",err);
        }
        else
        {
            //准备录音
            [self.recorder  prepareToRecord];
            //开始录音
            [self.recorder  record];
        }
        
    }
    if (sender.state==UIGestureRecognizerStateEnded)
    {
        imgV.image = [UIImage imageNamed:@"voice_btn_normal"];
        
        //结束录音
        [self.recorder  stop];
        self.saveSendBlock(self.sendPath);
        
    }
}

//获取音频存放的地址:录音1
-(NSURL *)getPath
{
    //获取沙盒地址
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取第0个地址
    NSString *path=paths[0];
    //拼接文件名
    path=[path  stringByAppendingString:[NSString  stringWithFormat:@"/corder%@.caf",[TimeModel  tDate]]];
    //创建文件管理对象
    NSFileManager *manager=[NSFileManager  defaultManager];
    //创建存储错误的信息
    NSError *err=nil;
    //获取文件属性
    NSDictionary *dic=[manager  attributesOfItemAtPath:path error:&err];
    //输出文件大小
    NSLog(@"fileSize:%@",dic[@"NSFileSize"]);
    //输出地址
    NSLog(@"%@",path);
    self.sendPath=path;
    
    //转url
    NSURL  *url=[NSURL  fileURLWithPath:path];
    
    return url;
}
//设置音频配置
-(NSDictionary *)getAudioSetting
{
    //创建一个可变字典
    NSMutableDictionary *mDic=[NSMutableDictionary  dictionary];
    //设置音频录制格式
    [mDic  setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置音频采样率
    [mDic  setObject:@(8000) forKey:AVSampleRateKey];
    //设置声道：1：单声道，2：立体声
    [mDic  setObject:@(1) forKey:AVNumberOfChannelsKey];
    //设置每个采样的点位数（8，16，24，32）
    [mDic  setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //设置使用浮点数进行采样
    [mDic  setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    return mDic;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
