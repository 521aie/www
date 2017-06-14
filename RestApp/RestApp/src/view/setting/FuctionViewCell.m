//
//  FuctionViewCell.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/17.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Platform.h"
#import "RestConstants.h"
#import "ActionConstants.h"
#import "FuctionViewCell.h"
#import "FuctionActionData.h"
#import "NSString+Estimate.h"

@implementation FuctionViewCell

- (IBAction)ClickpopVIew:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(btnClick:andFlag:)])
        [self.delegate btnClick:self andFlag:1];
}

- (IBAction)Clickselect:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(btnClick:andFlag:)])
        [self.delegate btnClick:self andFlag:0];
}
- (void)loadRadius
{
    self.imggray.hidden=NO;
    self.imggray.layer.masksToBounds=YES;
    self.imggray.layer.cornerRadius=self.imggray.frame.size.width*0.5;
    self.imggray.layer.backgroundColor=[UIColor grayColor].CGColor;
}

- (void)fullModelId:(UIMenuDetaiAction *)menuAction dataArry:(NSArray*)codeArr With:(NSInteger)tag
{
    menuAction.idCollection = [[NSMutableArray  alloc] init];
    if (tag ==0) {
        for (FuctionActionData *data in codeArr) {
            if ([data.code isEqualToString:menuAction.code]) {
                    [menuAction.idCollection addObject:data.id];
            }
            
        }
    }
    else
    {
        NSMutableArray *idArry =[[NSMutableArray alloc] init];
        for (FuctionActionData *data in codeArr) {
            [idArry addObject:data.id];
        }
        [menuAction.idCollection setArray:idArry];
    }
    
    
}


-(void)loadData:(UIMenuDetaiAction *)menuAction 
{
    if ([menuAction.name isEqualToString:NSLocalizedString(@"生活圈", nil)]){
        self.lblName.text =[NSString stringWithFormat:NSLocalizedString(@"生活圈", nil)];
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"顾客端设置", nil)]){
        self.lblName.text =[NSString stringWithFormat:NSLocalizedString(@"顾客端设置", nil)];
    }
    else
    {
        self.lblName.text= menuAction.name;
    }
    self.lblDetail.text = menuAction.content;
    [self.lblName sizeToFit];
    if (menuAction.selectstatus) {
        self.img_check.hidden=NO;
        self.img_uncheck.hidden =YES;
    }
    else
    {
        self.img_uncheck.hidden =NO;
        self.img_check .hidden =YES;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([NSString isNotBlank:menuAction.img]) {
        UIImage *img=[UIImage imageNamed:menuAction.img];
        self.imgMenu.image=img;
    } else {
        self.imgMenu.image=nil;
    }
    if ([menuAction.name isEqualToString:NSLocalizedString(@"电子收款明细", nil)]) {
        if (  [[Platform Instance]lockAct:PAD_WEIXIN_DETAL]&&[[Platform Instance]lockAct:PAD_WEIXIN_SUM]&& [[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"])
        {
            [self.imgLock setHidden:NO];
            [self loadRadius];
            
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
    else if ([menuAction.name isEqual:NSLocalizedString(@"报表", nil)]){
        if ([[Platform Instance]lockAct:MEMBER_REPORT]&&[[Platform Instance]lockAct:CARD_CONSUME_DETAIL_REPORT]&&[[Platform Instance]lockAct:PAD_CARD_ACTIVATE_REPORT]&&[[Platform Instance]lockAct:   PAD_DETAIL_CARD_REPORT]&&[[Platform Instance]lockAct: CARD_DISCOUNT_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_CHARGE_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_DEGREE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_COUNT_REPORT]) {
            if ([[Platform Instance] lockAct:SURFACE_REPORT]) {
                [self.imgLock setHidden:NO];
                [self loadRadius];
            }else{
                [self.imgLock setHidden:YES];
            }
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
    else if ([menuAction.name isEqualToString:NSLocalizedString(@"会员", nil)]){
        if ([[Platform Instance] lockAct:PAD_DEGREE_EXCHANGE]&&[[Platform Instance] lockAct:PAD_CHARGE_DISCOUNT]&&[[Platform Instance] lockAct:PAD_KIND_CARD]&&[[Platform Instance] lockAct:PAD_MAKE_CARD]&&[[Platform Instance] lockAct:PAD_CONSUME_DETAIL]) {
            [self.imgLock setHidden:NO];
            [self loadRadius];
            
        }
        else
        {
            [self.imgLock setHidden:YES];
        }
    }
    else
    {
        BOOL isShow =[[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menuAction.code];
        self.backgroundColor=[UIColor clearColor];
        [self.imgLock setHidden:!isShow];
        if (isShow) {
            [self loadRadius];
        }
    }
}

@end
