//
//  QueuKindListView.m
//  RestApp
//
//  Created by YouQ-MAC on 15/1/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecialTagListView.h"
#import "SpecialTagEditView.h"
#import "KabawModuleEvent.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "KabawService.h"
#import "SpecialTagVO.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "ViewFactory.h"
#import "KabawModule.h"
#import "ItemFactory.h"
#import "RemoteEvent.h"
#import "orderDetailsView.h"
#import "GridNVCell2.h"
#import "JsonHelper.h"
#import "HelpDialog.h"
#import "NSString+Estimate.h"
#import "ObjectUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFMediator+SmartModel.h"

@implementation SpecialTagListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SpecialTagModule *)parentTemp moduleName:(NSString *)moduleNameTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        moduleName = moduleNameTemp;
        service = [ServiceFactory Instance].kabawService;
        moduleName = moduleNameTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView];
    [self initGridView];
    [self initNotifaction];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-70, 60, 60)];
    [btn setBackgroundImage:[UIImage imageNamed:@"float_btb_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showAddEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [self createData];
}

-(void) initMainView
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

  //  [self.titleBox initWithName:NSLocalizedString(@"标签管理", nil) backImg:Head_ICON_BACK moreImg:nil];
    self.title = NSLocalizedString(@"标签管理", nil);
    [self.titleBox initWithName:NSLocalizedString(@"标签管理", nil) backImg:Head_ICON_BACK moreImg:nil];

}

-(void) initGridView
{

    UIView* view=[ViewFactory generateFooter:60];
    [self.mainGrid setTableFooterView:view];
    
}

#pragma notification 处理.
-(void) initNotifaction
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFinsh:) name:[REMOTE_SPECIAL_TAG_DEL stringByAppendingString:moduleName] object:nil];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:self.backView];
        if ([NSString isNotBlank:self.idStr]) {
            [parent.orderDetailsView initdata:self.hdtitle menuId:self.idStr action:self.action];
        }
        else
        {
            [parent.orderDetailsView initdata:self.hdtitle action:self.action];
        }
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.idStr) {
        params [@"menuId"] =  self.idStr;
    }
    if (self.hdtitle) {
        params [@"title"] = self.hdtitle;
    }
    NSString *actionStr  =  [NSString stringWithFormat:@"%ld" ,self.action];
    if (actionStr) {
        params [@"action"] = actionStr;
    }
     [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:@"" data:params];
    }
      
}



-(void) initWithData:(NSArray *)dataList backView:(int)backView
{
    self.datas=dataList;
    self.backView=backView;
    [self.mainGrid reloadData];
}

-(void)initWithIdStr:(NSString *)str action:(NSInteger)action  title:(NSString *)title
{
    self.idStr =str;
    self.action =action;
    self.hdtitle = title;
   
}

-(void) initWithData:(NSArray *)dataList
{
    self.datas=dataList;
    
    [self.mainGrid reloadData];
}

-  (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        NSArray *dataArry  = self.dic [@"data"];
        NSString *menuId  = self.dic [@"menuId"];
        NSString *title   = self.dic [@"title"];
        NSString *actionStr   = self.dic [@"action"];
        id  delegate  =self.dic [@"delegate"];
        self.delegate =delegate;
        if ([NSString isNotBlank:menuId]) {
             [self initWithIdStr:menuId action:actionStr.integerValue title:title];
        }
         [self initWithData:dataArry];
    }
}

