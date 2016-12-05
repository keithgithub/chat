//
//  LFChatViewController.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFChatViewController.h"
#import "LFChatTalkTableViewCell.h"
#import "LFMyChatTableViewCell.h"
#import "LFMySpeakTableViewCell.h"
#import "LFOtherSpeakTableViewCell.h"
#import "LFSeeInfoViewController.h"
#import "LFXMPPHelp+Message.h"
#import "XMPPvCardTemp.h"
#import "NSString+CalStringSize.h"
#import "LFChatAudioView.h"
#import "LFConstant.h"
#import "NSDate+LFExtension.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+LFExtension.h"
#import "LFMyImageTableViewCell.h"
#import "LFOtherImageTableViewCell.h"
#import "LFInputAddView.h"
#import "UIImage+Extension.h"

#define kInputViewH 100

@interface LFChatViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 表格
@property (weak, nonatomic) IBOutlet UITextField *textField; // 文本框
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *user; // 好友详细信息
@property (nonatomic, strong) NSFetchedResultsController *fetch; // 查询结果管理
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (nonatomic, strong) NSMutableArray *talksMarray; // 存放消息的数组
@property (nonatomic, strong) LFChatAudioView *audioView; // 录音视图
@property (weak, nonatomic) IBOutlet UIButton *audioSpeakButton; // 说话按钮
@property (nonatomic, strong) AVAudioRecorder *recorder; // 创建录音对象
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *arrDatas;// 存储录音的记录
@property (nonatomic, copy) NSString *audioPath; // 存储地址
@property (nonatomic, strong) LFInputAddView *inputAddView; // 添加按钮视图
@property (nonatomic, strong) UIImagePickerController *imagePicker; // 相片选择
@property (nonatomic, assign) BOOL isInputViewUp; // inputView是否弹出
@property (nonatomic, assign) CGFloat talkHight; // 聊天文本高度
@end

@implementation LFChatViewController
#pragma mark - 懒加载
- (NSMutableArray *)talksMarray {
    if (_talksMarray == nil) {
        // 初始化数组
        _talksMarray = [NSMutableArray new];
        // 赋值消息列表
        [_talksMarray addObjectsFromArray:self.fetch.fetchedObjects];
        // 刷新表格
        [self.tableView reloadData];
    }
    
    return _talksMarray;
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        // 创建对象
        _imagePicker = [[UIImagePickerController alloc] init];
        // 允许编辑
        _imagePicker.allowsEditing = YES;
        // 设置代理
        _imagePicker.delegate = self;
        
    }
    
    return _imagePicker;
}

- (LFInputAddView *)inputAddView {
    if (_inputAddView == nil) {
        _inputAddView = [[LFInputAddView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kInputViewH)];
        __weak typeof(self) vc = self;
        _inputAddView.collectionClickBlock = ^(UICollectionView *collectionView, int item) {
            if (item == 0) {
                // 如果用户允许相机
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    // 设置数据源
                    vc.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [vc presentViewController:vc.imagePicker animated:YES completion:nil];
                    [vc inputViewBack];
                }
            } else if (item == 1) {
                // 如果用户允许相册
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    vc.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [vc presentViewController:vc.imagePicker animated:YES completion:nil];
                    [vc inputViewBack];
                }
            }
        };
        [self.view.window addSubview:_inputAddView];
    }
    
    return _inputAddView;
}

#pragma end mark

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改键盘风格
    self.textField.keyboardAppearance=UIKeyboardAppearanceDark;
    
    // 设置表格背景透明
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 创建背景视图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    bgImageView.image = [UIImage imageNamed:@"main_bg7"];
    // 设置为表格背景视图
    self.tableView.backgroundView = bgImageView;
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 创建别人打字信息nib
    [self createNib:@"LFChatTalkTableViewCell"];
    
    // 创建我的打字信息nib
    [self createNib:@"LFMyChatTableViewCell"];
    
    // 创建我的说话信息nib
    [self createNib:@"LFMySpeakTableViewCell"];
    
    // 创建别说语音信息Nib
    [self createNib:@"LFOtherSpeakTableViewCell"];
    
    // 创建我的图片nib
    [self createNib:@"LFMyImageTableViewCell"];
    
    // 创建其他人的图片nib
    [self createNib:@"LFOtherImageTableViewCell"];
    
    // 创建录音视图
    [self createVoiceView];
    
    // 如果隐藏右侧按钮状态为是
    if (self.isHiddenRightItem) {
        // 不设置按钮
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        // 创建右侧按钮
        [self createRightItem];
    }
    
    
    // 创建后退按钮
    [self createBackItem];
    
    // 监听键盘高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 设置文本框代理
    self.textField.delegate = self;
    
    // 初始化声音功能对象
    [self initializeAudio];
    
    // 获取消息管理
    self.fetch = [[LFXMPPHelp shareXMPPHelp] xmppGetMessageLocalWithFriendName:self.user.jidStr];
    // 设置代理
    self.fetch.delegate = self;
    NSError *err = nil;
    // 开始工作
    [self.fetch performFetch:&err];
    if (err) { // 如果请求失败
        NSLog(@"LFChatViewController  ========= err:%@", err);
    }
}

