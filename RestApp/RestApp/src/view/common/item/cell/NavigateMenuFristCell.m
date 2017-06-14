//
//  NavigateMenuFristCell.m
//  RestApp
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import "Platform.h"
#import "UIView+Sizes.h"
#import "NavigateMenuCell.h"
#import "NSString+Estimate.h"
#import "NavigateMenuFristCell.h"

@implementation NavigateMenuFristCell

-(void) loadData:(QuickStep*)step
{

    self.LblActName.text=step.actName;
    [self.LblActName sizeToFit];
    [self.LblActName setWidth:self.LblActName.width];
    [self.imgLock setHidden:!([[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:step.actCode])];

}
- (void) loadImageData:(NSString *)imgstr
{
    if ([NSString isNotBlank:imgstr]) {
        self.imgVer.image =[UIImage imageNamed:imgstr];
    }
}
- (void)loadtablbl:(NSString *)lbl
{
    self.sectionlbl.text =[NSString stringWithFormat:@"%@",lbl];
}
@end
