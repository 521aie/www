//
//  TDFMenuListPanel.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IImageDataItem.h"
#import "DHListSelectHandle.h"
#import "TreeNode.h"
@interface TDFMenuListPanel : UIView

@property (nonatomic, weak)id<DHListSelectHandle>delegate;
@property (nonatomic,strong) UIButton *searchBigButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *headList;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) NSMutableArray *backHeadList;
@property (nonatomic, strong) NSMutableArray *headerItems;
@property (nonatomic, strong) NSMutableDictionary *backDetailMap;
- (void)scrocll:(TreeNode*)node;
@end
