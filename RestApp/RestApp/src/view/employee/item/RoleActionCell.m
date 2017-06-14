//
//  RoleActionCell.m
//  RestApp
//
//  Created by zxh on 14-5-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleActionCell.h"
#import "TreeNode.h"
#import "ActionRender.h"
#import "UIView+Sizes.h"
#import "UILabel+VerticalAlign.h"

@implementation RoleActionCell

- (void)fillData:(TreeNode*)node
{
    self.lblName.text= node.itemName;
    
    NSString* result=[ActionRender obtainActionDetailName:node];
    NSArray* resultArr=[result componentsSeparatedByString:@"|"];
    NSString* countStr=(NSString*)[resultArr objectAtIndex:0];
    
    self.lblVal.text=[NSString stringWithFormat:NSLocalizedString(@"%@项", nil),countStr];
    self.lblDetail.text=@"";
    self.count=countStr.intValue;
    [self.lblDetail setHeight:0];
    [self.txtView setHeight:0];
    if (![countStr isEqualToString:@"0"]) {
        self.lblDetail.top=31;
        [self.lblDetail setWidth:300];
        self.lblDetail.text=(NSString*)[resultArr objectAtIndex:1];
        
        [self.lblDetail sizeToFit];
        [self.txtView setHeight:self.lblDetail.height];
        self.lblDetail.contentOffset=CGPointZero;
        //    [self.lblDetail setHeight:self.lblDetail.contentSize.height+20];
        [self.contentView setHeight:32+self.lblDetail.height+10];
        [self setHeight:32+self.lblDetail.height+10];
        [self setNeedsLayout];
        
    }

}

- (int)getHeight
{
    if (self.count==0) {
        return 44;
    }

//    [self.lblDetail sizeToFit];
////    [self.lblDetail setHeight:self.lblDetail.contentSize.height+20];
//    [self setNeedsLayout];
//    self setHeight:32+self.lblDetail.height+10];
   return 32+self.lblDetail.height+10;
}


@end
