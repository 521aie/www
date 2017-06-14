//
//  MenuAreaPrinterListView.h
//  RestApp
//
//  Created by xueyu on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "TDFRootViewController.h"
@class TransService;
@interface MenuAreaPrinterListView : TDFRootViewController<INavigateEvent,UITableViewDataSource,UITableViewDelegate>
{
    TransService *service;
}
@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
-(void)loadDatas;
@end
