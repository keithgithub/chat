//
//  SendTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/3.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "SendTableViewController.h"
#import "XMPPHelp+Friend.h"
#import "UserInfo.h"
#import "FriendesListTableViewCell.h"
#import "XMPPHelp+Message.h"
#import "MBProgressHUD+MJ.h"

@interface SendTableViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultsContrl;
}

@property(nonatomic,strong)NSMutableArray *arrFriends;//好友
// 在线好友
@property(nonatomic,strong) NSMutableArray *arrOnline;
// 离线好友
@property(nonatomic,strong) NSMutableArray *arrUnOnline;


@end

@implementation SendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrFriends=[NSMutableArray  new];
    self.arrOnline=[NSMutableArray  new];
    self.arrUnOnline=[NSMutableArray  new];
    
    self.title = @"转发";

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // 注册nib
    UINib *nib = [UINib nibWithNibName:@"FriendesListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"friendCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self getFriendList];
    [self  loadFriends2];
    
}

-(void)getFriendList
{
    XMPPHelp *xmppH=[XMPPHelp  shareXmpp];
    
    _resultsContrl= [xmppH  getFriends];
    
    xmppH.fetFriend.delegate=self;
    
}

-(void)loadFriends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    XMPPHelp  *xmppH=[XMPPHelp shareXmpp];
    
    NSManagedObjectContext *context = xmppH.rosterStorage.mainThreadManagedObjectContext;
    
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    UserInfo *user=[UserInfo  shareUser];
    // 过滤当前登录用户的好友
    NSString *jid = [NSString  stringWithFormat:@"%@@%@",user.loginName,domain];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultsContrl.delegate = self;
    
    NSError *err = nil;
    [_resultsContrl performFetch:&err];
    if (err) {
   }
    
    [self dealData];
}

/**
 *  好友信息过滤，只显示互为好友
 */
-(void)dealData
{
    // 取出原来的数组
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrOnline];
    
    [self.arrFriends  removeAllObjects];
    [self.arrOnline removeAllObjects];
    [self.arrUnOnline removeAllObjects];
    
    for (XMPPUserCoreDataStorageObject *obj in _resultsContrl.fetchedObjects)
    {
        if ([obj.subscription  isEqualToString:@"both"])
        {
            [self.arrFriends  addObject:obj];
        }
    }
    for (XMPPUserCoreDataStorageObject *obj in self.arrFriends)
    {
        if ([obj.sectionNum intValue] == 0)
        {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:obj forKey:@"obj"];
            [dic setObject:@"0" forKey:@"count"];
            [self.arrOnline  addObject:dic];
        }
        if ([obj.sectionNum intValue] == 2)
        {
            [self.arrUnOnline addObject:obj];
        }
    }
    
    // 循环比对  拿出原来的消息个数  加到新的数组
    for (int i = 0; i<arr.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        XMPPUserCoreDataStorageObject *obj = dic[@"obj"];
        
        NSString *count = dic[@"count"];
        NSString *jid = obj.jidStr;
        
        for (int j = 0;j <self.arrOnline.count;j++ )
        {
            NSMutableDictionary *dic_new = [NSMutableDictionary dictionaryWithDictionary:self.arrOnline[j]];
            XMPPUserCoreDataStorageObject *obj_new = dic_new[@"obj"];
            
            NSString *jid_new = obj_new.jidStr;
            if ([jid isEqualToString:jid_new])
            {
                [self.arrOnline[j] removeObjectForKey:@"count"];
                [self.arrOnline[j] setObject:count forKey:@"count"];
            }
        }
        
        
    }
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        XMPPUserCoreDataStorageObject *obj=self.arrOnline[indexPath.row][@"obj"];
        XMPPHelp *xmpph=[XMPPHelp  shareXmpp];
        
        if (self.textMsg.text == nil)
        {
            //1.数据转换（xmpp中传输图片只能用base64Encoding编码）
            NSData *imageData = UIImageJPEGRepresentation(self.img, 0.2);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            //发送图片
            [[XMPPHelp  shareXmpp]talkToFriend:obj.jid andMsg:imageStr andMsgType:image];
        }
        else
        {
           [xmpph  talkToFriend:obj.jid andMsg:self.textMsg.text andMsgType:text];
        }
    }
    else
    {
        XMPPUserCoreDataStorageObject *obj=self.arrUnOnline[indexPath.row];
        XMPPHelp *xmpph=[XMPPHelp  shareXmpp];
        
        if (self.textMsg.text == nil)
        {
            //1.数据转换（xmpp中传输图片只能用base64Encoding编码）
            NSData *imageData = UIImageJPEGRepresentation(self.img, 0.2);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            //发送图片
            [[XMPPHelp  shareXmpp]talkToFriend:obj.jid andMsg:imageStr andMsgType:image];
        }
        else
        {
            [xmpph  talkToFriend:obj.jid andMsg:self.textMsg.text andMsgType:text];
        }
    }
    
    [MBProgressHUD showSuccess:@"转发成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
    {
        return self.arrOnline.count;
    }
    else
    {
        return self.arrUnOnline.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendesListTableViewCell  *cell=[tableView  dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    // 取消选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置cell
    if (indexPath.section == 0)// 在线
    {
        XMPPUserCoreDataStorageObject  *obj=self.arrOnline[indexPath.row][@"obj"];
        [cell setCell:obj andFriendvCad: [XMPPHelp  searchFriendDetailInfo:obj.jid]andCountDic:self.arrOnline[indexPath.row]];
    }
    else// 离线
    {
        XMPPUserCoreDataStorageObject  *obj=self.arrUnOnline[indexPath.row];

        cell.isOnLine = YES;
        [cell setCell:obj andFriendvCad: [XMPPHelp  searchFriendDetailInfo:obj.jid]andCountDic:nil];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
