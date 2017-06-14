 //
//  SignBillEditView.m
//  RestApp
//
//  Created by zxh on 14-4-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBillEditView.h"
#import "SettingService.h"
#import "UIHelper.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemText.h"
#import "EditItemView.h"
#import "EditItemRadio.h"
#import "ItemTitle.h"
#import "GridEditCell.h"
#import "JsonHelper.h"
#import "GridFooter44.h"
#import "UIView+Sizes.h"
#import "FooterListView.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "SignBillListView.h"
#import "AlertBox.h"  
#import "SystemUtil.h"
#import "SignerEditView.h"
#import "XHAnimalUtil.h"
#import "KindPayDetail.h"
#import "KindPayDetailOption.h"
#import "GlobalRender.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "HelpDialog.h"
#import "TDFSettingService.h"
#import "TDFMediator+SettingModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SignBillEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self initNotifaction];
    [self initNavigate];
    
    [self initMainView];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self refreshContainer];
    [self loadData:self.kindPay action:self.action isContinue:self.isContinue];
}
#pragma mark - UI
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}
- (UIView *)container {
    if(!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor clearColor];
        _container.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        [_container addSubview:self.baseTitle];
        [_container addSubview:self.lblType];
        [_container addSubview:self.txtName];
        
        [_container addSubview:self.rdoIsInclude];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 242,SCREEN_WIDTH, 20);
        view.backgroundColor = [UIColor clearColor];
        [_container addSubview:view];
        
        [_container addSubview:self.titleSigner];
        [_container addSubview:self.mainGrid];
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 394,SCREEN_WIDTH, 96);
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.btnDel];
        [_container addSubview:view];
        
    }
    return _container;
}

- (ItemTitle *)baseTitle {
    if(!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] init];
        [_baseTitle awakeFromNib];
        _baseTitle.frame = CGRectMake(0, 222, SCREEN_WIDTH, 60);
        _baseTitle.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _baseTitle;
}

- (EditItemView *)lblType {
    if(!_lblType) {
        _lblType = [[EditItemView alloc] init];
        _lblType.frame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
        _lblType.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }
    return _lblType;
}

- (EditItemText *)txtName {
    if(!_txtName){
        _txtName = [[EditItemText alloc] init];
        _txtName.frame = CGRectMake(0, 48, SCREEN_WIDTH, 48);
        _txtName.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }
    return _txtName;
}
- (EditItemRadio *)rdoIsInclude {
    if(!_rdoIsInclude) {
        _rdoIsInclude = [[EditItemRadio alloc] init];
        _rdoIsInclude.frame = CGRectMake(0, 96, SCREEN_WIDTH, 48);
        _rdoIsInclude.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    }
    return _rdoIsInclude;
}

- (ItemTitle *)titleSigner {
    if(!_titleSigner) {
        _titleSigner = [[ItemTitle alloc] init];
        [_titleSigner awakeFromNib];
        _titleSigner.frame = CGRectMake(0, 143, SCREEN_WIDTH, 60);
        _titleSigner.backgroundColor = [UIColor colorWithRed:159/255.0 green:1 blue:67/255.0 alpha:1];
    }
    return _titleSigner;
}

- (UITableView *)mainGrid {
    if(!_mainGrid) {
        _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, 201, SCREEN_WIDTH, 179) style:UITableViewStylePlain];
        _mainGrid.delegate = self;
        _mainGrid.dataSource = self;
    }
    return _mainGrid;
}

- (UIButton *)btnDel {
    if(!_btnDel) {
        _btnDel = [[UIButton alloc] init];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnDel.frame = CGRectMake(10, 27, SCREEN_WIDTH-20, 44);
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    }
    return _btnDel;
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"挂账设置", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    self.callBack();
    [SystemUtil hideKeyboard];
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
    [SystemUtil hideKeyboard];
    self.isContinue = NO;
    [self save];
}

-(void) initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.lblType initLabel:NSLocalizedString(@"支付类型", nil) withHit:nil];
    [self.txtName initLabel:NSLocalizedString(@"名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.rdoIsInclude initLabel:NSLocalizedString(@"是否计入销售额", nil) withHit:nil delegate:nil];
    self.titleSigner.lblName.text=NSLocalizedString(@"本店签字人", nil);
}

#pragma remote
-(void) loadData:(KindPay*) tempVO action:(NSInteger)action isContinue:(BOOL)isContinue
{
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.title=NSLocalizedString(@"添加", nil);
        [self clearDo];
        self.optionList=[NSMutableArray array];
    } else {
        self.title=self.kindPay.name;
        [self fillModel];
        self.optionList=[tempVO.signerList mutableCopy];
    }
    self .action  = action;
    [self.mainGrid reloadData];
    [self refreshContainer];
    [self.titleBox editTitle:NO act:self.action];
}