/**
 *  初始化声音功能对象
 */
- (void)initializeAudio {
    // 初始化数组
    self.arrDatas = [NSMutableArray new];
    
    // 创建一个音频会话对象
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 创建一个存储错误信息对象
    NSError *err = nil;
    // 设置声频播放和录制的类别
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    // 判断
    if (err) {
        NSLog(@"%@", err);
    } else {
        // 激活
        [session setActive:YES error:&err];
        if (err) {
            NSLog(@"%@", err);
        }
    }
}

/**
 *  通知响应
 */
- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti {
    if (self.talksMarray.count >= 4 || self.talkHight >= kScreenH * 0.65) {
        // 改变最底层颜色 放置键盘位置上移时出现的黑色区域
        self.view.window.backgroundColor = self.tableView.backgroundColor;
        
        // 获取键盘弹出结束的实时位置
        CGRect temp = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        // 弹出时间
        CGFloat time = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        // 计算view对应移动的位置
        CGFloat y = temp.origin.y - self.view.frame.size.height;
        // 动画效果
        [UIView animateWithDuration:time animations:^{
            // 形变位移
            self.view.transform = CGAffineTransformMakeTranslation(0, y);
        }];
    }
}
#pragma mark - 本类方法
- (void)createNib:(NSString *)name {
    // 创建nib
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    // 注册nib
    [self.tableView registerNib:nib forCellReuseIdentifier:name];
}

// 设置好友信息
- (void)setFriendInfo:(XMPPUserCoreDataStorageObject *)user {
    XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:user.jidStr];
    // 设置标题
    self.title = temp.nickname;
    // 存储用户信息
    self.user = user;
}

/**
 *  添加按钮点击
 */
- (IBAction)addButtonClick:(UIButton *)sender {
    // 回收键盘
    [self.textField resignFirstResponder];
    
    if (self.isInputViewUp) {
        [self inputViewBack];
    } else {
        [UIView animateWithDuration:0.17 animations:^{
            CGRect temp = self.inputAddView.frame;
            temp.origin.y = kScreenH - kInputViewH;
            self.inputAddView.frame = temp;
            
            // 计算view对应移动的位置
            CGRect tempView = self.view.frame;
            tempView.origin.y -= kInputViewH;
            // 形变位移
            self.view.frame = tempView;
        }];
        // 状态取反
        self.isInputViewUp = YES;
    }
}

/**
 *  inputView缩回
 */
- (void)inputViewBack {
    [UIView animateWithDuration:0.17 animations:^{
        CGRect temp = self.inputAddView.frame;
        temp.origin.y = kScreenH + kInputViewH;
        self.inputAddView.frame = temp;
        
        // 计算view对应移动的位置
        CGRect tempView = self.view.frame;
        tempView.origin.y += kInputViewH;
        // 形变位移
        self.view.frame = tempView;
    }];
    // 状态取反
    self.isInputViewUp = NO;
}

#pragma mark - 导航栏右侧按钮
/**
 *  创建导航栏右侧按钮
 */
- (void)createRightItem {
    // 创建导航栏右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明单人"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    // 设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick {
    LFSeeInfoViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LFSeeInfoViewController"];
    // 传递基础用户信息
    vc.obj = self.user;
    vc.temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:self.user.jidStr];
    
    // 跳转
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏后退按钮
/**
 *  创建后退按钮
 */
- (void)createBackItem {
    // 创建item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"透明返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    // 设置item
    self.navigationItem.leftBarButtonItem = item;
}
                             
