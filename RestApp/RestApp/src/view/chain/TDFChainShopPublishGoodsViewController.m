//
//  TDFChainShopPublishGoodsViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainShopPublishGoodsViewController.h"
#import "TDFMediator+ChainMenuModule.h"
#import "DHTTableViewManager.h"
#import "TDFShowPickerStrategy.h"
#import "TDFStaticLabelItem.h"
#import "TDFCustomStrategy.h"
#import "NameItemVO.h"
#import "TDFPickerItem.h"
#import "ObjectUtil.h"
#import "TDFPlatePublishVo.h"
#import "TDFChainMenuService.h"
#import "ViewFactory.h"
#import "ColorHelper.h"
#import "TDFShowDateStrategy.h"
#import "TDFRootViewController+AlertMessage.h"
#import "UIHelper.h"
#import "TDFPublishInfoVo.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "INameItem.h"
#import "YYModel.h"
#import "NSString+Estimate.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"
#import "NSString+Estimate.h"
#import "PlateBranchVo.h"
#import "PlateKindMenuVo.h"
#import "TDFAddChainPriceFormatViewController.h"
#import "NavigationToJump.h"


@interface TDFChainShopPublishGoodsViewController ()
@property (nonatomic ,strong) DHTTableViewManager *manager;
@property (nonatomic ,strong) UITableView *tabView;
@property (nonatomic ,strong) TDFStaticLabelItem  *titleIteam;
@property (nonatomic ,strong) TDFPickerItem *publishDate;
@property (nonatomic ,strong) TDFPickerItem *publishTime;
@property (nonatomic ,strong) TDFPickerItem *publishGoods;
@property (nonatomic ,strong) TDFPickerItem *publishShops;
@property (nonatomic,strong) TDFStaticLabelItem  *publishStaticGoods;
@property (nonatomic ,strong) TDFPublishInfoVo *vo ;
@property (nonatomic ,strong)  TDFPlatePublishVo *data;
@property (nonatomic ,strong) NSMutableArray *shopList;
@property (nonatomic,strong) NSMutableArray *goodsList;
@property (nonatomic ,strong) NSMutableDictionary * goodDic;
@property (nonatomic ,strong) NSMutableDictionary *shopDic;
@property (nonatomic, strong) NSString *plateEntityId;
@property (nonatomic ,strong) id <NavigationToJump> delegate;
@property (nonatomic ,assign) NSInteger action ;
@property (nonatomic, strong) NSMutableArray * timeIntervalList;


@end

@implementation TDFChainShopPublishGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"发布商品到门店", nil);
    if ([ObjectUtil isNotEmpty:self.dic]) {
        self.data  = self.dic [@"data"];
        self.action  = [TDFPlatePublishVo  getFialureStatus:self.data.publishStatus];//获取当前的状态（正常发布还是重新发布）
    }
     [self  createTabView];
     [self  configureManager];
     [self initMainView];
     [self getPlatesData];
     [self relodData];
}

#pragma 创建tabView
- (void)createTabView
{
   UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.7;
    [self.view insertSubview:bgView atIndex:1];
    self.tabView= [[UITableView  alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.tabView];
    self.tabView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tabView.backgroundColor =[UIColor clearColor];
    self.tabView.tableFooterView =[self CustomFootView];

}
#pragma 导航栏点击事件
- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save ];
}

