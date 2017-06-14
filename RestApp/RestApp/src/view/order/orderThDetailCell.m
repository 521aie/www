//
//  orderThDetailCell.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderThDetailCell.h"

@implementation orderThDetailCell

- (void)awakeFromNib {

}

-(void)initView
{
    [self.frSwitch initLabel:NSLocalizedString(@"点菜少于最小份数时建议", nil) withHit:@"" delegate:self];
    [self.frSwitch initData:@"0"];
    [self.seSwitch initLabel:NSLocalizedString(@"点菜多余最大建议份数", nil) withHit:@"" delegate:self];
    [self.seSwitch initData:@"0"];
    [self.smSegView initLabel:NSLocalizedString(@"建议份数", nil) withHit:@"" delegate:self];
    
    
}

@end
