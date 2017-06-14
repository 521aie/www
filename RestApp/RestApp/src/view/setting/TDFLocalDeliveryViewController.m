//
//  TDFLocalDeliveryViewController.m
//  RestApp
//
//  Created by iOS香肠 on 2017/3/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLocalDeliveryViewController.h"
#import "TDFRootViewController+AlertMessage.h"
#import "DHTTableViewManager.h"
#import "TDFEditViewHelper.h"
#import "TDFBaseEditView.h"
#import "DHTTableViewSection.h"
#import "TDFTextfieldItem.h"
#import "Masonry.h"
#import "NSString+Estimate.h"
#import "TDFTextItem.h"
#import "TDFKabawService.h"
#import "ObjectUtil.h"


@interface TDFLocalDeliveryViewController ()<TDFEditTextFieldViewDelegate>

@property (nonatomic ,strong) DHTTableViewManager * manager;
@property (nonatomic ,strong) TDFTextfieldItem  *businessCode;
@property (nonatomic ,strong) TDFTextfieldItem *shopCode;
@property (nonatomic  ,strong) TDFTextItem  *tipItem;
@property (nonatomic  ,strong) UITableView * tabView;
@property (nonatomic , assign) BOOL  isAdd;
@end

@implementation TDFLocalDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =NSLocalizedString( @"开通顺丰同城配送", nil) ;
    self.isAdd  = YES;
    [self configNavBar];
    [self createTabview];
    [self  initNotifacation];
    [self configureManager];
    [self configureMainView];
    [self getTakeOutInfo];
   
}

- (void)initNotifacation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeNavTitles:) name:kTDFEditViewIsShowTipNotification object:nil];

}


-(void)shouldChangeNavTitles:(NSNotification *)notifacion
{
    BOOL isHide = [self isHideTip];
    if (!self.isAdd) {
        [self configNavigationBar:isHide];
    }
  
    
}

- (void)leftNavigationButtonAction:(id)sender
{
    if (!self.isAdd) {
        [self alertChangedMessage:[self isHideTip]];
    }else
    {
        [super leftNavigationButtonAction:sender];
    }
}

- (void)rightNavigationButtonAction:(id)sender
{
        [self showMessageWithTitle:@"" message:@"请确定修改后的编码准确和有效，否则会影响系统对接。确定保存吗？" cancelBlock:^{
            
        } enterBlock:^{
             [self updateSave];
        }];
    
}

-(BOOL)isHideTip
{
    
    BOOL ishide = [TDFEditViewHelper isAnyTipsShowedInSections:self.manager.sections];
    return ishide;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configNavBar
{
    [self  configNavigationBar:NO];
}
- (void)createTabview
{
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.7;
    [self.view addSubview:bgView];
    self.tabView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ];
    [self.view addSubview:self.tabView];
    self.tabView.backgroundColor=[UIColor clearColor];
    self.tabView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
}


- (UIView  *)customerConfirmButton
{
    UIView * footerView   = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton  *button   = [UIButton  buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(footerView.mas_left).with.offset(10);
        make.right.equalTo(footerView.mas_right).with.offset(-10);
        make.top.equalTo(footerView.mas_top).with.offset(10);
        make.height.mas_equalTo(40);
    }];
    [button  setTitle: NSLocalizedString(@"立即绑定并开通", nil)  forState:UIControlStateNormal];
    button.titleLabel.font   = [UIFont  systemFontOfSize:13];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor  = RGBA(209, 0, 0, 1);
    button.layer.masksToBounds  = YES;
    button.layer.cornerRadius  = 5;
    
    return footerView ;
}

- (UIView  *)customerEditConfirmButton
{
    UIView * footerView   = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
  
    UIButton  *removebutton   = [UIButton  buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:removebutton];
    [removebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).with.offset(10);
        make.right.equalTo(footerView.mas_right).with.offset(-10);
        make.top.equalTo(footerView.mas_top).with.offset(10);
        make.height.mas_equalTo(40);
    }];
    [removebutton  setTitle: NSLocalizedString(@"解除绑定", nil)  forState:UIControlStateNormal];
     removebutton.titleLabel.font   = [UIFont  systemFontOfSize:13];
     removebutton.backgroundColor  = RGBA(209, 0, 0, 1);
     removebutton.layer.masksToBounds  = YES;
     removebutton.layer.cornerRadius  = 5;
    [removebutton  addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView ;
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
    [self.manager registerCell:@"TDFTextfieldCell" withItem:@"TDFTextfieldItem"];
     [self.manager registerCell:@"TDFTextCell" withItem:@"TDFTextItem"];
}

- (void)configureMainView
{
    DHTTableViewSection *section  =   [DHTTableViewSection  section];
    self.businessCode   = [[TDFTextfieldItem alloc]  init ];
    self.businessCode.title    =  @"顺丰提供的商家编码";
    self.businessCode.isRequired  = YES ;
    self.businessCode.isShowTip  = NO;
    self.businessCode.detail  = @"当前店铺与顺丰同城签署合同后，顺丰会提供给您一个顺丰的商家编码，在此输入此编码便可进行绑定。";
    self.businessCode.textFieldDelegate  = self;
    [section  addItem:self.businessCode];
    
    self.shopCode  =  [[TDFTextfieldItem  alloc] init ];
    self.shopCode.title  = @"顺丰提供的店铺编码";
    self.shopCode.isRequired  = YES;
    self.businessCode.isShowTip  = NO;
    self.shopCode.detail  = @"当前店铺与顺丰同城签署合同后，顺丰会提供给您一个顺丰的店铺编码，在此输入此编码便可进行绑定。";
    self.shopCode.textFieldDelegate  = self;
    [section addItem:self.shopCode];
    
    
    self.tipItem   = [[TDFTextItem  alloc] init ];
    [section  addItem:self.tipItem];
    
    [self.manager  addSection:section];
}