- (UIView *)CustomFootView
{
    UIView *footerView   =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    footerView.backgroundColor  = [UIColor clearColor];
    UILabel *remarkLbl  =  [[UILabel  alloc] init];
    [footerView addSubview:remarkLbl];
    [remarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).with.offset(10);
        make.top.equalTo (footerView.mas_top).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(footerView.frame.size.width -10*2, 40));
    }];
    remarkLbl.textColor  = [UIColor grayColor];
    remarkLbl.font = [UIFont systemFontOfSize:13];
    remarkLbl.text = NSLocalizedString(@"注：门店会自动接收到总部发布的商品。顾客端会自动更新，收银端需要重启收银机或者手动更新。", nil);
    remarkLbl.numberOfLines = 0;
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView  addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView.mas_centerX);
        make.top.equalTo(remarkLbl.mas_bottom).with.offset(20);
        make.size.mas_equalTo (CGSizeMake(footerView.frame.size.width - 30, 40));
    }];
    bottomButton.backgroundColor = [ColorHelper getRedColor];
    bottomButton.layer.cornerRadius = 5;
    if (self.action  ==PUBLIFAILURESHSTATUS) {
         [bottomButton setTitle:NSLocalizedString(@"重新发布", nil) forState:UIControlStateNormal];
    }
    else
    {
    [bottomButton setTitle:NSLocalizedString(@"发布", nil) forState:UIControlStateNormal];
    }
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomButton addTarget:self action:@selector(confirmPublish:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
//确定按钮的点击事件
- (void)confirmPublish:(UIButton *) button
{
    [self save] ;
}
#pragma notification 处理.


- (DHTTableViewManager *)manager
{
    if (!_manager) {
        _manager =[[DHTTableViewManager alloc] initWithTableView:self.tabView];
        
    }
    return _manager;
}

- (void)configureManager
{
     [self.manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
     [self.manager registerCell:@"TDFStaticLabelCell" withItem:@"TDFStaticLabelItem"];
}

- (void)initMainView
{
//    __weak typeof(self) weakSelf = self;
    DHTTableViewSection *section  =  [DHTTableViewSection section];
    self.titleIteam  =  [[TDFStaticLabelItem  alloc] init];
    self.titleIteam.title = NSLocalizedString(@"发布品牌", nil);
    self.titleIteam.isRequired = NO;
    [section addItem:self.titleIteam];
    
    self.publishDate =  [[TDFPickerItem  alloc] init];
    self.publishDate.title= NSLocalizedString(@"发布日期", nil);
    [section  addItem:self.publishDate];
    
    self.publishTime  =  [[TDFPickerItem  alloc] init];
    self.publishTime.title = NSLocalizedString(@"发布时间", nil);
    [section addItem:self.publishTime];
    
    if (self.action  ==  PUBLIFAILURESHSTATUS ) {
        self.publishStaticGoods  =  [[TDFStaticLabelItem  alloc] init];
        self.publishStaticGoods.title = NSLocalizedString(@"发布商品", nil);
        self.publishStaticGoods.isRequired = NO;
        [section addItem:self.publishStaticGoods];
    }
    else
    {
        self.publishGoods  =  [[TDFPickerItem  alloc] init];
        self.publishGoods.title = NSLocalizedString(@"发布商品", nil);
        self.publishGoods.isIconDown = NO;
        self.publishGoods.isRequired = NO;
        [section  addItem:self.publishGoods];
    }
    self.publishShops =  [[TDFPickerItem alloc] init];
    self.publishShops.title = NSLocalizedString(@"发布门店 (家)", nil);
    self.publishShops.isIconDown = NO;
    self.publishShops.isRequired = NO;
    [section addItem:self.publishShops];
    
    [self.manager addSection:section];
}

//传值数据
- (void)getPlatesData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
           self.data.publishDate = 0;
          self.data.timeInterval =@"";// 服务端可能传过来的异常数据！，需要我们重置！
        self.delegate  =  self.dic [@"delegate"];
        [self fillIteamWithData];
    }
}

//获取商品和门店数据
- (void) fillIteamWithData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD: self.progressHud ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    if ([NSString  isNotBlank:self.data.plateEntityId]) {
        self.plateEntityId  = self.data.plateEntityId ;
        [parma setObject:self.data.plateEntityId forKey:@"plate_entity_id"];
    }
    if (self.action  == PUBLIFAILURESHSTATUS) {
        [parma setObject:self.data.publishPlanId forKey:@"plan_id"];
    }
    @weakify(self);
    [[TDFChainMenuService new] chainGetPublishInfo: parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        [self remoteLoadDataFinish:data];
 
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)remoteLoadDataFinish:(NSMutableDictionary *)dataDic
{
    self.vo   =  [TDFPublishInfoVo yy_modelWithDictionary:dataDic[@"data"]];
    self.titleIteam.textValue =  [NSString stringWithFormat:@"%@",self.data.plateName];
    TDFShowDateStrategy *publishDateStrategy = [[TDFShowDateStrategy alloc] init];
    publishDateStrategy.pickerName = self.publishDate.title;
    self.publishDate.strategy = publishDateStrategy;
    self.publishDate.requestKey = @"specificStartDate";
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow;
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    publishDateStrategy.dateString = tomorrowString;
    self.publishDate.filterBlock = ^ (NSString *dateText, id requestValue) {
        NSDate *startDate = [DateUtils DateWithString:dateText type:TDFFormatTimeTypeYearMonthDayString];
        NSDate *todayDate = [DateUtils DateWithString:[DateUtils formatTimeWithDate:[NSDate date] type:TDFFormatTimeTypeYearMonthDay] type:TDFFormatTimeTypeYearMonthDayString];
        if ([startDate timeIntervalSinceDate:todayDate] <= 0.0) {
            [AlertBox show:NSLocalizedString(@"日期不能早于今天", nil)];
            return NO;
        }
        return YES;
    };
        TDFShowPickerStrategy *publishTimeStrategy = [[TDFShowPickerStrategy alloc] init];
        publishTimeStrategy.pickerName = self.publishDate.title;
        NSMutableArray *timeList   = [TDFPublishInfoVo   getTimeIntervalListWithArry:self.vo.timeIntervalList];
        publishTimeStrategy.pickerItemList = timeList;
        self.publishTime.strategy = publishTimeStrategy;
        self.publishTime.filterBlock = ^ (NSString *dateText, id requestValue) {
            return YES;
        };
    [self fillDataWithView];
}

