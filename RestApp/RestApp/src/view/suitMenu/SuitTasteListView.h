//
//  TasteListView.h
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "ISampleListEvent.h"
#import "PairPickerClient.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "KindAndTasteVo.h"
@class MenuModule,KindTaste,Taste;
@interface SuitTasteListView : SampleListView<ISampleListEvent,PairPickerClient,UIActionSheetDelegate>{
    MenuModule *parent;
}

@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;

@property (nonatomic,retain) NSMutableArray *idList;    //商品.
@property (nonatomic,strong) KindAndTasteVo* currKindTaste;
@property (nonatomic,strong) Taste* currTaste;

@property (nonatomic,retain) id<INameValueItem> currObj;

@property (nonatomic,retain) NSMutableDictionary *sortDic;
@property (nonatomic,retain) NSMutableArray* sortKeys;
@property (nonatomic,copy) void (^menuTasteslistCallBack)(BOOL orRefresh);
@property (nonatomic, assign) NSInteger backIndex;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;
-(void)loadDatas;
-(void)loadData:(NSMutableArray*)headList;
- (void) initIndexWithIndex:(NSInteger)index AndCallBack:(void (^)(BOOL ))menuTasteslistCallBack;
@end
