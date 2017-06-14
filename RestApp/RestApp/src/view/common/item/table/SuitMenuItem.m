//
//  SuitMenuItem.m
//  RestApp
//
//  Created by zxh on 14-8-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Menu.h"
#import "UIImageView+TDFRequest.h"
#import "UIView+Sizes.h"
#import "SuitMenuItem.h"
#import "SuitMenuSample.h"
#import "NSString+Estimate.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"

@implementation SuitMenuItem

+ (id)getInstance
{
    SuitMenuItem *item = [[[NSBundle mainBundle]loadNibNamed:@"SuitMenuItem" owner:self options:nil]lastObject];
    return item;
}

-(void) loadItem:(SuitMenuSample*)data
{
    [self loadItem:data delegate:nil];
}

-(void) loadItem:(SuitMenuSample*)data delegate:(id<DHListSelectHandle>) handle
{
    self.delegate=handle;
    self.item=data;
    
    self.lblName.text= [data obtainItemName];
    self.lblDetail.text=[data obtainItemValue];
    self.lblAccount.text=[NSString stringWithFormat:@"/%@",[self.item showUnit]];
    [self.lblDetail sizeToFit];
    [self.lblAccount setLeft:(self.lblDetail.left+self.lblDetail.width+2)];
    [self.lblAccount sizeToFit];
    [self.lblAccount setNeedsDisplay];
    self.kabawView.layer.cornerRadius = 5;
    
    [self.lblSuit.layer setMasksToBounds:YES];
    [self.lblSuit.layer setCornerRadius:3];
//    NSString *str;
//    if (data.childCount == 0) {
//        str = NSLocalizedString(@"尚未添加商品", nil);
//    }else if (data.childCount == -1)
//    {
//        str = NSLocalizedString(@"可点商品不限制", nil);
//    }else
//    {
//        str = [NSString stringWithFormat:NSLocalizedString(@"一共%d个商品", nil),data.childCount];
//    }
//    self.lblDishNum.text=str;
    if ([NSString isNotBlank:[data obtainImgpath]]) {
        self.img.contentMode = UIViewContentModeScaleAspectFill;
//        NSString *imageUrl = [ImageUtils getSmallImageUrl:self.item.server path:self.item.path];
        [self.img.layer setMasksToBounds:YES];
        [self.img.layer setCornerRadius:ITEM_RADIUS];
        [self showImg:YES];
        [self.img tdf_imageRequstWithPath:self.item.path placeholderImage:[UIImage imageNamed:@"img_default.png"] urlModel:ImageUrlCapture];
    } else {
        [self.img setImage:[UIImage imageNamed:@"img_default.png"]];
        [self showImg:NO];
    }
}

-(void) showImg:(BOOL)visibal
{
    [self.img setHidden:!visibal];
    [self.kabawView setHidden:visibal];
}

-(IBAction)btnKabawClick:(id)sender
{
    if (self.delegate==nil) {
        return;
    }
    [self.delegate selectKind:self.item];
}

@end
