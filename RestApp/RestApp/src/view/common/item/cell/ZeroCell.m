//
//  ZeroCell.m
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZeroCell.h"

@implementation ZeroCell

-(void) loadObj:(NameValueItemVO*)objTemp tag:(NSInteger)tag
{
    self.lblName.text=objTemp.itemName;
    self.lblVal.text=objTemp.itemVal;
    self.tag=tag;
}

@end
