//
//  TableEditView.h
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"
#import "ISampleListEvent.h"
#import "TDFRootViewController.h"

@class MBProgressHUD,NavigateTitle2;
@interface TableEditView : TDFRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,INavigateEvent>
{
    
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格

@property (nonatomic, strong) NSMutableArray *datas;    //原始数据集
@property (nonatomic, strong) NSMutableArray *backDatas; //备份数据集
@property (nonatomic, strong) id<ISampleListEvent> delegate;

@property (nonatomic, strong) NSString* event;
@property (nonatomic) int action;
@property (nonatomic ,strong) NSDictionary  *dic ;

@property(nonatomic, strong) NSMutableArray* arrDatas;


- (void)initDelegate:(id<ISampleListEvent>)delegateTemp event:(NSString*)eventTemp action:(int)actionFlag title:(NSString*)titleName;

- (void)reload:(NSMutableArray*) dataTemps error:(NSString*)error;

-(NSMutableArray*) getIds;

@end
