//
//  VoiceView.h
//  WeiXinChar
//
//  Created by guan song on 15/11/22.
//  Copyright (c) 2015年 guan song. All rights reserved.
//语音视图

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//录音结束后回调录音地址
typedef void(^sendVoiceBlock)(NSString *voicePath);

@interface VoiceView : UIView
{
    UIImageView *imgV;
}

@property(nonatomic,strong)sendVoiceBlock  saveSendBlock;//代码块变量
//创建录音对象
@property(nonatomic,strong)AVAudioRecorder *recorder;
@property(nonatomic,copy)NSString *sendPath;
/**
 *  创建录音界面
 *
 *  @param frame     大小
 *  @param sendVoice 录音结束回调代码块
 *
 *  @return 返回视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame  andRecordeBlock:(sendVoiceBlock)sendVoice;




@end