- (void)getTakeOutInfo
{
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
     [[[TDFKabawService new] init] getTakeOutInfoSucess:^(NSURLSessionDataTask * _Nonnull response, id _Nonnull data) {
         [self.progressHud  hideAnimated: YES];
         [self  getInfoWithData:data];
         [self relod];
     } failure:^(NSURLSessionDataTask * _Nonnull response, NSError * _Nonnull error) {
         [self.progressHud  hideAnimated: YES];
           self.tabView.tableFooterView  =  [self customerConfirmButton];
           [self relod];
         [AlertBox show:error.localizedDescription];
     }];
}

- (void)getInfoWithData:(id) data
{
    NSDictionary  *content  = data [@"data"];
    if ([ObjectUtil  isNotEmpty:content ]) {
        NSString  *businessCode   =  content  [@"clientCode"];
        NSString  *shopCode   =  content [@"storeCode"];
        if ([NSString isBlank:businessCode]  &&  [NSString  isBlank:shopCode]) {
            self.isAdd  = YES;
            self.tabView.tableFooterView  =  [self customerConfirmButton];
        }else{
            self.isAdd   =  NO;
            [self configWithBusinnessCode:businessCode shopCode:shopCode];
            self.tabView.tableFooterView =[self  customerEditConfirmButton];
        }
       
    } else{
           self.isAdd   = YES;
          self.tabView.tableFooterView  =  [self customerConfirmButton];
    }
    if (self.isAdd) {
        self.tipItem.detail   =  @"注，在此输入编码后1-2个工作日内即可联系顺丰工作人员进行功能试用，试用前需将收银机数据更新并前往外卖设置页面进行相关设置。如有新店绑定，可联系顺丰商务（舒经理18357121336）接洽。";
    }else{
        self.tipItem.detail   =  @"如有新店绑定，可联系顺丰商务(舒经理18357121336)接洽。";
    }
    
}

- (void)relod
{
    [self.manager reloadData];
}

#pragma mark fillModel
- (void)configWithBusinnessCode:(NSString *)businessCode   shopCode:(NSString *)shopCode
{
    self.businessCode.textValue  = businessCode;
    self.businessCode.preValue  = businessCode;
    self.shopCode.textValue  = shopCode;
    self.shopCode.preValue  = shopCode;
}

#pragma mark save
- (void)save
{
    if (![self  isVail]) {
        return  ;
    }
    [self  showProgressHudWithText:NSLocalizedString(@"正在开通", nil)];
    [[[TDFKabawService  alloc] init]   bindTakeOutCientCode:self.businessCode.textValue storeCode:self.shopCode.textValue sucess:^(NSURLSessionDataTask * _Nonnull response, id _Nonnull data) {
        [self.progressHud  hideAnimated: YES];
        [AlertBox show:@"绑定成功，请前往外卖设置页面进行设置，并更新收银机数据"];
        [self  parseCurrentData:data];
    } failure:^(NSURLSessionDataTask * _Nonnull response, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated: YES];
//        [AlertBox  show:error.localizedDescription];
        [AlertBox show:@"网络有问题，请稍后重新输入申请"];
    }];
}

- (void)updateSave
{
    if (![self  isVail]) {
        return  ;
    }
    [[[TDFKabawService  alloc] init]   bindTakeOutCientCode:self.businessCode.textValue storeCode:self.shopCode.textValue sucess:^(NSURLSessionDataTask * _Nonnull response, id _Nonnull data) {
        [self.progressHud  hideAnimated: YES];
        [AlertBox show:@"修改成功，请及时更新收银机数据"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nonnull response, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated: YES];
        //        [AlertBox  show:error.localizedDescription];
        [AlertBox show:@"网络有问题，请稍后重新输入申请"];
    }];
}

- (BOOL)isVail
{
    if ([NSString  isBlank:self.businessCode.textValue]) {
        [AlertBox  show: @"商家编码不能为空!"];
        return  NO;
    }
    if ([NSString  isBlank:self.shopCode.textValue]) {
        [AlertBox  show:@"店铺编码不能为空!"];
        return NO;
    }
    return  YES;
}

- (void)parseCurrentData:(id)data
{
    [self getTakeOutInfo];
}


- (void)removeClick
{
    [self loadAlterView];
}

- (void)loadAlterView
{
     [self showMessageWithTitle:@"" message:@"解除绑定后将不支持顺丰同城配送，确定要解除绑定吗?" cancelBlock:^{
         
     } enterBlock:^{
         [self  removeBinding];
     }];
}

#pragma mark delete
- (void)removeBinding
{
    [self showProgressHudWithText:@"正在解决绑定"];
    [[[TDFKabawService  alloc]  init ]  removeBindSucess:^(NSURLSessionDataTask * _Nonnull response, id _Nonnull data) {
        [self.progressHud  hideAnimated: YES];
        [AlertBox show:@"成功解除绑定关系，收银机上将不再展示顺丰配送相关功能"];
        [self configWithBusinnessCode:nil shopCode:nil];
        [self getTakeOutInfo];
    } failure:^(NSURLSessionDataTask * _Nonnull reponse, NSError * _Nonnull error) {
        [self.progressHud  hideAnimated: YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma textDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath
{
    NSString *textValue  = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([NSString  isNotBlank:textValue]) {
        if([NSString  isNotNumAndLetter:textValue])
        {
            [AlertBox  show:@"输入有误，编码仅支持数字或英文字母"];
        }
    }
    return  YES;
}


@end