- (void)backItemClick {
    // 跳回
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  声音按钮点击
 */
- (IBAction)audioButtonClick:(UIButton *)sender {
    // 回收键盘
    [self.textField resignFirstResponder];
    
    if (self.isInputViewUp) {
        // 视图回去
        [self inputViewBack];
        self.audioButton.selected = YES;
        // 显示说话键
        self.audioSpeakButton.hidden = NO;
        // 隐藏文本框
        self.textField.hidden = YES;
        return;
    }
    self.audioButton.selected = !self.audioButton.isSelected;
    // 显示说话键
    self.audioSpeakButton.hidden = !self.audioSpeakButton.hidden;
    // 隐藏文本框
    self.textField.hidden = !self.textField.hidden;
}

/**
 *  开始录音
 */
- (IBAction)audioSpeakButtonClick:(UIButton *)sender {
    // 显示录音视图
    self.audioView.hidden = NO;
    
    // 创建存放错误信息
    NSError *err = nil;
    // 初始化对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[self getPath] settings:[self getAudioSetting] error:&err];
    
    if (err) {
        NSLog(@"error:%@", err);
    } else {
        // 准备录音
        [self.recorder prepareToRecord];
        // 开始录音
        [self.recorder record];
        
        // 开始定时器
//        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
}

/**
 *  结束录音
 */
- (IBAction)audioSpeakButtonClickOver:(UIButton *)sender {
    // 停止动画
    [self.audioView stopAnimating];
    // 隐藏录音视图
    self.audioView.hidden = YES;
    /* 结束录音 */
    [self.recorder stop];
    
    /* 上传到服务器 */
    // 从沙盒读取二进制音频数据
    NSData *voiceData = [NSData dataWithContentsOfFile:self.audioPath];
    // 转为字符串
    NSString *strVoice = [voiceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    // 发送语音
    [[LFXMPPHelp shareXMPPHelp] xmppTalkToFriend:self.user.jidStr andMessage:strVoice andMessageType:audio];
}

#pragma mark - 语音视图
/**
 *  创建语音视图
 */
- (void)createVoiceView {
    // 创建view
    self.audioView = [[LFChatAudioView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44)];
    // 设置隐藏
    self.audioView.hidden = YES;
    // 添加视图
    [self.view addSubview:self.audioView];
}

/**
 *  获取音频存放的地址(录音1)
 */
- (NSURL *)getPath {
    // 获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接文件名
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"corder%@.caf", [NSDate getNowTime]]];
    // 存储沙盒地址
    self.audioPath = path;
//    // 创建文件管理对象
//    NSFileManager *manager = [NSFileManager defaultManager];
//    // 创建存储错误的信息
//    NSError *err = nil;
//    // 获取文件属性
//    NSDictionary *dict = [manager attributesOfItemAtPath:path error:&err];
//    NSLog(@"%@", dict);
//    // 输出文件大小
//    NSLog(@"fileSize:%@", dict[NSFileSize]);
    
//    NSLog(@"%@", path);
    
    return [NSURL fileURLWithPath:path];
}

// 设置音频配置
- (NSDictionary *)getAudioSetting {
    // 创建可变字典对象
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    // 设置音频录制格式
    mDic[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    // 设置音频采样率 8000 41000 90000+
    mDic[AVSampleRateKey] = @(8000);
    // 设置声道 1:单声道 2:立体声
    mDic[AVNumberOfChannelsKey] = @(1);
    // 设置每个采样的点位数 (8, 16(网络常见), 24, 32)
    mDic[AVLinearPCMBitDepthKey] = @(8);
    // 设置使用浮点数进行采样
    mDic[AVLinearPCMIsFloatKey] = @(YES);
    
    return mDic;
}

#pragma mark - 界面出现前后

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    
//    // 获取消息管理
//    self.fetch = [[LFXMPPHelp shareXMPPHelp] xmppGetMessageLocalWithFriendName:self.user.jidStr];
//    // 设置代理
//    self.fetch.delegate = self;
    
//    NSError *err = nil;
//    // 开始工作
//    [self.fetch performFetch:&err];
//    if (err) { // 如果请求失败
//        NSLog(@"LFChatViewController  ========= err:%@", err);
//    }
    [self.tableView reloadData];
    // 界面移到最下端
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:self.talksMarray.count - 1 inSection:0];
    if (self.talksMarray.count > 1) { // 如果数组有内容 并且大小不小于1
        [self.tableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)nearestName {
//    // 截取存储用的格式名
//    NSString *newName = [[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:self.user.jidStr].user;
//    // 存入沙盒
//    [LFUserInfo nearestFriend:newName];
//}

#pragma mark - ResultController的代理
/**
 *  当消息记录变化时
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // 数组重新复制
    [self.talksMarray removeAllObjects];
    [self.talksMarray addObjectsFromArray:self.fetch.fetchedObjects];
    // 刷新表格
    [self.tableView reloadData];
    
    // 界面移到最下端
    if (self.talksMarray.count > 1) { // 消息大于两条
        NSIndexPath *indePath = [NSIndexPath indexPathForRow:self.talksMarray.count - 1 inSection:0];
        // 表格移到最下方
        [self.tableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - scrollView代理
/**
 *  当scroll开始拖拽时响应
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 结束编辑模式 会自动回收键盘
    [self.view endEditing:YES];
}

#pragma mark - 表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.talksMarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = self.fetch.fetchedObjects[indexPath.row];
    NSString *msgType = [msg.message attributeStringValueForName:@"bodyType"]; // 获取消息类型
    // 获取是本人发送还是好友发送
    BOOL role = [msg.outgoing boolValue];
    if (role) { // 如果是本人发送
        if ([msgType isEqualToString:@"text"]) { // 如果是文本类型
            LFMyChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMyChatTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            // 获取自己的明信片
            XMPPvCardTemp *myCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
            // 设置单元格信息
            cell.temp = myCard;
            // 设置消息内容
            [cell setCell:msg];
            
            
            return cell;
        }
        
        if ([msgType isEqualToString:@"audio"]) { // 如果是图片类型
            LFMySpeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMySpeakTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            
            // 获取音频二进制
            NSData *data = [[NSData alloc] initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSError *err = nil;
            // 创建player
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&err];
            if (err) {
                NSLog(@"LFChatViewController  err:%@", err);
            }
            // 获取自己的明信片
            XMPPvCardTemp *myCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
            // 设置单元格信息
            cell.temp = myCard;
            // 设置cell
            [cell setCell:self.player andTime:[NSDate getMsgDate:msg.timestamp]];
            
            return cell;
        }
        
        if ([msgType isEqualToString:@"image"]) { // 如果是图片类型
            LFMyImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMyImageTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            // 获取自己的明信片
            XMPPvCardTemp *myCard = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
            // 设置单元格信息
            cell.temp = myCard;
            // 设置cell
            [cell setCell:msg];
            
            return cell;
        }
    } else {
        if ([msgType isEqualToString:@"text"]) {
            LFChatTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFChatTalkTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            // 获取用户数据
            XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:msg.bareJidStr];
            // 传输用户数据
            cell.temp = temp;
            // 设置消息内容
            [cell setCell:msg];
            
            
            return cell;
        }
        
        if ([msgType isEqualToString:@"audio"]) {
            LFOtherSpeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFOtherSpeakTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            
            // 获取音频二进制
            NSData *data = [[NSData alloc] initWithBase64EncodedString:msg.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSError *err = nil;
            // 创建player
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&err];
            if (err) {
                NSLog(@"LFChatViewController  err:%@", err);
            }
            // 获取用户数据
            XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:msg.bareJidStr];
            // 传输用户数据
            cell.temp = temp;
            // 传送用户消息
            cell.obj = msg;
            // 设置cell
            [cell setCell:self.player andTime:[NSDate getMsgDate:msg.timestamp]];
            
            return cell;
        }
        
        if ([msgType isEqualToString:@"image"]) {
            LFOtherImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFOtherImageTableViewCell" forIndexPath:indexPath];
            // 设置被选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 设置透明背景颜色
            cell.backgroundColor = [UIColor clearColor];
            // 获取用户数据
            XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp] xmppGetFriendInfoWithUsername:msg.bareJidStr];
            // 传输用户数据
            cell.temp = temp;
            // 设置cell
            [cell setCell:msg];
            
            return cell;
        }
        
    }
    // 创建cell
    LFOtherSpeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFOtherSpeakTableViewCell" forIndexPath:indexPath];
    // 设置被选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置透明背景颜色
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取对应的信息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = self.talksMarray[indexPath.row];
    NSString *msgType = [msg.message attributeStringValueForName:@"bodyType"];
    if ([msgType isEqualToString:@"text"]) {
        // 计算文本的准确大小
        CGSize messageSize = [NSString calStrSize:msg.body andWidth:120.0f andFontSize:15.0f];
        CGFloat temp = 70 + messageSize.height;
        self.talkHight += temp;
        return temp;
    }
    
    if ([msgType isEqualToString:@"image"]) {
        self.talkHight += 130;
        return 130;
    }
    self.talkHight += 70;
    return 70;
}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 发送请求到服务器
    [[LFXMPPHelp shareXMPPHelp] xmppTalkToFriend:self.user.jidStr andMessage:self.textField.text andMessageType:text];
    // 文本框清空
    self.textField.text = @"";
    
    return YES;
}

#pragma mark - imagePicker代理
/**
 *  选中图片后
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 退出图片选择
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    // 视图缩回
    [self inputViewBack];
    // 设置图片
    UIImage *img = info[UIImagePickerControllerEditedImage];
    CGSize imagesize = img.size;
    imagesize.height =70;
    imagesize.width = 100;
    
    // 转为二进制并压缩
    UIImage *newImage = [UIImage imageWithImage:img scaledToSize:imagesize];
    NSData *data = UIImageJPEGRepresentation(img, 0.7f);
    // 转为字符串
    NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    // 发送请求
    [[LFXMPPHelp shareXMPPHelp] xmppTalkToFriend:self.user.jidStr andMessage:imageStr andMessageType:image];
}


@end
