//
//  ChatViewController.m
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "ChatViewController.h"
#import "CharTableView.h"
#import "InputView.h"
#import "AddView.h"
#import "VoiceView.h"
#import "XMPPvCardTemp.h"
#import "XMPPHelp.h"
#import "XMPPHelp+Friend.h"
#import "SetBgTableViewController.h"
#import "SendTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyAlertClass.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD+MJ.h"

#define kScreen_size [UIScreen mainScreen].bounds.size

#define MYLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])


@interface ChatViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSFetchedResultsControllerDelegate,CharTableViewDelegate,SetBgTableViewControllerDelegate,InputViewDelegate,UIScrollViewDelegate>
{
    CGFloat keyboardhight;//键盘高度
}
@property(nonatomic,strong)CharTableView  *cTableView;//聊天视图
@property(nonatomic,strong)InputView   *inputView;//输入视图
@property(nonatomic,strong)AddView *addView;//点加号出现的视图
@property(nonatomic,strong)VoiceView *voiceView;//录音视图

// 自己头像
@property (nonatomic,strong) UIImage *imgF;
// 好友头像
@property (nonatomic,strong) UIImage *imgS;

// 图片消息视图
@property (nonatomic,strong) UIView *imgMsgView;

// 图片消息
@property (nonatomic,strong) UIImageView *imgVMsg;


// 背景视图
@property (nonatomic,strong) UIImageView *imgVBG;
// 转发视图
@property (nonatomic,strong) UIView *sendView;

// 需要转发的图片
@property (nonatomic,strong) UIImage *sendImg;
// 需要转发的文字
@property (nonatomic,copy) NSString *sendText;

