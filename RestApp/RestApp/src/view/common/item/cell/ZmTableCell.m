//
//  ZmTableCell.m
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZmTableCell.h"
#import "UIHelper.h"

@implementation ZmTableCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event itemMode:(NSInteger)itemMode
{
    self.edititemList.hidden = YES;
    self.delegate=temp;
    self.obj=objTemp;
    self.event=event;
    self.itemMode=itemMode;
    [self loadItem:self.obj];
}

-(IBAction) btnDelClick:(id)sender
{
    if (self.itemMode==ITEM_MODE_DEL) {
       [self.delegate delObjEvent:self.event obj:self.obj ];
    } else if (self.itemMode==ITEM_MODE_EDIT) {
        [self.delegate showEditNVItemEvent:self.event withObj:self.obj ];
    }
}

-(void) loadItem:(id<INameValueItem>)item
{
    self.lblName.text = [item obtainItemName];
    self.lblVal.text = [item obtainItemValue];
    if (self.itemMode==ITEM_MODE_NO) {
        [self showBtn:NO];
    } else if (self.itemMode==ITEM_MODE_DEL) {
        [self showBtn:YES];
        UIImage *delImg=[UIImage imageNamed:@"ico_block.png"];
        self.imgAct.image=delImg;
    } else if (self.itemMode==ITEM_MODE_EDIT) {
        [self showBtn:YES];
        UIImage *editImg=[UIImage imageNamed:@"ico_next.png"];
        self.imgAct.image=editImg;
    }
}

-(void) showBtn:(BOOL)visibal
{
    [self.btnAct setHidden:!visibal];
    [self.imgAct setHidden:!visibal];
}

@end
