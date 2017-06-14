//
//  NavigatorCell.m
//  RestApp
//
//  Created by zxh on 14-3-20.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#include "Platform.h"
#import "NavigatorCell.h"
#import "NSString+Estimate.h"

@implementation NavigatorCell

+ (id)getInstance
{
    NavigatorCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"NavigatorCell" owner:self options:nil]lastObject];
    if ([cell isKindOfClass:[NavigatorCell class]]) {
        return cell;
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NavigatorCellIdentifier];
}

- (void)initWithData:(UIMenuAction *)menuAction
{
    self.lblName.text= menuAction.name;
    self.lblDetail.text = menuAction.detail;
    [self.lblName sizeToFit];
    [self.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menuAction.code])];
    if ([NSString isNotBlank:menuAction.img]) {
        UIImage *img=[UIImage imageNamed:menuAction.img];
        self.imgMenu.image=img;
    } else {
        self.imgMenu.image=nil;
    }
}

@end