@property(nonatomic,assign)BOOL imgVState;// 标示图片放大还是缩小 yes 大 no 缩小
@property(nonatomic,assign)CGFloat rotation;// 记录每次旋转后的值

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSString *str = [UserInfo getFriendInforFromSanBoxAndKey:self.fridendJid.user][@"bg"];
    if (str == nil)
    {
        //背景视图
        self.imgVBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_8"]];
    }
    else
    {
        //背景视图
        self.imgVBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
    }
    self.imgVBG.frame = self.view.bounds;
    [self.view addSubview:self.imgVBG];

    //        每个IOS应用都有一个音频会话。
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err=nil;
    //这个类别非常像AVAudioSessionCategoryAmbient类别，除了会停止其他程序的音频回放，比如iPod程序。当设备被设置为静音模式，你的音频回放将会停止。
    //AVAudioSessionCategoryPlayAndRecord
    //    这个类别允许你的应用中同时进行声音的播放和录制。当你的声音录制或播放开始后，其他应用的声音播放将会停止。主UI界面会照常工作。这时，即使屏幕被锁定或者设备为静音模式，音频回放和录制都会继续。
    [audioSession  setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    //激活会话
    [audioSession  setActive:YES error:&err];
    
    //创建聊天的表格
    self.cTableView=[[CharTableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_SIZE.width, SCREEN_SIZE.height-104) style:UITableViewStylePlain];
    // 下载头像
    [self loadHeadImg];
    // 传递头像图片
    self.cTableView.firendHead = self.imgF;
    self.cTableView.selfHead = self.imgS;
    self.cTableView.myDelegate = self;
    //self.cTableView.delegate = self;
    [self.view  addSubview:self.cTableView];
    
    
    self.addView=[[AddView  alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 120) andSendImage:^(NSInteger type)
                  {
                      //        MYLog(@"%ld",(long)type);
                      [self  open:type];//0:相机,1:相册
                      
                  }];
    [self.view addSubview:self.addView];
    //创建录音视图
    self.voiceView=[[VoiceView  alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 150) andRecordeBlock:^(NSString *voicePath) {
        //MYLog(@"录音地址：%@",voicePath);
        NSData *voiceData=[NSData  dataWithContentsOfFile:voicePath];
        NSString *strVoice=[voiceData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //发送语音
        [[XMPPHelp  shareXmpp]talkToFriend:self.fridendJid andMsg:strVoice andMsgType:audio];
    }];
    
    [self.view addSubview:self.voiceView];
    
    //聊天输入界面（回调的代码块：有3种：添加，(表情用系统的这边没实现)，发送，三个按钮的点击响应）
    self.inputView=[[InputView  alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height-40, SCREEN_SIZE.width, 50) andPhotoBlock:^(NSDictionary *dic,NSInteger index) {
        
        self.inputView.delegate = self;
        
        if (index==103)//发送消息
        {
           
            XMPPHelp *xmpph=[XMPPHelp  shareXmpp];
            
            [xmpph  talkToFriend:self.fridendJid andMsg:dic[@"content"] andMsgType:text];
            #pragma mark 待修改****************
            //[self closeViewLayout];
            
        }
        else if(index==101)//弹出+号功能按钮
        {
            //改变界面布局
            if (![dic[@"isSelect"]  boolValue])
            {
                //打开
                [self  changeViewLayout];
            }
            else
            {
                //关闭
                [self  closeViewLayout];
            }
            
        }
        else if(index==104)//语音
        {
            //改变界面布局
            if (![dic[@"isSelectVoice"]  boolValue])
            {
                //打开
                [self  openVoiceViewLayout];
            }
            else
            {
                //关闭
                [self  closeViewLayout];
            }

        }
        
    
    }];
    
    [self.view addSubview:self.inputView];
    

    [self  getMessageLocal];//获取聊天记录
    // 添加导航栏按钮
    [self creacetNavigationItem];
}

#pragma mark inputView 代理
- (void)closeView
{
    [self closeViewLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
    // 设置标题
    [self setMyControllerTitle];
}

- (void)setMyControllerTitle
{
    XMPPvCardTemp *vCad = [XMPPHelp searchFriendDetailInfo:self.fridendJid];
    
    // 获取本地沙盒保存的备注名称  如果没有设置为nickNaem  如果没有就设置为账号
    NSString *str = [UserInfo getFriendInforFromSanBoxAndKey:self.fridendJid.user][@"name"];
    if (str == nil)//姓名
    {
        if (vCad.nickname == nil)
        {
            self.title = self.fridendJid.user;
        }
        else
        {
            NSLog(@"---------------9%@",vCad.nickname);
            self.title = vCad.nickname;//好友账户名
        }
        
    }
    else
    {
        self.title = str;
    }

}



#pragma mark  创建导航栏按钮
- (void)creacetNavigationItem
{
    // 左侧按钮
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_icon_back_fire"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    // 右侧按钮
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"camera_filter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    
    // 添加
    self.navigationItem.leftBarButtonItem = LeftItem;
    self.navigationItem.rightBarButtonItem = RightItem;
    
}

- (void)pop
{
    [self.delegate removeCount:self.fridendJid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting
{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetBgTableViewController *setVC = [storyboard instantiateViewControllerWithIdentifier:@"setBG"];
    setVC.delegate = self;
    setVC.friendName = [UILabel new];
    setVC.friendName.text = self.fridendJid.user;
    
    // 如是查看图片状态就关闭
    [self tapAction];
    
    [self.navigationController pushViewController:setVC animated:YES];
}

// 背景控制器代理
- (void)setBG:(UIImage *)img
{
    self.imgVBG.image = img;
}

#pragma mark -

// 获取好友头像 和自己头像
- (void)loadHeadImg
{
    self.imgF = [UIImage new];
    self.imgS = [UIImage new];
   
   // 获取好友头像    3031463@112.74.105.205/iPhone"
   self.imgF = [UIImage  imageWithData:[XMPPHelp  searchFriendDetailInfo:self.fridendJid].photo];
    
   //xmpp提供了一个方法，直接获取个人信息
   XMPPvCardTemp *myVCard =[XMPPHelp shareXmpp].vCard.myvCardTemp;
   self.imgS = [UIImage imageWithData:myVCard.photo];
    
    if (self.imgF == nil)
    {
        self.imgF = [UIImage imageNamed:@"ioco_head1.jpg"];
    }
    if (self.imgS == nil)
    {
        self.imgS = [UIImage imageNamed:@"avtar_120_default"];
    }
}

-(void)getMessageLocal
{
    // 上下文
    NSManagedObjectContext *context = [XMPPHelp shareXmpp].msgStorage.mainThreadManagedObjectContext;
    // 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSString *userJid=[NSString  stringWithFormat:@"%@@%@",[UserInfo shareUser].loginName,domain];
    XMPPJID *friendJid=self.fridendJid;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",userJid,friendJid.bare];
    request.predicate = pre;
    
    // 时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    self.cTableView.resultsContr = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    // 代理
    self.cTableView.resultsContr.delegate = self;
    
    [self.cTableView.resultsContr performFetch:&err];
    [self.cTableView  scrollToTableBottom];
   // MYLog(@"%@",self.cTableView.resultsContr.fetchedObjects);
    if (err) {
        MYLog(@"%@",err);
    }
    
}

#pragma mark ResultController的代理 聊天数据发生改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    // 刷新数据
    [self.cTableView reloadData];
    [self.cTableView scrollToTableBottom];
    
    [self saveMsgToSanbox];
}

#pragma mark 保存聊天记录到沙盒
- (void)saveMsgToSanbox
{
    //NSLog(@"55555555%@",self.arrJid[0]);
    // 获取单例
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 用名称为key  去获取聊天记录
    NSString *msg_key = [UserInfo shareUser].loginName;
    NSMutableArray *arr_name = [NSMutableArray arrayWithArray:[def objectForKey:msg_key]];
    
    // 查找是否存在消息记录
    BOOL msg = NO;
   
    for (int i = 0; i<arr_name.count; i++)
    {
        NSString *f_name = self.arrJid[0];
        NSString *name = arr_name[i];
        
        if ([name isEqualToString:f_name])
        {
            msg = YES;
            break;
        }
        
    }
    // 名字不存在 添加名字到数组
    if (!msg)
    {
        // 添加到数组
        [arr_name addObject:self.arrJid[0]];
    }
    
    // 保存到沙盒
    [def setObject:arr_name forKey:msg_key];
    
}

#pragma mark 查看图片

- (void)showImg:(UIImage *)img
{
    self.imgMsgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.imgMsgView.backgroundColor = [UIColor blackColor];
    
    
    self.imgVMsg = [[UIImageView alloc] initWithImage:img];
    self.imgVMsg .frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.imgVMsg.userInteractionEnabled = YES;
    self.imgVMsg.backgroundColor = [UIColor blackColor];
    
    // 自适应 宽高
    
    self.imgVMsg.contentMode=UIViewContentModeScaleAspectFit;
    
    self.imgVMsg.clipsToBounds = YES;

    // 单击的 Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    

    // 创建捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.imgVMsg addGestureRecognizer:pinch];
    
    // 创建拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.imgVMsg addGestureRecognizer:pan];

    [self.imgVMsg addGestureRecognizer:longPress];
    [self.imgMsgView  addGestureRecognizer:tap];
    [self.imgMsgView addSubview:self.imgVMsg];
    [self.view addSubview:self.imgMsgView ];
   
    [self.inputView.txtInput resignFirstResponder];
    [self closeViewLayout];
}
#pragma mark 保存图片到本地

// 捏合手势
- (void)pinchAction:(UIPinchGestureRecognizer* ) sender
{
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
    
}

// 拖动手势
- (void)panAction:(UIPanGestureRecognizer *)sender
{
    // 获取手势在屏幕上拖动的点
    CGPoint p = [sender translationInView:self.view];
    // 设置中心点
    sender.view.center = CGPointMake(sender.view.center.x+p.x,sender.view.center.y +p.y );
    // 设置视图在父视图上拖动的位置
    [sender setTranslation:CGPointZero inView:self.view];
    
}
- (void)longPress:(UILongPressGestureRecognizer*)sender
{
   // 创建提示框
    UIAlertController *aleVC = [MyAlertClass alertControllerWithTitle:@"保存图片" andTitle2:@"发送给朋友" andHander1:^{
      
        // 保存到本地
       [self saveToALAssetsLibrary];
       
   } andHander2:^{
       
       // 创建转发控制器
       SendTableViewController *sendVC = [SendTableViewController new];
       sendVC.img = self.imgVMsg.image;
       sendVC.textMsg = [UILabel new];
       // 移除提示框
       [aleVC dismissViewControllerAnimated:YES completion:^{
           
       }];
       
       // 跳转
       [self.navigationController pushViewController:sendVC animated:YES];
       
   }];
    
    
    
    // 显示提示框
    [self presentViewController:aleVC animated:YES completion:^{
        
    }];
}

- (void)saveToALAssetsLibrary
{
    // 保存到本地相册
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:self.imgVMsg.image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
        }
        [MBProgressHUD showSuccess:@"保存成功"];
    }];
}

