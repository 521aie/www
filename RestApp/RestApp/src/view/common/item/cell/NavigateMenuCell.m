//
//  NavigateMenuCell.m
//  RestApp
//
//  Created by zxh on 14-5-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "Platform.h"
#import "UIView+Sizes.h"
#import "NavigateMenuCell.h"
#import "NSString+Estimate.h"

@implementation NavigateMenuCell

-(void) loadData:(QuickStep*)step
{
    self.quickStep=step;
    self.imgCheck.hidden=(step.status==0);
    self.imgNoCheck.hidden=(step.status==1);
    self.lblStepName.text=step.stepName;
    self.lblActName.text=step.actName;
    self.lblActDetail.text=step.actDetail;
    self.btnRequire.hidden=(step.isRequire==0);
    [self.lblActName sizeToFit];
    
    [self.lblActName setWidth:self.lblActName.width];
    self.lblNum.text=[NSString stringWithFormat:@"%ld",(long)step.stepNum];
    [self.btnRequire setLeft:(self.lblActName.left+self.lblActName.width)];
    [self.btnRequire setNeedsDisplay];
    [self.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:step.actCode])];
    self.line.hidden=YES;
}
- (void) loadImageData:(NSString *)imgstr
{
    if ([NSString isNotBlank:imgstr]) {
        self.imgVer.image =[UIImage imageNamed:imgstr];
    }
}

@end
