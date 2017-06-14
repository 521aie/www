//
//  SeatItemCell.m
//  RestApp
//
//  Created by zxh on 14-10-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SeatItemCell.h"
#import "Seat.h"
#import "SeatRender.h"

@implementation SeatItemCell

-(void) loadItem:(Seat*)data delegate:(id<DHListSelectHandle>) handle
{
    self.delegate=handle;
    self.item=data;
    
    self.lblName.text= [data obtainItemName];
    self.lblDetail.text=[SeatRender seatDetailFormat:data];
    self.lblType.text=[SeatRender formatSeatKind:self.item.seatKind];
    [self.iconView.layer setMasksToBounds:YES];
    [self.iconView.layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [self.iconView.layer setBorderColor:[color CGColor]];
    self.iconView.layer.cornerRadius = 5;
    
    NSString* imgPath=@"img_table_guests.png";
    [self.img setImage:[UIImage imageNamed:imgPath]];
}

@end