- (void)tapAction
{
    [self.sendView removeFromSuperview];
    [self.imgMsgView removeFromSuperview];
}

#pragma mark -

#pragma mark 转发
// 转发文本
- (void)showSenderView_txt:(NSString *)text
{
    
    self.sendText = text;
    self.sendImg = nil;
    [self creacteSendView];
}
// 转发图片
- (void)showSenderView:(UIImage *)img
{
    self.sendText = nil;
    self.sendImg = img;
    [self creacteSendView];
}

- (void)creacteSendView
{
    self.sendView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.sendView .center = self.view.center;
    self.sendView .backgroundColor = [UIColor blackColor];
    self.sendView .layer.cornerRadius = 5 ;
    self.sendView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"转发" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    btn.frame =CGRectMake(kScreen_size.width/2-50, kScreen_size.height/2, 50, 30);
    btn.tag = 10;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreen_size.width/2, kScreen_size.height/2+2, 0.5, 26)];
    line.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"复制" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor blackColor]];
    btn1.frame =CGRectMake(kScreen_size.width/2-5, kScreen_size.height/2, 55, 30);
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.tag = 11;
    btn1.layer.cornerRadius = 5;
    [btn1 addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSendMsgAction)];
    
    if (self.sendImg != nil)
    {
        btn1.hidden = YES;
        line.hidden = YES;
        btn.center = self.view.center;
    }

    [self.sendView addSubview:btn1];
    [self.sendView addSubview:btn];
    [self.sendView addSubview:line];
    [self.sendView addGestureRecognizer:tap];
    [self.view addSubview:self.sendView ];
}

