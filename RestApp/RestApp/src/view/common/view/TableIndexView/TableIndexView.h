//
//  TableIndexView.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "MBProgressHUD.h"
#import "SingleCheckHandle.h"
#import "INameValueItem.h"


@class FooterListView,NavigateTitle2,DHListPanel;
@interface TableIndexView : UIViewController;

@property (nonatomic, weak) IBOutlet FooterListView *footView;
@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet DHListPanel *dhListPanel;

@property (nonatomic,retain) NSMutableArray *headList;
@property (nonatomic,retain) NSMutableArray *detailList;
@property (nonatomic,retain) NSMutableDictionary *detailMap;

@property (nonatomic,strong) NSString* titleStr;

@property (nonatomic,retain) id<INameValueItem> currentHead;

@property (nonatomic) int action;

@end
