//
//  TDFBranchCompanyEditViewController.m
//  RestApp
//
//  Created by zishu on 16/7/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBranchCompanyEditViewController.h"
#import "NavigateTitle2.h"
#import "ViewFactory.h"
#import "NSString+Estimate.h"
#import "UIHelper.h"
#import "ItemTitle.h"
#import "XHAnimalUtil.h"
#import "TDFChainService.h"
#import <libextobjc/EXTScope.h>

@implementation TDFBranchCompanyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideOldNavigationBar = YES;
    self.changed=NO;
    [self initMainView];
    [self initNavigate];
    [self initNotifaction];

    self.dataArr = [[NSMutableArray alloc] init];
    self.branchCompanyListArr = [[NSMutableArray alloc] init];
    [self loadData:self.vo1 action:self.action];
}

-(void) initNavigate
{
   self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"分公司详情", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_BranchCompanyEditViewController_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_BranchCompanyEditViewController_Change object:nil];
}
#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
        return;
    }
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void) initMainView
{
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    self.titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.titleDiv.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.titleDiv];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.frame.size.height-64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.scrollView.frame.size.height)];
    self.container.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.container];
    
    ItemTitle *oneTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    [oneTitle awakeFromNib];
    [self.container addSubview:oneTitle];
     oneTitle.lblName.text = NSLocalizedString(@"基本设置", nil);
    
    [self initBaseSettingView];
    
    ItemTitle *secondTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 344, SCREEN_WIDTH, 48)];
    [secondTitle awakeFromNib];
    secondTitle.lblName.text = NSLocalizedString(@"账户信息", nil);
    [self.container addSubview:secondTitle];

    [self initCountInfo];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 550, SCREEN_WIDTH-20, 60)];
    tip.textColor = [UIColor colorWithWhite:0.33 alpha:0.75];
    tip.text = NSLocalizedString(@"提示：使用微信或手机号码方式登录二维火掌柜，使用此处提供的账户信息可添加工作的店家，确认管理员（admin）与店铺的工作关系", nil);
    tip.numberOfLines = 0;
    tip.font = [UIFont systemFontOfSize:12];
    [self.container addSubview:tip];
    
    self.btnDel = [[UIButton alloc] initWithFrame:CGRectMake(10,660, SCREEN_WIDTH-20, 40)];
    [self.btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [self.btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    [self.btnDel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.btnDel];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void) initBaseSettingView
{
    self.nameEditItemText = [[EditItemText alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 48)];
    [self.nameEditItemText initLabel:NSLocalizedString(@"分公司名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.container addSubview:self.nameEditItemText];
    
    self.superCompanyRadio = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 96, SCREEN_WIDTH, 48)];
    [self.superCompanyRadio awakeFromNib];
    [self.container addSubview:self.superCompanyRadio];
    [self.superCompanyRadio initLabel:NSLocalizedString(@"此分公司有上级公司", nil) withHit:NSLocalizedString(@"注：打开此按钮，选择上级公司，分公司可添加4级。", nil) delegate:self];
    
    self.superCompany = [[EditItemList alloc] initWithFrame:CGRectMake(0, 96, SCREEN_WIDTH, 48)];
    [self.container addSubview:self.superCompany];
    [self.superCompany initLabel:NSLocalizedString(@"上级公司", nil) withHit:nil isrequest:YES delegate:self];

    self.linkMan = [[EditItemText alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 48)];
    [self.linkMan initLabel:NSLocalizedString(@"联系人", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container addSubview:self.linkMan];
    
    self.phone = [[EditItemText alloc] initWithFrame:CGRectMake(0, 192, SCREEN_WIDTH, 48)];
    [self.phone initLabel:NSLocalizedString(@"联系电话", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container addSubview:self.phone];
    
    self.email = [[EditItemText alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 48)];
    [self.email initLabel:NSLocalizedString(@"邮箱", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container addSubview:self.email];
    
    self.address = [[EditItemText alloc] initWithFrame:CGRectMake(0, 288, SCREEN_WIDTH, 48)];
    [self.address initLabel:NSLocalizedString(@"地址", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.container addSubview:self.address];

}

- (void)initCountInfo
{
    self.branchCode = [[EditItemView alloc] initWithFrame:CGRectMake(0, 392, SCREEN_WIDTH, 48)];
    [self.branchCode initLabel:NSLocalizedString(@"分公司编码", nil) withHit:nil];
    [self.container addSubview:self.branchCode];
    
    self.managerName = [[EditItemView alloc] initWithFrame:CGRectMake(0, 440, SCREEN_WIDTH, 48)];
    [self.managerName initLabel:NSLocalizedString(@"管理员用户名", nil) withHit:nil];
    [self.container addSubview:self.managerName];
    
    self.pwd = [[EditItemView alloc] initWithFrame:CGRectMake(0, 488, SCREEN_WIDTH, 48)];
    [self.pwd initLabel:NSLocalizedString(@"管理员初始密码", nil) withHit:nil];
    [self.container addSubview:self.pwd];

}

- (void)loadData:(BranchTreeVo *)vo action:(int)action
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if ([[[Platform Instance] getkey:IS_BRANCH] isEqualToString:@"1"]) {
        [self.btnDel setHidden:YES];
    }
    if (action==ACTION_CONSTANTS_ADD) {
        [self.superCompany visibal:NO];
        self.title=NSLocalizedString(@"添加分公司", nil);
        [self clearDo];
        [self creatUserInfo];
        [self controlEditViewEnable];
    }else{
         NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        [parma setObject:vo.entityId forKey:@"entity_id"];

         [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        @weakify(self);
        [[TDFChainService new] queryBranchInfoWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.vo = [[BranchVo alloc] initWithDictionary:data[@"data"]];
            [self fillModel];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             @strongify(self);
            [self.progressHud hide:YES];
           [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void) creatUserInfo
{
     NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
     @weakify(self);
    [[TDFChainService new] createUserWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         @strongify(self);
        self.userVO = [[UserVO alloc] initWithDictionary:data[@"data"]];
        [self.branchCode initData:self.userVO.branchCode withVal:self.userVO.branchCode];
        [self.managerName initData:self.userVO.userName withVal:self.userVO.userName];
        [self.pwd initData:self.userVO.pwd withVal:self.userVO.pwd];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 数据层处理
-(void) clearDo
{
    self.vo = nil;
    [self.nameEditItemText initData:nil];
    [self.superCompanyRadio initData:@"0"];
    [self.superCompanyRadio visibal:YES];
    [self.superCompany visibal:NO];
    [self.linkMan initData:nil];
    [self.phone initData:nil];
    [self.email initData:nil];
    [self.address initData:nil];
    self.branchName = @"";
    self.branchEntityId = @"";
    [self.branchCode initData:self.userVO.branchCode withVal:self.userVO.branchCode];
    [self.managerName initData:self.userVO.username withVal:self.userVO.username];
    [self.pwd initData:self.userVO.pwd withVal:self.userVO.pwd];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    self.title = self.vo.branchName;
    [self.nameEditItemText initData:self.vo.branchName];

    if ([self.vo.parentEntityId isEqualToString:@"0"]) {
            [self.superCompanyRadio initData:@"0"];
            [self.superCompany visibal:NO];
    }else{
            [self.superCompanyRadio initData:@"1"];
            [self.superCompany initData:self.vo.parentName withVal:self.vo.parentEntityId];
            [self.superCompany visibal:YES];
    }
    [self.linkMan initData:self.vo.contacts];
    [self.phone initData:self.vo.tel];
    [self.email initData:self.vo.email];
    [self.address initData:self.vo.address];
    [self.branchCode initData:self.vo.branchCode withVal:self.vo.branchCode];
    [self.managerName initData:self.vo.userName withVal:self.vo.userName];
    [self.pwd initData:self.vo.startPwd withVal:self.vo.startPwd];
    [self controlEditViewEnable];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void) controlEditViewEnable
{
    [self.nameEditItemText setEnabled:[[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]];
    
    self.superCompany.userInteractionEnabled = [[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"];
    self.superCompanyRadio.userInteractionEnabled = [[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"];
    
    [self.linkMan setEnabled:[[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]];
    [self.phone setEnabled:[[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]];
    [self.email setEnabled:[[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]];
    [self.address setEnabled:[[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]];
    
    if (![[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        self.superCompany.lblVal.textColor = [UIColor grayColor];
        [self.superCompany.imgMore setImage:[UIImage imageNamed:@""]];
        
    }else{
        self.superCompany.lblVal.textColor = [UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
        [self.superCompany.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    }
}

- (void)buttonClick:(UIButton *)btn
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [parma setObject:self.vo.entityId forKey:@"entity_id"];
    
    @weakify(self);
    [[TDFChainService new] checkBranchWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
         @strongify(self);
        if ([data[@"data"] intValue] == 0) {
            [AlertBox show:NSLocalizedString(@"该分公司旗下还有别的分公司或者门店，清除后才可以删除。", nil)];
            return;
        }else{
            [UIHelper alert:self.view andDelegate:self andTitle:NSLocalizedString(@"确定要删除此分公司吗？删除后就无法恢复了，请仔细考虑。", nil)];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
        [AlertBox show:error.localizedDescription];
    }];
 }

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
      if (buttonIndex == 0) {
          [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
          NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
          [parma setObject:self.vo.entityId forKey:@"entity_id"];

          @weakify(self);
          [[TDFChainService new] deleteBranchWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
              @strongify(self);
              [self.progressHud hide:YES];
              self.editCallBack(YES);
              [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                 @strongify(self);
              [self.progressHud hide:YES];
              [AlertBox show:error.localizedDescription];
          }];
    }
}

-(void) onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
       [self.superCompany initLabel:NSLocalizedString(@"•上级公司", nil) withHit:nil delegate:self];
        if ([NSString isNotBlank:self.vo.parentName]) {
              [self.superCompany initData:self.vo.parentName withVal:self.vo.parentEntityId];
        }else{
            if ([NSString isBlank:self.branchName]) {
                [self.superCompany setPlaceholder:NSLocalizedString(@"请选择", nil)];
            }else{
                [self.superCompany initData:self.branchName withVal:self.branchEntityId];
            }
        }
    
    self.superCompany.lblVal.textColor = [UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:204.0/255.0 alpha:1];
    [self.superCompanyRadio changeData:[obj getStrVal]];
    [self.superCompany visibal:result];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void) onItemListClick:(EditItemList *)obj
{
    [self.dataArr removeAllObjects];
    [self.branchCompanyListArr removeAllObjects];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    
    if (self.action == ACTION_CONSTANTS_ADD) {
         [param setObject:@"0" forKey:@"type"];
        [param setObject:@"" forKey:@"branch_entity_id"];
    }else{
        [param setObject:@"1" forKey:@"type"];
        [param setObject:self.vo.entityId forKey:@"branch_entity_id"];
    }
        @weakify(self);
        [[TDFChainService new] queryBranchListLimitWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            if ([ObjectUtil isNotEmpty:data[@"data"]]) {
                for (NSMutableDictionary *dic in data[@"data"]) {
                    BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                    branchTreeVo.branchName = [self getName:branchTreeVo.level-1 name:branchTreeVo.branchName];
                    [self.dataArr addObject:branchTreeVo];
                }
                for (NSMutableDictionary *dic in data[@"data"]) {
                    BranchTreeVo *branchTreeVo = [[BranchTreeVo alloc] initWithDictionary:dic];
                    [self.branchCompanyListArr addObject:branchTreeVo];
                }
            }

            TDFMediator *mediator = [[TDFMediator alloc] init];
            UIViewController *branchListContoller = [mediator TDFMediator_branchCompanyListViewControllerWithType:EditType delegate:self branchCompanyList:self.dataArr branchCompanyListArr:self.branchCompanyListArr isFromBranchEditView:YES listCallBack:^(BOOL orFresh) {
            }];
            [self.navigationController pushViewController:branchListContoller animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [AlertBox show:error.localizedDescription];
        }];
}

-(NSString*) getName:(int)level name:(NSString*)name
{
    if (level==0) {
        return name;
    }
    NSMutableString* result=[NSMutableString string];
    [result appendString:@""];
    for (int i=0; i<level; i++) {
        [result appendString:NSLocalizedString(@"▪︎", nil)];
    }
    [result appendString:@""];
    [result appendString:name];
    return [NSString stringWithString:result];
}

- (BOOL)selectOption:(id<INameItem>)data branchId:(NSString *)branchId
{
 [self.superCompany changeData:[data obtainItemName] withVal:[data obtainItemId]];
    self.branchName = [data obtainItemName];
    self.branchEntityId = [data obtainItemId];
    return YES;
}

- (void)save
{
    if (![self isValid]) {
        return;
    }
    NSString *tip = [NSString stringWithFormat:NSLocalizedString(@"正在%@分公司信息", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    
    [self showProgressHudWithText:tip];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    [parma setObject:[JsonHelper transJson:[self branchVoTransMode]] forKey:@"branch_vo_str"];
   
    if (self.action == ACTION_CONSTANTS_ADD) {
        [parma setObject:[JsonHelper transJson:self.userVO] forKey:@"user_vo_str"];
        @weakify(self);
        [[TDFChainService new] createBranchWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            self.vo = [[BranchVo alloc] initWithDictionary:data[@"data"]];
            [self fillModel];
            self.editCallBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        @weakify(self);
        [[TDFChainService new] modifyBranchWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [self.progressHud hide:YES];
            [self loadData:self.vo1 action:ACTION_CONSTANTS_EDIT];
            self.editCallBack(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             @strongify(self);
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

#pragma ui-data-save
-(BOOL)isValid
{
    if ([NSString isBlank:self.nameEditItemText.txtVal.text]) {
        [AlertBox show:NSLocalizedString(@"分公司名称不能为空", nil)];
        return NO;
    }
    if ([NSString isBlank:self.branchEntityId] && [[self.superCompanyRadio getStrVal] isEqualToString:@"1"]) {
        if ([self.superCompany.lblVal.text isEqualToString:NSLocalizedString(@"请选择", nil)]) {
            [AlertBox show:NSLocalizedString(@"上级公司不能为空", nil)];
            return NO;
        }
    }
    if ([NSString isNotBlank:self.email.txtVal.text]) {
        if ([NSString isValidateEmail:self.email.txtVal.text]==NO) {
            [AlertBox show:NSLocalizedString(@"您输入的邮箱格式不正确", nil)];
            return NO;
        }
    }
    if (self.linkMan.txtVal.text.length>20) {
        [AlertBox show:NSLocalizedString(@"联系人最多输入20个字符", nil)];
        return NO;
    }
    return YES;
}

-(BranchVo *)branchVoTransMode
{
    BranchVo* tempUpdate=[BranchVo new];
    if ([NSString isNotBlank:[self.nameEditItemText getStrVal]]) {
        tempUpdate.branchName=[self.nameEditItemText getStrVal];
    }
    if ([NSString isNotBlank:self.branchName]) {
        tempUpdate.parentName = self.branchName;
    }else{
        tempUpdate.parentName = self.vo.parentName;
    }
    if ([NSString isNotBlank:self.branchEntityId]) {
        tempUpdate.parentEntityId = self.branchEntityId;
    }else{
        tempUpdate.parentEntityId = self.vo.parentEntityId;
    }
    if ([NSString isNotBlank:self.vo.parentEntityId]) {
        if ([[self.superCompanyRadio getStrVal] isEqualToString:@"0"]) {
            tempUpdate.parentEntityId = @"0";
        }
    }
    if ([NSString isNotBlank:[self.email getStrVal]]) {
        tempUpdate.email=[self.email getStrVal];
    }
    if ([NSString isNotBlank:[self.linkMan getStrVal]]) {
        tempUpdate.contacts=[self.linkMan getStrVal];
    }
    if ([NSString isNotBlank:[self.phone getStrVal]]) {
        tempUpdate.tel=[self.phone getStrVal];
    }
    if ([NSString isNotBlank:[self.address getStrVal]]) {
        tempUpdate.address=[self.address getStrVal];
    }

    tempUpdate.branchCode = self.vo.branchCode;
    tempUpdate.brandEntityId = self.vo.brandEntityId;
    tempUpdate.branchId = self.vo.branchId;
    tempUpdate.entityId = self.vo.entityId;
    tempUpdate.id = self.vo.id;
    return tempUpdate;
}

- (void)leftNavigationButtonAction:(id)sender
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([UIHelper currChange:self.container]) {
            [self alertChangedMessage:[UIHelper currChange:self.container]];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self alertChangedMessage:[UIHelper currChange:self.container]];
    }
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

@end
