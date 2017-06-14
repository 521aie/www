//
//  SignerHeadCell.m
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignerHeadCell.h"

@implementation SignerHeadCell

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPay*)objTemp
{
    self.delegate=temp;
    self.obj=objTemp;
    self.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    NSInteger count=(self.obj.signerList==nil || self.obj.signerList.count==0)?0:self.obj.signerList.count;
    self.lblName.text=[NSString stringWithFormat:NSLocalizedString(@"%@-本店签字人%ld个", nil), self.obj.name, (long)count];
}

-(IBAction) btnEditClick:(id)sender
{
    [self.delegate showEditNVItemEvent:@"kindpay" withObj:self.obj];
}

@end
