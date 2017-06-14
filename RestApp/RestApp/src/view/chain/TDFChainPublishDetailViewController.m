//
//  TDFChainPublishDetailViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/21.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainPublishDetailViewController.h"
#import "DHTTableViewManager.h"
#import "TDFStaticLabelItem.h"
#import "ColorHelper.h"
#import "ViewFactory.h"
#import "TDFPlatePublishVo.h"
#import "ObjectUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "ChainPublishHistoryVo.h"
#import "TDFChainMenuService.h"
#import "TDFChainShopPublishGoodsViewController.h"
#import "TDFMediator+ChainMenuModule.h"
#define DETAILGOODBUTTON  1
#define DETAILSHOPBUTTON  2
#define NUMBERLABELHEIGHT  46.5 //估算的两行字体的高度
#define MENUSECTIONLOCATION  2  //商品section的位置
#define SHOPSECTIONLOCATION  4 //门店section的位置
@interface TDFChainPublishDetailViewController ()
@property (nonatomic ,strong) DHTTableViewManager *manager;
@property (nonatomic ,strong) UITableView *tabView;
@property (nonatomic ,strong) TDFStaticLabelItem *publishDate;
@property (nonatomic ,strong) TDFStaticLabelItem *brand;
@property (nonatomic ,strong) TDFStaticLabelItem *publishGoods;
@property (nonatomic ,strong) DHTTableViewSection *detailsSection;
@property (nonatomic ,strong) TDFStaticLabelItem *publishFailShops;
@property (nonatomic ,strong) DHTTableViewSection *detailsFailShopsSection;
@property (nonatomic ,strong) DHTTableViewSection *publishFailShopsSection;
@property (nonatomic ,assign) BOOL  isHide;
@property (nonatomic ,assign) BOOL isHideFailShop;
@property (nonatomic , assign) NSInteger  action ;
@property (nonatomic ,strong) ChainPublishHistoryVo * publishHistoryVo;
@property (nonatomic ,strong)  NSString *publishMenuVoStr ;
@property (nonatomic ,strong) NSString *publishShopVoStr;


@end

@implementation TDFChainPublishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTheData];
    
}

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
    self.tabView.tableFooterView =[ViewFactory generateFooter:100];
    
}
//获取传值数据
- (void)getTheData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        self.publishHistoryVo  =  self.dic [@"data"];
        [self getShopAndMenuStr];
        self.title = self.publishHistoryVo.publishStatusDesc;
        self.action = self.publishHistoryVo.publishStatus;
        [self createTabView];
        [self customSection];
        [self  configureManager];
        [self initMainView];
        [self addDetailsSection];
        if (self.action == TDFActionSucess) {
            [self addNoteSection];
        }
        if (self.action == TDFActionFail) {
            [self  addPublishFailShops];
            [self addDetailsPublishFailShop];
        }
    }
    
}

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
//获取商品名字和门店名字Str
- (void)getShopAndMenuStr
{
    NSMutableArray *menuArr = [[NSMutableArray alloc] init];
    for (PlateMenuVoList *vo  in self.publishHistoryVo.plateMenuVoList) {
        [menuArr addObject:vo.menuName];
    }
    self.publishMenuVoStr  = [ObjectUtil array2String:menuArr];
   
    NSMutableArray *shopArr  = [[NSMutableArray alloc] init];
    for (PlateShopVoList *vo  in self.publishHistoryVo.plateShopVoList) {
        [shopArr addObject:vo.shopName];
    }
    self.publishShopVoStr  = [ObjectUtil array2String:shopArr];
    
}
//head的自定义View
- (void)customSection
{
    DHTTableViewSection *section  =  [DHTTableViewSection section];
    section.headerView  = [self  createCustomView];
    section.headerHeight = 120;
    [self.manager addSection:section];
}

- (UIView *)createCustomView
{
    UIView *customView  = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    UIImageView *statusImg  =  [[UIImageView  alloc] init];
    if (self.action == TDFActionSucess) {
      statusImg.image = [UIImage imageNamed:@"Group 22.png"];
    }
    else
    {
         statusImg.image = [UIImage imageNamed:@"Group 2.png"];
    }
    [customView addSubview:statusImg];
    [statusImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customView.mas_top).with.offset(20);
        make.centerX.equalTo (customView.mas_centerX);
        make.size.mas_equalTo (CGSizeMake(35, 35));
    }];
   
    UILabel *statusLbl  = [[UILabel  alloc] init];
    [customView addSubview:statusLbl];
     [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(statusImg.mas_bottom).with.offset(20);
         make.centerX.equalTo (customView.mas_centerX);
         make.size.mas_equalTo(CGSizeMake(300, 20));
     }];
    if (self.action == TDFActionSucess) {
       statusLbl .textColor  = [ColorHelper getGreenColor ];
         statusLbl.text = NSLocalizedString(@"商品已发布成功!", nil);
    }
    else
    {
    statusLbl .textColor  = [ColorHelper getRedColor];
         statusLbl.text = NSLocalizedString(@"有门店发布失败!", nil);
    }
    statusLbl.font = [UIFont systemFontOfSize:20];
    statusLbl.textAlignment = NSTextAlignmentCenter;
    UIView *line = [[UIView alloc] init];
    [customView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (customView.mas_bottom).with.offset(1);
        make.left.equalTo(customView.mas_left).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-8, 1));
    }];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.7 ;
    return customView;
}