-(void) deleteFinsh:(RemoteResult*) result
{
    [self.progressHud hide:YES];
       if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary *dataMap=[JsonHelper transMap:result.content];
    NSMutableArray *specialTagDataList = [[NSMutableArray alloc]init];
    [specialTagDataList addObject:[[SpecialTagVO alloc]initWithData:@"" name:NSLocalizedString(@"不设定", nil) sortCode:1 source:1]];
    NSArray *specialTagList = [dataMap objectForKey:@"specialTagList"];
    if ([ObjectUtil isNotEmpty:specialTagList]) {
        for (NSDictionary *specialTagDic in specialTagList) {
            NSString *specialTagId = [specialTagDic objectForKey:@"specialTagId"];
            NSString *specialTagName = [specialTagDic objectForKey:@"specialTagName"];
            NSInteger sortCode = [[specialTagDic objectForKey:@"sortCode"] integerValue];
            short tagSource = [[specialTagDic objectForKey:@"tagSource"] integerValue];
            
            SpecialTagVO *specialTagItem = [[SpecialTagVO alloc]initWithData:specialTagId name:specialTagName sortCode:sortCode source:tagSource];
            [specialTagDataList addObject:specialTagItem];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SpecialTagData_Change object:nil];
    [self initWithData:specialTagDataList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridNVCell2 *detailItem = (GridNVCell2 *)[tableView dequeueReusableCellWithIdentifier:GridNVCell2Indentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell2" owner:self options:nil].lastObject;
    }
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SpecialTagVO* specialTag=[self.datas objectAtIndex: indexPath.row];
        detailItem.lblName.text=specialTag.specialTagName;
        detailItem.imgDel.image = [UIImage imageNamed:@"ico_next.png"];
        if ([detailItem.lblName.text isEqualToString:NSLocalizedString(@"不设定", nil)]) {
            specialTag.sortCode =1;
            specialTag.tagSource =1;
            detailItem.imgDel.hidden =YES;
        }
        else
        {
            
            detailItem.imgDel.hidden=(specialTag.tagSource==SPECIALTAG_SYS);
        }
        detailItem.btnDel.hidden=YES;
        detailItem.obj=specialTag;
        detailItem.delegate=self;
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.datas!=nil?self.datas.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialTagVO *specialTag = [self.datas objectAtIndex:indexPath.row];
    if ([ObjectUtil isNotNull:specialTag]) {
        if (specialTag.tagSource==SPECIALTAG_SYS) {
            [AlertBox show:NSLocalizedString(@"这个标签是系统标签哦，不能修改和删除哦!", nil)];
        } else {
            if (!parent) {
                UIViewController *viewController  = [[TDFMediator sharedInstance]  TDFMediator_specialTagEditViewControllerfData:specialTag action:ACTION_CONSTANTS_EDIT arry:self.datas delegate:self];
                [self.navigationController pushViewController:viewController animated:YES] ;
            }
            else
            [parent showView:SPECIAL_TAG_EDIT_VIEW];
            [parent.specialTagEditView loadData:specialTag action:ACTION_CONSTANTS_EDIT arry:self.datas];
            
            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
          
            
        }
    }
}

//- (void)delObjEvent:(NSString *)event obj:(id) obj
//{
//    self.specialTag =obj;
//    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]这个标签吗？", nil),[self.specialTag obtainItemName]]];
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {

        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:self.progressHud];

//        [service deleteSpecialTag:[self.specialTag obtainItemId] event:[REMOTE_SPECIAL_TAG_DEL stringByAppendingString:moduleName]];
        [service deleteSpecialTag:[self.specialTag obtainItemId] Target:self callback:@selector(deleteFinsh:)];
    }
}

- (void)showAddEvent
{
    if (!parent) {
        UIViewController *viewController  = [[TDFMediator sharedInstance]  TDFMediator_specialTagEditViewControllerfData:nil action:ACTION_CONSTANTS_ADD  arry:self.datas delegate:self];
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    else
    {
    [parent showView:SPECIAL_TAG_EDIT_VIEW];
    [parent.specialTagEditView loadData:nil action:ACTION_CONSTANTS_ADD arry:self.datas];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
    }
}

- (void)showHelpEvent
{
    [HelpDialog show:@"sepcialTag"];
}

- (void) navitionToPushBeforeJump:(NSString *)event data:(id)obj
{
        if ([ObjectUtil  isNotEmpty:obj]) {
                [self initWithData:obj];
        }
   
}


@end
