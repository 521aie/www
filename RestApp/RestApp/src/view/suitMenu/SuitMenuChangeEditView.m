//
//  SuitMenuChangeEditView.m
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuChangeEditView.h"
#import "MenuModule.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "MBProgressHUD.h"
#import "SuitMenuChange.h"
#import "SuitMenuModuleEvent.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"
#import "TDFMenuService.h"
#import "RemoteEvent.h"
#import "JsonHelper.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "ItemEndNote.h"
#import "TDFSuitMenuService.h"
#import "TDFOptionPickerController.h"
#import "NameItemVO.h"
#import "SampleMenuVO.h"
#import "MenuSpecDetail.h"
#import "SuitMenuDetail.h"
#import "SuitMenuEditView.h"
#import "YYModel.h"
#import <libextobjc/EXTScope.h>

@implementation SuitMenuChangeEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)_parent;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self initNotifaction];
    [self initNavigate];
    
    [self initMainView];
    [self createData];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  data  = self.sourceDic [@"data"];
        id  menu  = self.sourceDic [@"menuData"];
//        id  callback  =  self.sourceDic [@"callBack"];
//        callback  = self.ca;
           [self  loadData:data menu:menu];
       }
}
#pragma navigateTitle.
- (void)initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event{
    if (event==1) {
        [parent showView:SUITMENU_SELECTMENU_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    }else{
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self.view endEditing:YES];
    [self save];
}

- (void)closeListEvent:(NSString*)event
{
//    [parent showView:SUITMENU_EDIT_VIEW];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[SuitMenuEditView class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)initMainView
{
    self.forceNum = [[EditItemList alloc] init];
    [self.forceNum awakeFromNib];
    self.forceNum.tag = 7;
    self.forceNum.frame = self.forceNum.view.frame;
    [self.forceNum initLabel:NSLocalizedString(@"此商品在套餐内限点数量", nil) withHit:nil delegate:self];
    [self.container insertSubview:self.forceNum belowSubview:self.txtNote];

    
    [self.lblKind initLabel:NSLocalizedString(@"分组分类", nil) withHit:nil];
    [self.lblName initLabel:NSLocalizedString(@"商品名称", nil) withHit:nil];
    [self.lsSpec initLabel:NSLocalizedString(@"规格", nil) withHit:nil delegate:self];
//    [self.lsPrice initLabel:NSLocalizedString(@"商品加价", nil) withHit:nil delegate:self];
//    [self.lsNum initLabel:NSLocalizedString(@"商品数量", nil) withHit:nil delegate:self];

    [self.lsNum initLabel:NSLocalizedString(@"商品数量", nil) withHit:nil isrequest:YES delegate:self];
        [self.lsPrice initLabel:NSLocalizedString(@"商品加价", nil) withHit:nil isrequest:YES delegate:self];
    [self.txtNote initHit:nil];
    
    self.lsSpec.tag=SUITMENU_KIND;
    self.lsNum.tag=SUITMENU_ACCOUNT;
    self.lsPrice.tag=SUITMENU_PRICE;
    
    [self.lsNum setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeInteger hasSymbol:NO];
    [self.lsPrice setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SuitMenuChangeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SuitMenuChangeEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*)notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma 界面初始加载.
- (void)loadData:(SuitMenuDetail*)detail menu:(SampleMenuVO*)menu
{
    self.suitDetail=detail;
    self.action=ACTION_CONSTANTS_ADD;
    self.menu=menu;
    [self clearDo];
    [self fillModel];
    [self loadMenuSpec:menu._id];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.lsPrice initData:@"0" withVal:@"0"];
}

- (void)fillModel
{
    [self.lblKind initData:self.suitDetail.name withVal:self.suitDetail._id];
    [self.lblName initData:self.menu.name withVal:self.menu._id];
    
    if (self.suitDetail.isRequired==1) {
        [self.lsPrice visibal:NO];
        [self.lsNum visibal:YES];
        [self.forceNum visibal:NO];
        [self.lsNum initData:@"1" withVal:@"1"];
        self.lsNum.imgMore.alpha = 0;
//        self.lsNum.lblVal.bounds = CGRectMake(0, 0, 225, self.lsNum.lblVal.bounds.size.height);

      //  self.titleBox.lblTitle.text=NSLocalizedString(@"添加必选商品", nil);
        self.title  =NSLocalizedString(@"添加必选商品", nil);
        [self.txtNote initHit:NSLocalizedString(@"提示：\n\n商品有多种规格时，此处需指定一种。如果想提供多种规格，多次添加商品并分别指定不同的规格即可；\n\n商品有多种做法时，此处无需指定，顾客可自由选择一种。做法本身如果有加价，会额外累积到套餐总价上.", nil)];
       // self.titleBox.lblTitle.text=NSLocalizedString(@"添加必选商品", nil);
        [self.txtNote initHit:NSLocalizedString(@"提示：\n\n商品有多种规格时，此处需指定一种。如果想提供多种规格，多次添加商品并分别指定不同的规格即可；\n\n商品有多种做法时，此处无需指定，顾客可自由选择一种。做法本身如果有加价，会额外累积到套餐总价上.", nil)];
    }else{
        [self.lsPrice visibal:YES];
        [self.lsNum visibal:NO];
        [self.forceNum visibal:YES];
        [self.forceNum initData:NSLocalizedString(@"不限制", nil) withVal:@"0"];
        self.lsPrice.imgMore.alpha = 0;
//        self.lsPrice.lblVal.bounds = CGRectMake(0, 0, 225, self.lsPrice.lblVal.bounds.size.height);

        self.titleBox.lblTitle.text=NSLocalizedString(@"添加自选商品", nil);
        self.title  = NSLocalizedString(@"添加自选商品", nil);
        //self.titleBox.lblTitle.text=NSLocalizedString(@"添加自选商品", nil);
        [self.txtNote initHit:NSLocalizedString(@"提示：\n\n商品有多种规格时，此处需指定一种。如果想提供多种规格，多次添加商品并分别指定不同的规格即可；\n\n商品有多种做法时，此处无需指定，顾客可自由选择一种。做法本身如果有加价，会额外累积到套餐总价上；\n\n商品加价是指，顾客如果点了这个商品，套餐的单价需要加上此处设置的加价。例如套餐价格为55元，添加商品“菲力牛排”并设置加价为5元，那么套餐的实际价格为60元。", nil)];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if (self.specs!=nil && self.specs.count>0 && [NSString isBlank:[self.lsSpec getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"规格不能为空!", nil)];
        return NO;
    }
    
    if (self.suitDetail.isRequired==0 && [NSString isBlank:[self.lsPrice getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品加价(元)不能为空!", nil)];
        return NO;
    }
    
    if (self.suitDetail.isRequired==1 && [NSString isBlank:[self.lsNum getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"商品数量不能为空!", nil)];
        return NO;
    }
    if (self.suitDetail.isRequired==1 && [[self.lsNum getStrVal] isEqualToString:@"0"]) {
        [AlertBox show:NSLocalizedString(@"允许点的数量要大于等于1!", nil)];
        return NO;

    }
    return YES;
}

#pragma 对象处理.
- (SuitMenuChange*) transMode
{
    SuitMenuChange* obj=[[SuitMenuChange alloc] init];
    obj.suitMenuDetailId=self.suitDetail._id;
    obj.menuId=self.menu._id;
    obj.suitMenuChangeExtra.limit_num = [[self.forceNum getStrVal] intValue];
    if (self.suitDetail.isRequired==1) {
        obj.num=[self.lsNum getStrVal].doubleValue;
        obj.price=0;
    }else{
        obj.price=[self.lsPrice getStrVal].doubleValue;
        obj.num=1;
    }
    if(self.specs!=nil && self.specs.count>0){
        obj.specDetailId=[self.lsSpec getStrVal];
    }
    return obj;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    
    SuitMenuChange* objTemp=[self transMode];
    
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"change_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFSuitMenuService new] saveSuitMenuChangeWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            NSString* actionStr=[NSString stringWithFormat:@"%d",self.action];
            //通知Detail变化.
            NSDictionary *changeDic = [data objectForKey:@"data"];
            SuitMenuChange* suitMenuChange=[SuitMenuChange yy_modelWithDictionary:changeDic];
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:suitMenuChange forKey:@"suitMenuChange"];
            [dic setObject:actionStr forKey:@"action"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Detail_Menu_Change object:dic];
            
            //通知套菜可点数量变化
//            NSString* childCount = [map objectForKey:@"childCount"];
//            NSMutableDictionary* suitDic=[NSMutableDictionary dictionary];
//            [suitDic setObject:self.suitDetail.suitMenuId forKey:@"suitMenuId"];
//            [suitDic setObject:childCount forKey:@"childCount"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:SuitMenuModule_DataNum_Change object:suitDic];
            
//            [parent showView:SUITMENU_SELECTMENU_VIEW];
//            [XHAnimalUtil animalEdit:parent action:self.action];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

#pragma test event
#pragma edititemlist click event.
//List控件变换.
- (void)onItemListClick:(EditItemList*)obj
{
    if (obj.tag==SUITMENUCHANGE_SPEC) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@规格", nil),self.menu.name]
                                                                                      options:self.specs
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.specs[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }
    if (obj.tag == 7) {
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"此商品在套餐内限点数量", nil)
                                                                                      options:[self forceNumdataArray]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[self forceNumdataArray][index] event:obj.tag];
        };
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];

    }
    
}

- (NSMutableArray *)forceNumdataArray
{
    NSMutableArray *array = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"不限制", nil) andId:@"0"];
    [array addObject:item];
    int num = self.suitDetail.num;
    if (self.suitDetail.num == -1) {
        num = 20;
    }
    for (int i = 1; i < num + 1; i ++) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d",i] andId:[NSString stringWithFormat:@"%d",i]];
        [array addObject:item];
    }

    return array;
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==SUITMENUCHANGE_SPEC) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsSpec changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    if (event == 7) {
        NameItemVO *itemVO = (NameItemVO *)selectObj;
        [self.forceNum changeData:itemVO.itemName withVal:itemVO.itemId];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==SUITMENUCHANGE_PRICE) {
        [self.lsPrice changeData:val withVal:val];
    } else if (eventType==SUITMENUCHANGE_NUM) {
        [self.lsNum changeData:val withVal:val];
    }
}

#pragma 加载商品规格.
- (void)loadMenuSpec:(NSString*)menuId
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"menu_id"] = menuId;
     @weakify(self);
    [[TDFSuitMenuService new] listSuitSpecaDetailWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        @strongify(self);
        [hud hide:YES];
        self.specs = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[MenuSpecDetail class] json:data[@"data"]]];
        if (self.specs!=nil && self.specs.count>0) {
            [self.lsSpec visibal:YES];
            MenuSpecDetail* spec=(MenuSpecDetail*)[self.specs firstObject];
            [self.lsSpec initData:spec.name withVal:spec.id];
        }else{
            [self.lsSpec visibal:NO];
        }
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}


@end
