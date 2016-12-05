//
//  EditSayTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/13.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "EditSayTableViewController.h"
#import "XMPPvCardTemp.h"
#import "XMPPHelp.h"
#import "MBProgressHUD+MJ.h"


@interface EditSayTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextView *txt;
- (IBAction)btnAction:(UIButton *)sender;

@end

@implementation EditSayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds =  YES;
    self.title = @"编辑签名";
    
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPHelp shareXmpp].vCard.myvCardTemp;
    // 签名
    self.txt.text = myvCard.givenName;
    [self.txt becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 205;
        
    }
    else
    {
       return  60;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)btnAction:(UIButton *)sender
{
    
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPHelp shareXmpp].vCard.myvCardTemp;
    // 签名
    myvCard.givenName = self.txt.text;
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[XMPPHelp shareXmpp].vCard updateMyvCardTemp:myvCard];
    
    [MBProgressHUD showSuccess:@"保存成功"];
    
    [self.navigationController popViewControllerAnimated:YES];

    
}
@end