//日期，品牌 ，发布商品的自定义section
- (void) initMainView
{
    DHTTableViewSection *section  =  [DHTTableViewSection section];
    self.publishDate  =  [[TDFStaticLabelItem  alloc] init];
    self.publishDate.title = NSLocalizedString(@"发布日期", nil);
    self.publishDate.textValue =  [NSString stringWithFormat:@"%@%@",self.publishHistoryVo.publishDate,self.publishHistoryVo.timeInterval];
    self.publishDate.isRequired = NO;
    [section addItem:self.publishDate];
    
    
    self.brand  =  [[TDFStaticLabelItem  alloc] init];
    self.brand.title = NSLocalizedString(@"品牌", nil);
    self.brand.textValue = self.publishHistoryVo.plateName?self.publishHistoryVo.plateName :@"";
    self.brand.isRequired =NO;
    [section addItem:self.brand];
    
    
    self.publishGoods  =  [[TDFStaticLabelItem  alloc] init];
    self.publishGoods.title = NSLocalizedString(@"发布商品", nil);
    self.publishGoods.textValue = [NSString stringWithFormat:@"%d",self.publishHistoryVo.menuCount];
    self.publishGoods.isRequired =NO;
    [section addItem:self.publishGoods];
    
    [self.manager addSection:section];
    
}
//发布成功的商品详情
- (void)addDetailsSection
{
    self.detailsSection  =  [DHTTableViewSection section];
    if (!self.isHide) {
        
        CGFloat height  =  [self textHeight:self.publishMenuVoStr];
        if (height >NUMBERLABELHEIGHT) {
               height =NUMBERLABELHEIGHT;
        }
        self.detailsSection.headerHeight= 30 +height;
    }
    else
    {
        CGFloat height  =  [self  textHeight:self.publishMenuVoStr];
        self.detailsSection.headerHeight= height +30 ;
    }
    self.detailsSection.headerView = [self customGoodsViewWithHegith:self.detailsSection.headerHeight hide:self.isHide tag:DETAILGOODBUTTON detailStr:self.publishMenuVoStr];
    [self.manager insertSection:self.detailsSection atIndex:MENUSECTIONLOCATION];
    
    
}

- (UIView *)customGoodsViewWithHegith:(CGFloat)height  hide:(BOOL) isHide  tag:(NSInteger)tag  detailStr:(NSString *)detailStr
{
    
    UIView *detaisView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    UILabel *goodLbl  = [[UILabel  alloc] init];
    [detaisView addSubview:goodLbl];
    [goodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detaisView.mas_top);
        make.left.equalTo(detaisView.mas_left).with.offset(10);
         CGFloat menuHeight  = [self textHeight:detailStr];
        if (!isHide) {
            if (menuHeight>NUMBERLABELHEIGHT) {
                menuHeight =NUMBERLABELHEIGHT;
            }
        }
        make.size.mas_equalTo (CGSizeMake(self.view.frame.size.width-10, menuHeight+10));
    }];
    if (!isHide) {
        goodLbl.text = detailStr;
        goodLbl.numberOfLines = 2;
        
    }
    else
    {
        goodLbl.text = detailStr;
        goodLbl.numberOfLines = 0;
    }
    if(self.action  ==TDFActionSucess)
    {
        goodLbl.textColor = [UIColor grayColor];
    }
  else
    {
        goodLbl.textColor  = [UIColor redColor];
     }
    goodLbl.font = [UIFont systemFontOfSize:13];
    [self customerDetailsButton:detaisView Label:goodLbl tag:tag];
    return detaisView;
    
}

