//
//  CharTableView.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftImgTableViewCell.h"
#import "LeftMessageTableViewCell.h"
#import "RightImgTableViewCell.h"
#import "RightMessageTableViewCell.h"
#import "NSString+LabelHight.h"
#import "RightVoiceTableViewCell.h"
#import "LeftVoiceTableViewCell.h"
#import "XMPPHelp+Message.h"


#define AUDIO @"audio"  //语音类型
#define IMAGE   @"image"  //图片消息类型
#define TEXT  @"text"  //文字消息类型

@protocol CharTableViewDelegate <NSObject>

- (void)showImg:(UIImage *)img;

- (void)showSenderView:(UIImage*)img;

- (void)showSenderView_txt:(NSString *)text;

- (void)cloesInputView;
@end

@interface CharTableView : UITableView<UITableViewDataSource,UITableViewDelegate,LeftImgTableViewCellDelegate,LeftMessageTableViewCellDelegae,RightImgTableViewCellDelegate,RightMessageTableViewCellDelegae>

@property (nonatomic,assign) id<CharTableViewDelegate> myDelegate;

@property(nonatomic,strong)NSFetchedResultsController *resultsContr;

@property(nonatomic,strong)AVAudioPlayer *player;

@property (nonatomic,strong) UIImage *firendHead;
@property (nonatomic,strong) UIImage *selfHead;

// 存放聊天图片的数组
@property (nonatomic,strong) NSMutableArray *Arrimg;

#pragma mark 滚动到底部
-(void)scrollToTableBottom;

@end
