//
//  InputView.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "InputView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation InputView

-(instancetype)initWithFrame:(CGRect)frame  andPhotoBlock:(void (^)(NSDictionary *dic,NSInteger  index))getPhoto
{
    if ( self=[super  initWithFrame:frame])
    {
        self.backgroundColor=[UIColor colorWithWhite:0.960 alpha:1.000];
        myBlock=getPhoto;
        
        [self  createControl];
       
        
    }
    return self;
}
/**
 *  创建控件
 */
-(void)createControl
{
    //添加
    self.btnAdd=[UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [self.btnAdd  setBackgroundImage:[UIImage  imageNamed:@"icon_photo"] forState:UIControlStateNormal];
    self.btnAdd.tag=101;
    self.btnAdd.frame=CGRectMake(10, 8, 25, 25);
//表情
//    self.btnExpression=[UIButton  buttonWithType:UIButtonTypeRoundedRect];
//    [self.btnExpression  setBackgroundImage:[UIImage  imageNamed:@"expression.png"] forState:UIControlStateNormal];
//    self.btnExpression.tag=102;
//    self.btnExpression.frame=CGRectMake(40, 8, 25, 25);
    //输入框
    self.txtInput=[[UITextView  alloc]initWithFrame:CGRectMake(40, 6, SCREEN_SIZE.width-90, 30)];
     self.txtInput.layer.cornerRadius=4;
    self.txtInput.layer.borderColor=[UIColor colorWithWhite:0.825 alpha:1.000].CGColor;
    self.txtInput.layer.borderWidth=0.5;
    self.txtInput.font = [UIFont systemFontOfSize:17];
    
    self.txtInput.delegate=self;
    self.txtInput.backgroundColor=[UIColor colorWithWhite:0.307 alpha:0.000];
    //提示文本
    self.lblPlaceholder=[[UILabel  alloc]initWithFrame:CGRectMake(40, 4, SCREEN_SIZE.width-90, 32)];
    self.lblPlaceholder.text=@" 说点什么呢?";
    self.lblPlaceholder.textColor=[UIColor colorWithWhite:0.692 alpha:1.000];
    self.lblPlaceholder.font=[UIFont  systemFontOfSize:17];
      //设置圆角
    self.lblPlaceholder.layer.cornerRadius=4;
    self.lblPlaceholder.layer.masksToBounds=YES;
    self.lblPlaceholder.backgroundColor=[UIColor  clearColor];
    
    //发送
    self.btnSendMsg=[UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [self.btnSendMsg  setBackgroundImage:[UIImage  imageNamed:@"icon_voice"] forState:UIControlStateNormal];
    
    self.btnSendMsg.frame=CGRectMake(SCREEN_SIZE.width-40, 5, 30, 30);
    self.btnSendMsg.tag=103;
    
    
    //添加按钮点击方法
    
    [self.btnSendMsg  addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//     [self.btnExpression  addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.btnAdd  addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self  addSubview:self.btnAdd];
//    [self  addSubview:self.btnExpression];
    [self  addSubview:self.lblPlaceholder];
    [self  addSubview:self.btnSendMsg];
    [self  addSubview:self.txtInput];
    

}
/**
 *  点击按钮响应方法
 *
 *  @param sender
 */
-(void)btnAction:(UIButton *)sender
{
    if (sender.tag==103)//发送
    {
        if (self.txtInput.text.length==0)//语音出现
        {
            [self.txtInput  resignFirstResponder];//关闭第一响应
            //NO要打开+
            myBlock(@{@"isSelectVoice":@(self.isSelectVoice)},104);
            self.isSelectVoice=!self.isSelectVoice;
            self.isSelectAdd=NO;
        }
        else//发送
        {
            NSString  *date=[TimeModel  tDate];
            NSDictionary *dic=@{@"role":@"out",@"msgType":@"strMsg",@"content":self.txtInput.text,@"date":date};
            
            self.txtInput.text=@"";
#pragma mark  待修改 ******************
            //[self.txtInput  resignFirstResponder];
            //回调代码块
            myBlock(dic,103);
            //变为发送按钮
            //发送按钮为语音图标
            [self.btnSendMsg  setBackgroundImage:[UIImage  imageNamed:@"icon_voice"] forState:UIControlStateNormal];
            //没有标题
            [self.btnSendMsg setTitle:nil forState:UIControlStateNormal];
        }
        
    }
    else//加号
    {
        [self.txtInput  resignFirstResponder];//关闭第一响应
        //NO要打开+
        myBlock(@{@"isSelect":@(self.isSelectAdd)},101);
        self.isSelectAdd=!self.isSelectAdd;
        self.isSelectVoice=NO;
    }
   
}


#pragma mark  文本框代理

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate  closeView];
    self.isSelectAdd=NO;//关闭+号
    self.isSelectVoice=NO;//关闭语音
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)//输入文本了，变发送
    {
        self.lblPlaceholder.text=@"";
        //没有背景图
        [self.btnSendMsg  setBackgroundImage:nil forState:UIControlStateNormal];
        //变为发送按钮
        [self.btnSendMsg setTitle:@"发送" forState:UIControlStateNormal];

    }
    else//文本没有  语音
    {
        //发送按钮为语音图标
        [self.btnSendMsg  setBackgroundImage:[UIImage  imageNamed:@"icon_voice"] forState:UIControlStateNormal];
        //没有标题
        [self.btnSendMsg setTitle:nil forState:UIControlStateNormal];
    }
 }

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.btnSendMsg  setBackgroundImage:[UIImage  imageNamed:@"icon_voice"] forState:UIControlStateNormal];
    [self.btnSendMsg setTitle:nil forState:UIControlStateNormal];//没有标题
    
    if (textView.text.length<=0)//没有输入文本
    {
        self.lblPlaceholder.text=@" 说点什么呢?";
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
