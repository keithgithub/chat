//
//  InputView.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//输入消息视图

#import <UIKit/UIKit.h>
#import "TimeModel.h"
#define  SCREEN_SIZE  [UIScreen  mainScreen].bounds.size
typedef   void (^GetPhotoBlock)(NSDictionary *dic,NSInteger index) ;//声明代码快类型

@protocol InputViewDelegate <NSObject>

- (void)closeView;

@end

@interface InputView : UIView<UITextViewDelegate>
{
    GetPhotoBlock  myBlock;//声明代码块变量
    
}

@property (nonatomic,assign) id<InputViewDelegate>delegate;

@property(nonatomic,strong)UIButton  *btnAdd,*btnSendMsg;//添加,发送//,*btnExpression
@property(nonatomic,strong)UITextView  *txtInput;
@property(nonatomic,strong)UILabel *lblPlaceholder;//提示文本
@property(nonatomic,assign)BOOL  isSelectAdd,isSelectVoice;//选择加,选择语音


-(instancetype)initWithFrame:(CGRect)frame  andPhotoBlock:(GetPhotoBlock)getPhoto;



@end