- (void)customerDetailsButton:(UIView *)detaisView Label:(UILabel *)goodLbl  tag:(NSInteger)tag
{
    UIImageView *nextImg  = [[UIImageView alloc] init];
    [detaisView addSubview:nextImg];
    [nextImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (detaisView.mas_right).with.offset(-5);
        make.top.equalTo(goodLbl.mas_bottom).with.offset( -10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    nextImg.image = [UIImage imageNamed:@"ico_next_down_blue"];
    UILabel *label  = [[UILabel  alloc] init];
    [detaisView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo (nextImg.mas_left).with.offset(-5);
            make.top.equalTo (nextImg.mas_top).with.offset(-5);
            make.size.mas_equalTo (CGSizeMake(40, 30));
        }];
    [self customExpandLbl:label tag:tag];
    UIButton *clickNextBtn  = [[UIButton  alloc] init];
    [detaisView addSubview:clickNextBtn];
    [clickNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (nextImg.mas_right);
        make.top.equalTo (nextImg.mas_top).with.offset(-3);
        make.size.mas_equalTo (CGSizeMake(100, 30));
    }];
    clickNextBtn.tag = tag;
    clickNextBtn.backgroundColor =  [UIColor clearColor];
    [clickNextBtn addTarget:self action:@selector(expandTheGoods:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView  = [[UIView  alloc] init];
    [detaisView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left .mas_equalTo (detaisView.mas_left).with.offset(10);
        make.top.equalTo(detaisView.mas_bottom).with.offset(1);
        make.size.mas_equalTo(CGSizeMake(detaisView.frame.size.width-10*2,1));
    }];
    lineView.backgroundColor   =  [UIColor grayColor];
    lineView.alpha = 0.7;
    CGFloat height  =  [self textHeight:goodLbl.text];
    if (height <NUMBERLABELHEIGHT) {
        label.hidden  = YES;
        clickNextBtn.hidden  =YES;
        nextImg.hidden  = YES;
        nextImg.hidden = YES;
    }
    else
    {
        label.hidden  = NO;
        clickNextBtn.hidden  = NO;
        nextImg.hidden = NO;
    }
}

//设置label的属性
- (void)customExpandLbl:(UILabel *)label tag:(NSInteger)tag
{
    if (self.action  == TDFActionSucess) {
        if (!self.isHide) {
            label.text = NSLocalizedString(@"展开", nil);
        }
        else
        {
            label .text = NSLocalizedString(@"收起", nil);
        }
    }
    else
    {
        if (tag == DETAILGOODBUTTON) {
            if (!self.isHide) {
                label.text = NSLocalizedString(@"展开", nil);
            }
            else
            {
                label .text = NSLocalizedString(@"收起", nil);
            }
        }
        else
        {
            if (!self.isHideFailShop) {
                label.text = NSLocalizedString(@"展开", nil);
            }
            else
            {
                label .text = NSLocalizedString(@"收起", nil);
            }
        }
    }
    label.textAlignment =NSTextAlignmentRight;
    label.textColor = [ColorHelper getBlueColor];
    label.font  = [UIFont systemFontOfSize:15];
}

//展开按钮
- (void)expandTheGoods:(UIButton *)button
{
    if (self.action == TDFActionSucess) {
        self.isHide= !self.isHide;
        [self.manager removeSectionAtIndex:MENUSECTIONLOCATION];
        [self    addDetailsSection];
        [self.manager reloadData];
    }
      else
      {
          if (button.tag == DETAILGOODBUTTON) {
          self.isHide = !self.isHide;
          [self.manager removeSectionAtIndex:MENUSECTIONLOCATION];
          [self   addDetailsSection];
          [self.manager reloadData];
        }
          if (button.tag == DETAILSHOPBUTTON) {
            self.isHideFailShop = !self.isHideFailShop;
              [self.manager removeSectionAtIndex:SHOPSECTIONLOCATION];
              [self addDetailsPublishFailShop];
               [self.manager reloadData];
          }
      }
    
}
//注释section
- (void)addNoteSection
{
    DHTTableViewSection *section  = [[DHTTableViewSection  alloc] init];
    section.headerHeight =60;
    section.headerView = [self  customNoteView];
    [self.manager addSection:section];
}

- (UIView *)customNoteView
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UILabel*lable   = [[UILabel  alloc] init];
    [view addSubview:lable];
    [lable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (view.mas_left).with.offset(10);
        make.top.equalTo(view.mas_top);
//        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.right.equalTo(view.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    lable.text = NSLocalizedString(@"注：请提醒门店重启收银机或者点击数据更新按钮手动更新。", nil);
    lable.font = [UIFont systemFontOfSize:13];
    lable.numberOfLines =0 ;
    lable.textColor = [UIColor grayColor];
    return view;
}
//发布失败情况下的门店section
- (void) addPublishFailShops
{
    self.publishFailShopsSection  =  [DHTTableViewSection section];
    self.publishFailShops  = [[TDFStaticLabelItem  alloc] init];
    self.publishFailShops.title = NSLocalizedString(@"发布失败的门店", nil);
    self.publishFailShops.textValue = [NSString stringWithFormat:@"%d",self.publishHistoryVo.failShopCount];
    self.publishFailShops.isRequired =NO;
    [self.publishFailShopsSection addItem:self.publishFailShops];
    [self.manager addSection:self.publishFailShopsSection];
  
}
//门店详情section
- (void)addDetailsPublishFailShop
{
    self.detailsFailShopsSection  =  [DHTTableViewSection section];
    CGFloat menuHeight  = [self textHeight:self.publishShopVoStr];
    if (!self.isHideFailShop) {
            CGFloat menuHeight  = [self textHeight:self.publishShopVoStr];
        if (menuHeight>NUMBERLABELHEIGHT) {
            menuHeight =NUMBERLABELHEIGHT;
        }
        self.detailsFailShopsSection.headerHeight= 30+menuHeight;
    }
    else
    {
        self.detailsFailShopsSection.headerHeight= menuHeight+30 ;
    }
    self.detailsFailShopsSection.headerView = [self customGoodsViewWithHegith:self.detailsFailShopsSection.headerHeight hide: self.isHideFailShop tag:DETAILSHOPBUTTON detailStr:self.publishShopVoStr];
    [self.manager insertSection:self.detailsFailShopsSection atIndex:SHOPSECTIONLOCATION];
}

//计算lable的高度
- (CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(301, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}


@end
