//
//  TDFBoxSelectViewController.h
//  RestApp
//
//  Created by 栀子花 on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "TDFPackingBoxKindVo.h"
#import "TDFPackingBoxVo.h"
typedef void(^CallBack) (NSString *menuName,double price,NSString *menuId);

@interface TDFBoxSelectViewController : TDFRootViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic,strong) UIImageView *imge;
@property (nonatomic,strong)UILabel * midLabel;
@property (nonatomic,strong)UILabel *bottLabel;
@property (nonatomic,copy)CallBack callBack;
@property (nonatomic ,strong) NSString *packingBoxId;
@property (nonatomic ,strong) NSString *packingBoxName;
@property (nonatomic, strong)TDFPackingBoxKindVo *packingBoxkindVo;
@property (nonatomic, strong)TDFPackingBoxVo *packingBoxVo;
@end
