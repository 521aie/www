//
//  SingleCheckView.h
//  RestApp
//
//  Created by zxh on 14-4-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle.h"
#import "SingleCheckHandle.h"

@interface SingleCheckView : UIViewController<UITableViewDataSource,UITableViewDelegate,INavigateEvent>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) IBOutlet NavigateTitle *titleBox;         //标题容器
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格

@property (nonatomic, strong) id<SingleCheckHandle> delegate;
@property (nonatomic, strong) NSString* val;  //选中的值.
@property (nonatomic, assign) NSInteger event;

- (void)initDelegate:(NSInteger)event delegate:(id<SingleCheckHandle>)delegate title:(NSString *)titleName;

- (void)reload:(NSMutableArray *)datas selValue:(NSString *)val;

@end
