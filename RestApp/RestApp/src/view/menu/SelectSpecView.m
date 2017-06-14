//
//  SelectSpecView.m
//  RestApp
//
//  Created by zxh on 14-8-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSpecView.h"
#import "GridColHead.h"
#import "UIView+Sizes.h"
#import "HelpDialog.h"

@implementation SelectSpecView

#pragma table head
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:GridColHeadIndentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    }
    [headItem initColHead:NSLocalizedString(@"规格名称", nil) col2:NSLocalizedString(@"价格是基准商品价格的几倍", nil)];
    [headItem initColLeft:15 col2:134];
    [headItem.lblVal setWidth:173];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(void) showHelpEvent
{
    [HelpDialog show:@"basemenuspec"];
}

- (void)navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}
@end
