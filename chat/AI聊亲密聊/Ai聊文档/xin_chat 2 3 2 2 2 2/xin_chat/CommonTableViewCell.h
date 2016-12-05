//
//  CommonTableViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/25.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPHelp.h"
#import "TimeModel.h"
#import "UIImageView+WebCache.h"
@interface CommonTableViewCell : UITableViewCell
-(void)setCell:(XMPPMessageArchiving_Message_CoreDataObject*)messageObj;

@end