- (void)fillDataWithView
{
    TDFCustomStrategy *publishShopsStrategy = [[TDFCustomStrategy alloc] init];
    self.shopList = [[NSArray yy_modelArrayWithClass:[PlateBranchVo class] json:self.vo.publishShopVoList] mutableCopy];
    NSInteger  shopNum  = 0;
    if ([ObjectUtil  isNotEmpty: self.shopList]) {
        for (PlateBranchVo *shopVo in self.shopList) {
            for (PlateShopVoList *plateVo in  shopVo.plateShopVoList) {
                if (plateVo.isSelected) {
                     shopNum ++;
                }
            }
        }
    }
    self.publishShops.textValue = [NSString stringWithFormat:@"%ld",shopNum];
    self.publishShops.preValue  =  [NSString stringWithFormat:@"%ld",shopNum];
  
       __weak typeof(self) weakSelf = self;
     publishShopsStrategy.btnClickedBlock = ^(){
           [self transShopDic];
         NSDictionary *changData = @{@"isHideSearch":@"0",@"isChangeTitle":@"1"};
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_chainSelecttMenuWithHeadViewController:PULISHOPDefine delegate:self title:NSLocalizedString(@"发布门店", nil) nodeList:self.shopList detailMap:self.shopDic content:nil changeData:changData];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
    };
    self.publishShops.strategy = publishShopsStrategy;
    TDFCustomStrategy *publishGoodsStrategy = [[TDFCustomStrategy alloc] init];
    self.goodsList = [[NSArray yy_modelArrayWithClass:[PlateKindMenuVo class] json:self.vo.publishMenuVoList] mutableCopy];
    
    if (self.action  == PUBLIFAILURESHSTATUS) {
         NSInteger  menuNum  = 0;
        if ([ObjectUtil  isNotEmpty: self.goodsList]) {
            for (PlateKindMenuVo *menuVo in self.goodsList) {
                for (PlateMenuVoList *plateVo in  menuVo.plateMenuVoList) {
                    if (plateVo.isSelected) {
                        menuNum ++;
                    }
                }
            }
        }
        self.publishStaticGoods.textValue = [NSString stringWithFormat:@"%ld",menuNum];
        self.publishStaticGoods.preValue  =  [NSString stringWithFormat:@"%ld",menuNum];
    }
    else
    {
    self.publishGoods.textValue  = NSLocalizedString(@"全部", nil);
    self.publishGoods.preValue = NSLocalizedString(@"全部", nil);
    
    NSDictionary *changData = @{@"isHideSearch":@"1",@"isChangeTitle":@"0"};
    publishGoodsStrategy.btnClickedBlock = ^(){
        [self transMenuDic];
        NSString *titleStr  = [NSString stringWithFormat:NSLocalizedString(@"%@-商品", nil),self.vo.plateName];
        UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_chainSelecttMenuWithHeadViewController:PULIMENUDefine delegate:self title:titleStr nodeList:self.goodsList detailMap:self.goodDic content:nil changeData:changData];
        [self.navigationController pushViewController:viewController animated:YES];
    };
    self.publishGoods.strategy = publishGoodsStrategy;
   }
    [self relodData];
}

- (NSMutableDictionary *)shopDic
{
    if (!_shopDic) {
        _shopDic  = [[NSMutableDictionary  alloc] init];
    }
    return _shopDic;
}