- (void)btnSenderAction:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        SendTableViewController *sendVC = [SendTableViewController new];
        sendVC.img = self.sendImg;
        sendVC.textMsg = [UILabel new];
        sendVC.textMsg.text = self.sendText;
        
        [self.sendView removeFromSuperview];
        [self.navigationController pushViewController:sendVC animated:YES];
    }
    else
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
       
        pasteboard.string = self.sendText;
       
        [self tapSendMsgAction];
    }
    
}
// 取消转发
- (void)tapSendMsgAction
{
    [self.sendView removeFromSuperview];
    
}
// 滚动关闭输入框
- (void)cloesInputView
{
    [self closeViewLayout];
    [self.inputView.txtInput resignFirstResponder];
}
#pragma mark -

#pragma mark 语音打开可关闭
/**
 *  语音打开
 */
-(void)openVoiceViewLayout
{
    [UIView animateWithDuration:0.3 animations:^{
        self.cTableView.frame=CGRectMake(0, 64,SCREEN_SIZE.width, SCREEN_SIZE.height-104-150);
        self.inputView.frame=CGRectMake(0, SCREEN_SIZE.height-40-150, SCREEN_SIZE.width, 40);
        self.addView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 120);
        self.voiceView.frame=CGRectMake(0, SCREEN_SIZE.height-150, SCREEN_SIZE.width, 150);
    }];
    
    
}



#pragma end  mark


