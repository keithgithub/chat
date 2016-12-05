//
//  CharTableView.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "CharTableView.h"

#define SCREEN_SIZE   [UIScreen  mainScreen].bounds.size
#define kScreen_bounds [UIScreen mainScreen].bounds

@implementation CharTableView
/**
 *  初始化表格
 *
 *  @param frame
 *  @param style
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self=[super  initWithFrame:frame style:style])
    {
        //不显示滚动条
        self.showsVerticalScrollIndicator=NO;
        //取消线条
        self.separatorStyle=UITableViewCellSelectionStyleNone;
        //背景透明
        self.backgroundColor=[UIColor   clearColor];
        //设置代理
        self.delegate=self;
        self.dataSource=self;
        
        self.Arrimg = [NSMutableArray new];
        
        [self  tableViewRegisterNib];
       
    }
   
    return  self;
}
/**
 *  表格注册nib
 */
-(void)tableViewRegisterNib
{
    //左边文字消息nib
    UINib  *nib=[UINib  nibWithNibName:@"LeftMessageTableViewCell" bundle:[NSBundle  mainBundle]];
    [self   registerNib:nib forCellReuseIdentifier:@"leftMsg"];
    //左边图片消息nib
    UINib *nib1=[UINib  nibWithNibName:@"LeftImgTableViewCell" bundle:[NSBundle  mainBundle]];
    [self  registerNib:nib1 forCellReuseIdentifier:@"leftImg"];
    //右边文字消息nib
    UINib  *nib3=[UINib  nibWithNibName:@"RightMessageTableViewCell" bundle:[NSBundle  mainBundle]];
    [self   registerNib:nib3 forCellReuseIdentifier:@"rightMsg"];
    //右边图片消息nib
    UINib *nib4=[UINib  nibWithNibName:@"RightImgTableViewCell" bundle:[NSBundle  mainBundle]];
    [self  registerNib:nib4 forCellReuseIdentifier:@"rightImg"];
    //右侧语意nib
    UINib *nib5=[UINib  nibWithNibName:@"RightVoiceTableViewCell" bundle:nil];
    [self registerNib:nib5 forCellReuseIdentifier:@"rightVoiceCell"];
    //右侧语意nib
    UINib *nib6=[UINib  nibWithNibName:@"LeftVoiceTableViewCell" bundle:nil];
    [self registerNib:nib6 forCellReuseIdentifier:@"leftVoiceCell"];
    
    
}
#pragma mark 当scroll开始拖拽时响应

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.myDelegate cloesInputView];
    
}
#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = _resultsContr.fetchedObjects.count - 1;
    
    if (lastRow < 0) {
        //行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark  表格代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultsContr.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg =  _resultsContr.fetchedObjects[indexPath.row];
    
    BOOL role=[msg.outgoing boolValue];
    
   
    NSString  *msgType=[msg.message attributeStringValueForName:@"bodyType"];;//获取消息类型
    
    if (!role)//进来的消息
    {
        if ([msgType isEqualToString:TEXT])//是文本消息
        {
            LeftMessageTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"leftMsg"];//左边文本消息框
            [cell  setCell:msg];//设置内容
            cell.imgHead.image = self.firendHead;
            cell.delegate =  self;
            
            return cell;
        }
        else if([msgType isEqualToString:IMAGE])//还有语音这边要判断
        {
            LeftImgTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"leftImg"];//左边图片类型
            [cell  setCell:msg];
            cell.imgHead.image = self.firendHead;
            cell.delegate = self;
            // 保存到图片数组
            NSData *imgData=[[NSData  alloc]initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *img = [UIImage  imageWithData:imgData];
            
            [self.Arrimg addObject:img];
            
            
            return cell;
        }
        else
        {
            LeftVoiceTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"leftVoiceCell"];//左边语音消息框
            [cell  setCell:msg];//设置内容
            cell.imgHead.image = self.firendHead;
            
            
            return cell;
        }
        
    }
    else//右边，发送消息
    {

        if ([msgType isEqualToString:TEXT])//文本
        {
            RightMessageTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"rightMsg"];
            [cell  setCell:msg];
            cell.imgHead.image = self.selfHead;
            cell.delegate = self;
            
            return cell;
            
        }
        else  if([msgType isEqualToString:IMAGE])
        {
            RightImgTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"rightImg"];//图片
            [cell  setCell:msg];
            cell.imgHead.image = self.selfHead;
            cell.delegate = self;
            
            // 保存到图片数组
            NSData *imgData=[[NSData  alloc]initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *img = [UIImage  imageWithData:imgData];
            
            [self.Arrimg addObject:img];
            
            
            return cell;
        }
        else
        {
            RightVoiceTableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:@"rightVoiceCell" forIndexPath:indexPath];
            cell.imgVHead.image = self.selfHead;
            [cell setCell:msg];//语音
            return cell;
        }
        
    }
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg =  _resultsContr.fetchedObjects[indexPath.row];
    //消息类型是图片还是文字（后续可能还有语音）
    NSString  *msgType=[msg.message attributeStringValueForName:@"bodyType"];//获取消息类型
    if ([msgType isEqualToString:TEXT])
    {
        NSString *str=msg.body;
        //计算消息内容的高度
        CGSize  size=[NSString  calStrSize:str andWidth:SCREEN_SIZE.width-158 andFontSize:15];

//        消息的高度+基本的cell高度
        return size.height+83;
    }
    else  if([msgType isEqualToString:IMAGE])
    {
       
        NSData *data=[[NSData  alloc]initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
        

        
        UIImage  *img=[[UIImage alloc]initWithData:data] ;
        CGFloat h=0;
        if (img.size.width>SCREEN_SIZE.width-158)//若图片的宽度大于最大宽度
        {
            h=SCREEN_SIZE.width-158;//取最大宽度，同时高度与最大宽度相等
        }
        else//否则
        {
            h=img.size.height;//图片的导读
        }

        //把图片的宽度
        return  h+60;
    }
    else
    {
        return 80;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg =  _resultsContr.fetchedObjects[indexPath.row];
    
    //消息类型是图片还是文字（后续可能还有语音）
    NSString  *msgType=[msg.message attributeStringValueForName:@"bodyType"];//获取消息类型
    if ([msgType isEqualToString:AUDIO])
    {
        NSData *voiceData=[[NSData  alloc]initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        NSError *err=nil;
        self.player =[[AVAudioPlayer  alloc]initWithData:voiceData error:&err];
        [self.player  prepareToPlay];
        [self.player  play];
    }
    if ([msgType isEqualToString:IMAGE ])
    {
        // 点击图片全屏显示
        NSData *imgData=[[NSData  alloc]initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *img = [UIImage imageWithData:imgData];
        
        [self.myDelegate showImg:img];
    }
}

#pragma mark 各种 cell 代理方法

- (void)sendLeftImg:(UIImage *)img
{
    [self.myDelegate showSenderView:img];
}

- (void)sendLeftText:(NSString *)text
{
    [self.myDelegate showSenderView_txt:text];
}

- (void)sendRightImg:(UIImage *)img
{
    [self.myDelegate showSenderView:img];
}

- (void)sendRightText:(NSString *)text
{
    [self.myDelegate showSenderView_txt:text];
}
#pragma mark -

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