-(void)refreshContainer
{
    NSUInteger count=self.optionList==nil?0:self.optionList.count;
    [self.mainGrid setHeight:(count+1)*44];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma 数据层处理
-(void) clearDo{
    [self.lblType initData:NSLocalizedString(@"挂账", nil) withVal:[NSString stringWithFormat:@"%d",KIND_CREDIT_ACCOUNT]];
    [self.txtName initData:NSLocalizedString(@"挂账", nil)];
    [self.rdoIsInclude initData:@"1"];
}

-(void) fillModel
{
    [self.lblType initData:NSLocalizedString(@"挂账", nil) withVal:[NSString stringWithFormat:@"%d",KIND_CREDIT_ACCOUNT]];
    [self.txtName initData:self.kindPay.name];
    [self.rdoIsInclude initData:[NSString stringWithFormat:@"%d",self.kindPay.isInclude]];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_KindPayDetailOptionEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayDetailOptionEditView_Change object:nil]; 
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configNavigationBar:YES];
    }else{
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
}

-(void) delFinish:(RemoteResult*) result
{
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
       [AlertBox show:result.errorStr];
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadFinsh:(RemoteResult*) result
{
    [self configNavigationBar:NO];
    [self.progressHud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary* map = [JsonHelper transMap:result.content];
    NSArray *kindPayDetailOptions = [map objectForKey:@"kindPayDetailOptions"];
    self.optionList = [JsonHelper transList:kindPayDetailOptions objName:@"KindPayDetailOption"];
 
    [self.mainGrid reloadData];
    [self refreshContainer];
}

-(void) signerChange:(NSNotification*) notification
{
    NSDictionary* dic= notification.object;
    KindPayDetailOption* option=[dic objectForKey:@"option"];
   [self showProgressHudWithText:NSLocalizedString(@"正在保存", nil)];
    [[TDFSettingService new] saveSignBillRelation:self.kindPay._id signers:option.name sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        self.isContinue=NO;
        [self loadRelation];
        self.callBack(YES);
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
   
}

-(void) loadRelation
{

     [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [[TDFSettingService new] listSignBillDetailOption:self.kindPay._id sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hideAnimated:YES];
        [self configNavigationBar:NO];
        
        NSArray *kindPayDetailOptions = [data objectForKey:@"data"];
        self.optionList = [JsonHelper transList:kindPayDetailOptions objName:@"KindPayDetailOption"];
        
        [self.mainGrid reloadData];
        [self refreshContainer];
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];

}

- (void)footerHelpButtonAction:(UIButton *)sender {
    [HelpDialog show:@"signbill"];
}

#pragma save-data
-(BOOL)isValid{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"挂账名称不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(KindPay*) transMode{
    KindPay* tempUpdate=[KindPay new];
    tempUpdate.name=[self.txtName getStrVal];
    
    if (self.action==ACTION_CONSTANTS_ADD) {
        tempUpdate.kind=[[self.lblType getStrVal] intValue];
        tempUpdate.sortCode=99;
    }else{
        tempUpdate.kind=self.kindPay.kind;
    }

    tempUpdate.isDegree=BASE_FALSE;
    tempUpdate.isSignBill=BASE_TRUE;
    tempUpdate.isCard=BASE_FALSE;
    tempUpdate.isCharge=BASE_FALSE;
    tempUpdate.isThirdPart=BASE_FALSE;
    tempUpdate.memo=NSLocalizedString(@"挂账", nil);
    tempUpdate.name=[self.txtName getStrVal];
    tempUpdate.isInclude=[[self.rdoIsInclude getStrVal] intValue];
    return tempUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    KindPay* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [self showProgressHudWithText:tip];
    NSMutableArray* signers=[NSMutableArray array];
    if (self.action==ACTION_CONSTANTS_ADD) {
        if (self.optionList!=nil && self.optionList.count>0) {
            for (KindPayDetailOption* op in self.optionList) {
                [signers addObject:op.name];
            }
        }
        
        [[TDFSettingService new] saveSignBillKindPay:objTemp   signers:signers sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
            self.callBack();
            NSDictionary *kindPayDic = [data objectForKey:@"data"];
            self.kindPay = [JsonHelper dicTransObj:kindPayDic obj:[KindPay alloc]];
            if (self.isContinue) {
                [self loadData:self.kindPay action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
                [self continueAdd:self.continueEvent];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
            
        }];

    }else{
        NSMutableArray* signerIds=[NSMutableArray array];
        if (self.optionList!=nil && self.optionList.count>0) {
            for (KindPayDetailOption* op in self.optionList) {
                [signers addObject:op.name];
                [signerIds addObject:op._id];
            }
        }
        objTemp.id  = self.kindPay._id;
        [[TDFSettingService new] updateSignBillKindPay:objTemp signers:signers signerIds:signerIds sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
              [self.progressHud hide:YES];
            self.callBack();
            NSDictionary *kindPayDic = [data objectForKey:@"data"];
            self.kindPay = [JsonHelper dicTransObj:kindPayDic obj:[KindPay alloc]];
            if (self.isContinue) {
                [self loadData:self.kindPay action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
                [self continueAdd:self.continueEvent];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.kindPay.name] event:1];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        if (actionSheet.tag==1) {

           [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
            NSMutableArray *arry  = [NSMutableArray arrayWithObject:self.kindPay._id];
            [[TDFSettingService new] removeKindPays:arry sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                [self.progressHud hideAnimated:YES];
                self.callBack(YES);
                [self.navigationController popViewControllerAnimated:YES];
            } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self.progressHud  hideAnimated: YES];
                [AlertBox show:error.localizedDescription];
            }];
            
        } else {
            [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
            NSMutableArray *arry  = [NSMutableArray arrayWithObject:self.delOption._id];
            [[ TDFSettingService new] removeKindPayDetailOptions:arry  sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                [self.progressHud hideAnimated:YES];
                self.isContinue=NO;
                [self loadRelation];
                self.callBack(YES);
           } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
               [self.progressHud  hideAnimated:YES];
               [AlertBox show:error.localizedDescription];
           }];
        }
    }
}

-(void) checkChange
{
    NSUInteger oldCount=self.kindPay.signerList==nil?0:self.kindPay.signerList.count;
    NSUInteger newCount=self.optionList==nil?0:self.optionList.count;
    if (oldCount!=newCount) {
        [self.titleBox editTitle:YES act:self.action];
    } else if (oldCount>0) {
        for (KindPayDetailOption* op in self.optionList) {
            if ([NSString isBlank:op._id]) {
                [self.titleBox editTitle:YES act:self.action];
                break;
            }
        }
    }
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.optionList==nil || indexPath.row==self.optionList.count) {
        GridFooter44 *footerItem = (GridFooter44 *)[tableView dequeueReusableCellWithIdentifier:GridFooterCell44Indentifier];
        footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!footerItem) {
            footerItem = [[NSBundle mainBundle] loadNibNamed:@"GridFooter44" owner:self options:nil].lastObject;
        }
        footerItem.bgView.backgroundColor=[UIColor clearColor];
        footerItem.lblName.text=NSLocalizedString(@"添加本店签字人...", nil);
        footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
        return footerItem;
    } else {
        GridEditCell * cell = [tableView dequeueReusableCellWithIdentifier:GridEditCellIndentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GridEditCell" owner:self options:nil].lastObject;
        }
    
        if (self.optionList.count > 0 && indexPath.row < self.optionList.count) {
            id<INameValueItem> item=(id<INameValueItem>)[self.optionList objectAtIndex: indexPath.row];
            [cell initDelegate:self obj:item title:NSLocalizedString(@"本店签字人", nil) event:@"option"];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.optionList==nil || indexPath.row==self.optionList.count) {
        [self showAddEvent:@"option"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.optionList!=nil?(self.optionList.count+1):1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma samplelist
- (void)showAddEvent:(NSString *)event
{
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.isContinue=YES;
        self.continueEvent=event;
        [self save];
        return;
    } else if (self.action==ACTION_CONSTANTS_EDIT) {
        if ([self hasChanged]) {
            self.isContinue=YES;
            self.continueEvent=event;
            [self save];
        } else {
            [self continueAdd:event];
        }
    }
}

- (void)continueAdd:(NSString *)event
{
    @weakify(self);
    UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_SignerEditViewWithData:self.kindPay option:nil action:ACTION_CONSTANTS_ADD CallBack:^{
        @strongify(self);
        [self loadRelation];
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.delOption=(KindPayDetailOption*)obj;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]%@吗？", nil),self.delOption.name,NSLocalizedString(@"本店签字人", nil)] event:2];
}

- (BOOL)hasChanged
{
    return self.lblType.isChange || self.txtName.isChange || self.rdoIsInclude.isChange;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

