//
//  SelectMenuListView.m
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "DiscountMenuDetailEditView.h"
#import "SelectMultiMenuListPanel.h"
#import "DiscountPlanEditView.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "RatioPickerBox.h"
#import "MenuTimePrice.h"
#import "MBProgressHUD.h"
#import "TreeNodeUtils.h"
#import "IMenuDataItem.h"
#import "SampleMenuVO.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "SampleMenuVO.h"
#import "MenuService.h"
#import "TreeBuilder.h"
#import "RemoteEvent.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFMenuService.h"
#import "YYModel.h"
@implementation DiscountMenuDetailEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].menuService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initNotification];
    self.detailMap=[[NSMutableDictionary alloc] init];
    [self.dhListPanel1 initDelegate:self headChange:MenuModule_Kind_Multi_Select detailChange:MenuModule_Data_Multi_Select];
    [self.dhListPanel1 setBackgroundColor:[UIColor clearColor]];
    [self loadMenusListwithDiscount:self.radio withDiscountDetailList:self.datas];
    
    self.settingBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.settingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.settingBtn setTitle:@"  设置\n折扣率" forState:UIControlStateNormal];
}

#pragma navigateBar
-(void) initNavigate
{
    self.title = NSLocalizedString(@"选择商品", nil);
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavigationButtonAction:(id)sender
{
    NSMutableArray* items=[NSMutableArray array];
    for (SampleMenuVO* item in self.detailList) {
        item.kindMenuId = item._id;
        if ([self.str doubleValue]!=[item obtainItemRatioValue].doubleValue) {
            if ([items containsObject:item]) {
                [items removeObject:item];
            }
            [items addObject:item];
        }else{
            [items removeObject:item];
        }
    }
    if (self.callBack) {
        self.callBack(items);
    }
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma 数据加载.e
-(void) loadMenusListwithDiscount:(NSString *)discount withDiscountDetailList:(NSMutableArray *)discountDetailList
{
    [self configNavigationBar:NO];
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil) ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"type"] = @"0";
    @weakify(self);
    [[TDFMenuService new] listSampleWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        NSMutableDictionary *dic = data[@"data"];
        self.kindMenuList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[KindMenu class] json:dic[@"kindMenuList"]]];
        self.detailList = [NSMutableArray arrayWithArray:[NSMutableArray yy_modelArrayWithClass:[SampleMenuVO class] json:dic[@"simpleMenuDtoList"]]];
        
        self.allNodeList = [TreeBuilder buildTree:self.kindMenuList];
        self.headList  = [TreeNodeUtils convertEndNode:self.allNodeList];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (SampleMenuVO* menu in self.detailList) {
            [dict setObject:menu.kindMenuId forKey:menu.kindMenuId];
        }
        for (NSString *kindId in dict.allKeys) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (SampleMenuVO* menu in self.detailList) {
                if ([kindId isEqualToString:menu.kindMenuId]) {
                    [arr addObject:menu];
                }
            }
            for (SampleMenuVO* item in arr) {
                item.ratio=self.str.doubleValue;
                for (SampleMenuVO* detail in self.discountDetailList) {
                    if ([detail.kindMenuId isEqualToString:item._id]) {
                        item.ratio=detail.ratio;
                    }
                    if ([detail.menuKindName isEqualToString:item.name]) {
                        item.ratio=detail.ratio;
                    }
                }
            }
            [self.detailMap setObject:arr forKey:kindId];
            [self.dhListPanel1 initDataWithDetailMap:self.detailMap withRatio:self.str];
        }
        [self pushNotification];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];

     self.str = discount;
     self.discountDetailList = discountDetailList;
}

#pragma 通知相关.
-(void) initNotification
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kindChange:) name:MenuModule_Kind_Multi_Select object:nil];
}

-(void) pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.headList forKey:@"head_list"];
    [dic setObject:self.detailMap forKey:@"detail_map"];
    [dic setObject:self.allNodeList forKey:@"allNode_list"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Data_Multi_Select object:dic];
}

-(void) kindChange:(NSNotification*) notification
{
    NSMutableDictionary* dic= notification.object;
    self.headList=[dic objectForKey:@"head_list"];
    self.allNodeList=[dic objectForKey:@"allNode_list"];
}

- (IBAction)settingBtnClick:(id)sender
{
    if ([ObjectUtil isNotEmpty:self.detailList]) {
        [RatioPickerBox initData:self.dhListPanel1.ratio.intValue];
        [RatioPickerBox show:NSLocalizedString(@"设置折扣率(%)", nil) client:self event:0];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)row
{
    for (SampleMenuVO* menu in self.detailList) {
        for (SampleMenuVO* item in [self.detailMap objectForKey:menu.kindMenuId]){
            if (item.orClick==YES) {
                [self configNavigationBar:YES];
                item.ratio=((NSString*)selectObj).doubleValue;
            }
            item.orClick = NO;
            [self.dhListPanel1.mainGrid reloadData];
        }
    }
    return YES;
}

-(void) selectObj:(id<IImageDataItem>)obj
{
}

@end
