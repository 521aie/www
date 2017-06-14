//
//  ShopEvaluateView.h
//  RestApp
//
//  Created by Shaojianqing on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "INavigateEvent.h"
#import "NavigateTitle2.h"
#import "ShopEvaluateHeader.h"
#import "TableViewHeaderController.h"
#import "ShopEvaluateViewData.h"

@interface ShopEvaluateView : TableViewHeaderController<INavigateEvent>
{
    
    BOOL isRefreshed;
}

@property (nonatomic, strong) IBOutlet UIView *noDataTip;
@property (nonatomic, strong) IBOutlet UILabel *contentTip;
@property (nonatomic, strong) ShopEvaluateHeader *evaluateHeader;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger page;


- (void)initDataView;

@end