- (NSMutableArray *)shopList
{
    if (!_shopList) {
        _shopList = [[NSMutableArray  alloc] init];
    }
    return _shopList;
}

- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList  = [[NSMutableArray alloc] init];
    }
    return _goodsList;
}

- (NSMutableDictionary *)goodDic
{
    if (!_goodDic) {
        _goodDic  = [[NSMutableDictionary  alloc] init];
    }
    return  _goodDic;
}

- (NSMutableArray *)timeIntervalList
{
    if (!_timeIntervalList) {
        _timeIntervalList  = [[NSMutableArray  alloc] init];
    }
    return _timeIntervalList;
}

- (TDFPublishInfoVo *)vo
{
    if (!_vo) {
        _vo  = [[TDFPublishInfoVo alloc] init];
    }
    return _vo;
}

//tabview刷新
- (void)relodData
{
    [self.manager reloadData];
}

//保存
- (void)save
{
    if (![self isVail]) {
        return ;
    }
    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD: self.progressHud ];
    NSMutableDictionary *parma = [self getPublishGoodsPostParams];
    if (self.action  == PUBLIFAILURESHSTATUS) { //发布失败重新发布
        @weakify(self);
        [[TDFChainMenuService new]  chainRetryPublishToShop:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController  popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
    else  //正常发布
    {
    @weakify(self);
    [[TDFChainMenuService new]  chainPublishToShop:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hide:YES];
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:nil data:nil];
        }
        [self.navigationController  popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
    }
}
//保存前的判断
- (BOOL) isVail
{
    if ([NSString isBlank:self.publishDate.textValue ]) {
        [AlertBox show: NSLocalizedString(@"发布日期不能为空", nil)];
        return  NO;
    }
    if ([NSString isBlank:self.publishTime.textValue]) {
        [AlertBox  show:NSLocalizedString(@"发布时间不能为空", nil)];
        return  NO;
    }
    return  YES;
}

- (NSMutableDictionary *)getPublishGoodsPostParams
{
    NSMutableDictionary *param  =  [[NSMutableDictionary alloc] init];
    if ([NSString  isNotBlank:self.publishDate.textValue ]) {
        NSString *conversionDateStr = [NSString stringWithFormat:@"%@ 00:00:00", self.publishDate.textValue];
        long  publishDate  =  [DateUtils  formateDateTime2:conversionDateStr];
        NSString *publishDateStr   =  [NSString stringWithFormat:@"%ld",publishDate/1000];
        [param setObject:publishDateStr forKey:@"publish_date"];
    }
    if ([NSString isNotBlank:self.publishTime.textValue]) {
        [param setObject:self.publishTime.textValue forKey:@"publish_time"];
    }
    if (self.action  == PUBLIFAILURESHSTATUS) {//发布失败重新发布
         NSMutableArray *shopIdArr  =  [self selectShopId:self.shopList];
          NSString *jsonShopStr  =  [shopIdArr  yy_modelToJSONString];
        [param setObject:jsonShopStr forKey:@"shop_entity_id_str"];
        if ([NSString isNotBlank:self.vo.publishPlanId]) {
            [param setObject:self.vo.publishPlanId forKey:@"publish_plan_id"];
        }
    }
    else  //正常发布
  {
    NSMutableArray *shopIdArr  =  [self selectShopId:self.shopList];
    NSMutableArray *goodsIdArr  =  [self selectGoodsId:self.goodsList];
    NSString *jsonShopStr  =  [shopIdArr  yy_modelToJSONString];
    NSString *jsonGoodsStr  = [goodsIdArr  yy_modelToJSONString];
    [param setObject:jsonShopStr forKey:@"shop_entity_id_str"];
    [param setObject:jsonGoodsStr forKey:@"menu_id_str"];
    [param setObject:self.plateEntityId forKey:@"plate_entity_id"];
 }
    return param;
}

//返回协议
- (void)closeMultiView:(NSInteger)event
{
    
}