#pragma mark  加号打开和关闭
/**
 *  加号打开
 */
-(void)changeViewLayout
{
    [UIView animateWithDuration:0.3 animations:^{
        self.cTableView.frame=CGRectMake(0, 64,SCREEN_SIZE.width, SCREEN_SIZE.height-104-120);
        self.inputView.frame=CGRectMake(0, SCREEN_SIZE.height-40-120, SCREEN_SIZE.width, 40);
        self.addView.frame=CGRectMake(0, SCREEN_SIZE.height-120, SCREEN_SIZE.width, 120);
        self.voiceView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 150);
    }];
    
    
}
/**
 *  加号关闭
 */
-(void)closeViewLayout
{
    [UIView animateWithDuration:0.3 animations:^{
        self.cTableView.frame=CGRectMake(0, 64,SCREEN_SIZE.width, SCREEN_SIZE.height-104);
        self.inputView.frame=CGRectMake(0, SCREEN_SIZE.height-40, SCREEN_SIZE.width, 40);
        self.addView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 120);
        self.voiceView.frame=CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, 150);
    }];
}


#pragma mark  相机
/**
 *  去相机或相册获取照片
 *
 *  @param index 0代表拍照，1代表图片
 */
-(void)open:(NSInteger)index
{
    //创建显示图片的pick
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
    //picker.allowsEditing = YES;
    
    //设置风格
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (index==0)//选择相机
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])//如果有相机（因为模拟器没有）
        {
            //设置资源类型从相机获取
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
            picker.showsCameraControls  = YES;
            picker.delegate = self;//设置代理
            //调用相机拍照
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else//否则提示没相机功能
        {
            //警告框提示
            //            [Config  showAlertWith:@"信息提示!" andMessage:@"你没有摄像头"];
            MYLog(@"没有相机");
        }
    }
    else if(index==1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])//图库获取图片
        {
            //设置资源来事相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;//设置代理
            //调用相册
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else
        {
            //警告框提示
            //            [Config  showAlertWith:@"信息提示!" andMessage:@"你没有相册"];
            MYLog(@"没有相册");
            
        }
    }
}
#pragma mark 选择图片
//选中图片进入的代理方法
/**
 *  选好图片调用的代理方法
 *
 *  @param picker      显示选择图片的界面
 *  @param image       选中的图片
 *  @param editingInfo 编辑消息描述
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];//推回弹出的相册或照相机
    UIImage  *img=info[UIImagePickerControllerOriginalImage];
    
    //1.数据转换（xmpp中传输图片只能用base64Encoding编码）
    NSData *imageData = UIImageJPEGRepresentation(img, 0.2);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //发送图片
    [[XMPPHelp  shareXmpp]talkToFriend:self.fridendJid andMsg:imageStr andMsgType:image];

}





//在遇到有输入的情况下。由于现在键盘的高度是动态变化的。中文输入与英文输入时高度不同。所以输入框的位置也要做出相应的变化
#pragma mark - keyboardHight

/**
 *  注册监听键盘
 */
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 键盘出实现时
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
/**
 *  实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
 *
 *  @param aNotification
 */
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為键盘尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到键盘的高度
    MYLog(@"hight_hitht:%f",kbSize.height);
    keyboardhight=kbSize.height;
    [UIView  animateWithDuration:0.001 animations:^{
        self.cTableView.frame=CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height-64-keyboardhight-40);
        self.inputView.frame=CGRectMake(0, SCREEN_SIZE.height-keyboardhight-40, SCREEN_SIZE.width, 40);
    }];
    
    
}

/**
 *  当键盘隐藏的时候
 *
 *  @param aNotification
 */
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView  animateWithDuration:0.01 animations:^{
        self.cTableView.frame=CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height-64-40);//64：导航栏高度，40：输入框高度
        self.inputView.frame=CGRectMake(0, SCREEN_SIZE.height-40, SCREEN_SIZE.width, 40);
    }];
}

/**
 *  移除键盘通知
 *
 *  @param animated
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
