//
//  TreeNodeSortViewViewController.h
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TableEditView.h"

@class MenuService,MenuModule,TreeNode;
@interface TreeNodeSortView : TableEditView{
    MenuModule* parent;
    MenuService *service;
}

@property (nonatomic,retain) NSMutableArray *kindList;
@property (nonatomic,retain) NSMutableArray *treeNodes;
@property (nonatomic,retain) NSMutableArray* parentNodes;    //原始数据集

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp;
- (void)reload:(NSMutableArray*) _dataTemps error:(NSString*)error;

@end
