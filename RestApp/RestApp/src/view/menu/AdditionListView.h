//
//  AdditionListView.h
//  RestApp
//
//  Created by zxh on 14-7-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "PairPickerClient.h"
#import "YYModel.h"
#import "AdditionKindMenuVo.h"
#import "AdditionMenuVo.h"

//@class MenuModule;
//@interface AdditionListView : SampleListView<ISampleListEvent,PairPickerClient>
//=======
#import "NavigationToJump.h"

@class MenuModule,MenuService,KindMenu,SampleMenuVO;
@interface AdditionListView : SampleListView<ISampleListEvent,PairPickerClient,NavigationToJump>

{
    MenuModule *parent;
}

@property (nonatomic, strong) NSMutableArray *headList;    //加料分类列表.
@property (nonatomic, strong) NSMutableDictionary *detailMap;

@property (nonatomic, strong) NSMutableArray *idList;    //加料.
@property (nonatomic, strong) AdditionKindMenuVo* currKindmenu;

@property (nonatomic, strong) NSMutableDictionary *sortDic;
@property (nonatomic, strong) NSMutableArray* sortKeys;
@property (nonatomic,copy) void (^menuAdditionslistCallBack)(BOOL orRefresh);
@property (nonatomic, assign) NSInteger backIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;

- (void)loadDatas;

- (void)loadData:(NSMutableArray*)headList dic:(NSMutableDictionary*)detailMap;
- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuAdditionslistCallBack;
@end
