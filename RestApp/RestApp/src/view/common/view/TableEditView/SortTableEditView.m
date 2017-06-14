//
//  SortTableEditView.m
//  RestApp
//
//  Created by zishu on 16/8/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortTableEditView.h"
#import "MenuListView.h"
#import "SampleMenuVO.h"
@implementation SortTableEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createData];
}
- (void)createData
{
    if ([ObjectUtil  isNotEmpty: self.dic]) {
        id  data  = self.dic [@"data"];
        NSString *actionStr  =  self.dic [@"action"];
        id delegate  = self.dic [@"delegate"];
        NSString *event  = self.dic [@"event"];
        NSString *title  = self.dic [@"title"];
        id error = self.dic [@"error"] ;
        [self  initDelegate:delegate event:event action:actionStr.intValue title:title];
        [self reload:data error:error];
    }
}


-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if(self.action==ACTION_CONSTANTS_SORT){
            [self.delegate closeListEvent:self.event];
        }
    } else {
        NSMutableDictionary* specMap=[self getSpecMap];
        if ([specMap count]==0) {
            [self.delegate closeListEvent:self.event];
        }
        [self.delegate sortEventForMenuMoudle:self.event menuMoudleMap:specMap];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    if(self.action==ACTION_CONSTANTS_SORT){
        [self.delegate closeListEvent:self.event];
    }
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    NSMutableDictionary* specMap=[self getSpecMap];
    if ([specMap count]==0) {
        [self.delegate closeListEvent:self.event];
    }
    [self.delegate sortEventForMenuMoudle:self.event menuMoudleMap:specMap];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableDictionary*) getSpecMap
{
    if (self.datas && [self.datas count]>0) {    //排序的处理.
        for (int i = 0; i<self.datas.count; i++) {
            id<SortItemValue> item = self.datas[i];
            item.sortCode = i;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<self.datas.count; i++) {
        id<SortItemValue> spec = self.datas[i];
        param[[spec obtainItemId]] = [NSNumber numberWithInt:spec.sortCode];
    }
    return param;
  
}

- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error
{
    self.datas=_dataTemps;
    [self showSortEvent];
}

- (void) showSortEvent
{
    self.action=ACTION_CONSTANTS_SORT;
//    [self.titleBox.btnUser setTitle:@"" forState:UIControlStateNormal];
//    [self.titleBox btnVisibal:YES direct:DIRECT_RIGHT];
//    [self.titleBox loadImg:Head_ICON_OK direct:DIRECT_RIGHT];
//    [self.titleBox.btnBack setTitle:@"" forState:UIControlStateNormal];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self beginEditGrid];
}

-(void)beginEditGrid
{
    [self.mainGrid setEditing:YES animated:YES];
    self.backDatas=[self.datas mutableCopy];
    [self.mainGrid reloadData];
}


@end