//保存协议
- (void)multiCheck:(NSInteger)event items:(NSMutableArray *)items
{
     NSSet * setArr  = [NSSet setWithArray:items];
     [self.navigationController popViewControllerAnimated:YES];
    if (event == PULISHOPDefine ) {
        self.publishShops.textValue = [NSString stringWithFormat:@"%lu",(unsigned long)setArr.count];
        [self relodData];
        [self changeIsSelectNo];
        for (NSString *iteamId in setArr) {
            [self changeSelectId: iteamId ];
        }
    }
    else
    {
        self.publishGoods.textValue  = [NSString stringWithFormat:@"%lu",(unsigned long)setArr.count];
        [self relodData];
        [self changeMenuIsSelectNo];
        for (NSString *iteamId in setArr) {
        [self changeMenuSelectId:iteamId];
        }
    }
}

- (void)transShopDic
{
    int num = 0;
    [self.shopDic removeAllObjects];
    if ([ObjectUtil isNotEmpty:self. shopList]) {
      for (PlateBranchVo *vo in self.shopList) {
        num ++ ;
        if (vo.branchEntityId == nil) {
            vo.branchEntityId = [NSString stringWithFormat:@"%d",num];
        }
        if (vo.plateShopVoList.count != 0) {
            [self.shopDic setValue:vo.plateShopVoList forKey:vo.branchEntityId];
        }
     }
   }
}

- (void)transMenuDic
{
    int num = 0;
    [self.goodDic removeAllObjects];
    if ([ObjectUtil isNotEmpty:self.goodsList]) {
      for (PlateKindMenuVo *vo in self.goodsList) {
        num ++ ;
         if (vo.kindMenuId == nil) {
            vo.kindMenuId = [NSString stringWithFormat:@"%d",num];
          }
        if (vo.plateMenuVoList.count != 0) {
            [self.goodDic setValue:vo.plateMenuVoList forKey:vo.kindMenuId];
        }
      }
   }
}
//根据ID匹配选中的门店
- (void)changeSelectId:(NSString *)iteamId
{
    if ([ObjectUtil  isNotEmpty:self.shopList]) {
        for (PlateBranchVo *shopVo in self.shopList) {
            for (PlateShopVoList *plateVo in shopVo.plateShopVoList) {
                if ([plateVo.shopEntityId  isEqualToString:iteamId]) {
                    plateVo.isSelected =YES;
                }
            }
        }
    }
}

//设置选中状态为NO
- (void)changeIsSelectNo
{
    if ([ObjectUtil  isNotEmpty:self.shopList]) {
    for (PlateBranchVo *shopVo in self.shopList) {
        for (PlateShopVoList *plateVo in shopVo.plateShopVoList) {
            plateVo.isSelected = NO;
        }
    }
  }
}

//设置商品为不选中
- (void)changeMenuIsSelectNo
{
   if ([ObjectUtil isNotEmpty:self.goodsList]) {
    for (PlateKindMenuVo *shopVo in self.goodsList) {
        for (PlateMenuVoList *plateVo in shopVo.plateMenuVoList) {
            plateVo.isSelected = NO;
        }
     }
   }
}

//设置商品为选中
- (void)changeMenuSelectId:(NSString *)iteamId
{
    if ([ObjectUtil isNotEmpty:self.goodsList]) {
     for (PlateKindMenuVo *shopVo in self.goodsList) {
        for (PlateMenuVoList *plateVo in shopVo.plateMenuVoList) {
            if ([plateVo.menuId  isEqualToString:iteamId]) {
                plateVo.isSelected =YES;
            }
         }
      }
   }
}

//获取店铺选中的Id
- (NSMutableArray *)selectShopId:(NSMutableArray *)data
{
    NSMutableArray *shopIdArr  = [NSMutableArray array] ;
    if ([ObjectUtil  isNotEmpty:self.shopList]) {
        for (PlateBranchVo *shopVo in self.shopList) {
          for (PlateShopVoList *plateVo in shopVo.plateShopVoList) {
            if (plateVo.isSelected) {
                [shopIdArr addObject:plateVo.shopEntityId];
             }
          }
       }
    }
    return shopIdArr;
}

//获取商品选中的Id
- (NSMutableArray *)selectGoodsId:(NSMutableArray *)data
{
    NSMutableArray *menuIdArr  = [NSMutableArray array] ;
    if ([ObjectUtil isNotEmpty:self.goodsList]) {
     for (PlateKindMenuVo *shopVo in self.goodsList) {
        for (PlateMenuVoList *plateVo in shopVo.plateMenuVoList) {
            if (plateVo.isSelected) {
                [menuIdArr addObject:plateVo.menuId];
            }
        }
     }
  }
    return menuIdArr;
}


@end
