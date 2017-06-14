//
//  WaiterDetailView.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewFactory.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "WaiterEvaluateHeader.h"
#import "TableViewHeaderController.h"
#import "WaiterEvaluateHeader.h"
#import "WaiterEvaluateData.h"

@interface WaiterDetailView : TableViewHeaderController<INavigateEvent,UITableViewDataSource,UITableViewDelegate>
{

    BOOL isRefreshed;
}
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) IBOutlet UIView *noDataTip;
@property (nonatomic, strong) IBOutlet UILabel *contentTip;
@property (nonatomic, strong) WaiterEvaluateHeader *evaluateHeader;
@property (nonatomic, strong) WaiterEvaluateData *evaluateData;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSDictionary *param;


-(void)initWithData:(WaiterEvaluateData *)waiterData;

@end
