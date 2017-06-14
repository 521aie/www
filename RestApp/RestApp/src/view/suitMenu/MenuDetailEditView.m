//
//  MenuDetailEditView.m
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuDetailEditView.h"
#import "MBProgressHUD.h"
#import "SuitMenuModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SuitMenuModuleEvent.h"
#import "EditItemList.h"
#import "ItemEndNote.h"
#import "EditItemText.h"
#import "JsonHelper.h"
#import "TDFOptionPickerController.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "SuitMenuEditView.h"
#import "AlertBox.h"
#import "Menu.h"
#import "SuitMenuSample.h"
#import "SuitMenuDetail.h"
#import "NavigateTitle2.h"
#import "FooterListView.h"
#import "SuitMenuRender.h"
#import "FormatUtil.h"
#import "HelpDialog.h"
#import "YYModel.h"
#import "TDFSuitMenuService.h"

@interface MenuDetailEditView()
@property (nonatomic, strong) SuitMenuRender *suitMenuRender;
@property (nonatomic, strong) NSMutableArray *detailArray;
@end

@implementation MenuDetailEditView

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SuitMenuModule *)_parent
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        parent=_parent;
//        
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.changed=NO;
    
    
    UIView *bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container];
    [self.container addSubview:self.txtName];
    [self.container addSubview:self.lsKind];
    [self.container addSubview:self.lsNum];
    [self.container addSubview:self.lblNote];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, 20)];
    [self.container addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 219, SCREEN_WIDTH, 76)];
    [self.container addSubview:view2];
    [view2 addSubview:self.btnDel];
    
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self createData];
      
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.container];
    }
    return _scrollView;
}

- (UIView *) container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _container.backgroundColor = [UIColor clearColor];
    }
    return _container;
}

- (EditItemText *) txtName
{
    if (!_txtName) {
        _txtName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH , 48)];
    }
    return _txtName;
}

- (EditItemList *)lsKind {

    if (!_lsKind) {
        _lsKind = [[EditItemList alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    }
    return _lsKind;
}

- (EditItemList *)lsNum {

    if (!_lsNum) {
        _lsNum = [[EditItemList alloc]initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 48)];
    }
    return _lsNum;
}

- (ItemEndNote *)lblNote {

    if (!_lblNote) {
        _lblNote = [[ItemEndNote alloc]initWithFrame:CGRectMake(0, 126, SCREEN_WIDTH, 141)];
    }
    return _lblNote;
}

- (UIButton *)btnDel {

    if (!_btnDel) {
        _btnDel = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 44)];
        
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];

    }
    return _btnDel;
}

/*=======================================**/

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.sourceDic]) {
        id  data  = self.sourceDic [@"data"];
        id  menu  = self.sourceDic [@"menu"];
        id  dataArry  = self.sourceDic [@"dataArry"];
        id  delegate  = self.sourceDic [@"delegate"];
        self.delegate  = delegate;
        NSString *actionStr =  [NSString stringWithFormat:@"%@",self.sourceDic[@"action"]];
        NSString *IsContinue  = [NSString stringWithFormat:@"%@",self.sourceDic[@"isContinue"]];
        [self loadData:data suitMenu:menu action:actionStr.intValue isContinue:IsContinue.boolValue withArray:dataArry];
    }
      
}
#pragma notification 处理.
-(void) initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_SuitMenuDetailEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SuitMenuDetailEditView_Change object:nil];

}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar:[UIHelper currChange:self.container]];
    }
 
}

- (void)postSuitMenuNumChange:(NSString *)childCount
{
    NSMutableDictionary* suitDic=[NSMutableDictionary dictionary];
    [suitDic setObject:self.suitMenu._id forKey:@"suitMenuId"];
    [suitDic setObject:childCount forKey:@"childCount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SuitMenuModule_DataNum_Change object:suitDic];
      
}

-(void)remoteFinsh:(NSMutableDictionary*) data{
    [self proceeResult:data];
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:nil data:nil];
    }
    [self.navigationController popViewControllerAnimated: YES];
      
//    [parent showView:SUITMENU_EDIT_VIEW];
//    [parent.suitMenuEditView reloadData];
//    [XHAnimalUtil animalEdit:parent action:self.action];
}

- (void)proceeResult:(NSMutableDictionary*)data
{
    NSString* actionStr=[NSString stringWithFormat:@"%d",self.action];
    SuitMenuDetail* suitMenuDetail=[SuitMenuDetail yy_modelWithDictionary:data[@"data"]];
//    //通知套菜可点数量变化
//    NSString* childCount = [map objectForKey:@"childCount"];
//    [self postSuitMenuNumChange:childCount];
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:suitMenuDetail forKey:@"suitMenuDetail"];
    [dic setObject:actionStr forKey:@"action"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Detail_Kind_Change object:dic] ;
      
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
      
}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==1) {
        [parent showView:SUITMENU_EDIT_VIEW];
        if(self.isContinue){
            [parent.suitMenuEditView reloadData];
        }
        [XHAnimalUtil animalEdit:parent action:self.action];
    }else{
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    if (self .isContinue) {
        if (self.delegate) {
            [self.delegate navitionToPushBeforeJump:nil data:nil];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
      
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView{
    [self.txtName initLabel:NSLocalizedString(@"分组名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsKind initLabel:NSLocalizedString(@"点单方式", nil) withHit:nil delegate:self];
    [self.lsNum initLabel:NSLocalizedString(@"▪︎ 允许点的数量", nil) withHit:nil isrequest:YES delegate:self];
    
    [self.lblNote initHit:NSLocalizedString(@"提示：请先添加分组,再往分组内添加商品。例如:添加一个“牛排”分组,然后可以把“T骨牛排、西冷牛排”添加到这个分组。 \n\n点单方式为“允许顾客自选”时,顾客可在分组内的商品中自由选择点哪个。允许点的数量选择“不限制”时,顾客可以不点,也可以任意点多份。 \n允许点的数量指定1-100时,顾客只能点指定数量,不能大于或小于指定数量。 \n\n点单方式为 “必须全部选择”时,分组内的商品会自动全部点上，顾客不能自由选择商品。", nil)];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    self.lsKind.tag=SUITMENUDETAIL_KIND;
    self.lsNum.tag=SUITMENUDETAIL_NUM;
//        ，那么应收金额为 180。
}



#pragma remote
-(void) loadData:(SuitMenuDetail*) suitMenuDetailTemp suitMenu:(Menu*)menu action:(int)action isContinue:(BOOL)isContinue withArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        self.detailArray = array;
    }
    self.action=action;
    self.suitMenu=menu;
    self.isContinue=isContinue;
    self.suitMenuDetail=suitMenuDetailTemp;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        //self.titleBox.lblTitle.text=NSLocalizedString(@"添加套餐内分组", nil);
        self.title  = NSLocalizedString(@"添加套餐内分组", nil);
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加套餐内分组", nil);
        [self clearDo];
    }else{
        self.titleBox.lblTitle.text=self.suitMenuDetail.name;
        self.title = self.suitMenuDetail.name;
        [self fillModel];
        
    }
    // [self.titleBox editTitle:NO act:self.action];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
      
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self updateSize];
  
}

#pragma 数据层处理
-(void) clearDo{
    
    [self.txtName initData:nil];
    [self.lsKind initData:NSLocalizedString(@"允许顾客自选", nil) withVal:@"0"];
    [self.lsNum visibal:YES];
    [self.lsNum initData:@"1" withVal:@"1"];
    [self attentionInfoWith:@"1"];
        
}

-(void) fillModel
{
    [self.txtName initData:self.suitMenuDetail.name];
    
    NSMutableArray* dishKinds=[SuitMenuRender listDetailKind];
    NSString* dishKind=[NSString stringWithFormat:@"%d",self.suitMenuDetail.isRequired ];
    [self.lsKind initData:[GlobalRender obtainItem:dishKinds itemId:dishKind] withVal:dishKind];
    [self.lsNum visibal: (self.suitMenuDetail.isRequired==0) ];
    NSString* numStr=[FormatUtil formatDouble4:self.suitMenuDetail.num];
    NSString *name;
    if (numStr.floatValue == -1) {
        name = NSLocalizedString(@"不限制", nil);
    }else
    {
        name = [NSString stringWithFormat:NSLocalizedString(@"%@份", nil),numStr];
    }
    [self.lsNum initData:name withVal:numStr];
    [self attentionInfoWith:numStr];
      
    
}


#pragma test event
#pragma edititemlist click event.
-(void) onItemListClick:(EditItemList*)obj
{
    if (obj.tag==SUITMENUDETAIL_KIND) {
          TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text options:[SuitMenuRender listDetailKind] currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[SuitMenuRender listDetailKind][index] event:obj.tag];
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
    } else if (obj.tag==SUITMENUDETAIL_NUM) {
          TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text options:self.suitMenuRender.countArray currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:self.suitMenuRender.countArray[index] event:obj.tag];
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pvc animated:YES completion:nil];
    }
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    NameItemVO* vo=(NameItemVO*)item;
    if (event == SUITMENUDETAIL_NUM) {
        [self.lsNum changeData:vo.itemName withVal:vo.itemId];
    }else
    {
        ///初始化－－－－
        if (vo.itemId.floatValue == 0) {
            [self.lsNum changeData:@"1" withVal:@"1"];
        }
        [self.lsKind changeData:vo.itemName withVal:vo.itemId];
        [self.lsNum visibal: ([self.lsKind getStrVal].intValue==0) ];
        
    }
    [self attentionInfoWith:vo.itemId];
    return YES;
}

- (void)attentionInfoWith:(NSString *)itmID
{
    NSString *attentionStr;
    if (itmID.intValue == -1) attentionStr = NSLocalizedString(@"注：允许点的数量设为不限制时，建议为此分组的所有商品设置加价。", nil);
    else attentionStr = @"";
    [self.lsNum initHit:attentionStr];
    self.lsNum.lblDetail.textColor = [UIColor redColor];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

#pragma save-data

-(BOOL)isValid{
    
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"分组名称不能为空!", nil)];
        return NO;
    }
    /*
    if (self.action == ACTION_CONSTANTS_ADD) {
        for (SuitMenuDetail *detail in self.detailArray) {
            if ([detail.name isEqualToString:[self.txtName getStrVal]]) {
                [AlertBox show:NSLocalizedString(@"分组名称已存在!", nil)];
                return NO;
            }
        }

    }else
    {
        for (SuitMenuDetail *detail in self.detailArray) {
            if (![detail._id isEqualToString:self.suitMenuDetail._id] && [detail.name isEqualToString:[self.txtName getStrVal]]) {
                [AlertBox show:NSLocalizedString(@"分组名称已存在!", nil)];
                return NO;
            }
        }

    }
     */
    if (self.action==ACTION_CONSTANTS_ADD && [NSString isBlank:[self.lsKind getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"请选择点菜方式!", nil)];
        return NO;
    }
    
    if([self.lsKind getStrVal].intValue==BASE_FALSE && [NSString isBlank:[self.lsNum getStrVal]]){
        [AlertBox show:NSLocalizedString(@"允许点得数量不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(SuitMenuDetail*) transMode{
    SuitMenuDetail* objUpdate=[SuitMenuDetail new];
    objUpdate.suitMenuId=self.suitMenu._id;
    objUpdate.isChange=0;
    objUpdate.isRequired= (short) [[self.lsKind getStrVal] intValue];
    objUpdate.sortCode=0;
    objUpdate.name=[self.txtName getStrVal];
    objUpdate.detailMenuId=@"0";
    if(objUpdate.isRequired==1){
        objUpdate.num=0;
    }else{
        objUpdate.num=[[self.lsNum getStrVal] intValue];
    }
    
    return objUpdate;
}

-(void)save{
    if (![self isValid]) {
        return;
    }
    SuitMenuDetail* temp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud];
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"detail_str"] = [temp yy_modelToJSONString];
        @weakify(self);
        [[TDFSuitMenuService new] saveSuitMenuDetailWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            [self remoteFinsh:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }else{
        temp.id=self.suitMenuDetail.id;
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"detail_str"] = [temp yy_modelToJSONString];
        @weakify(self);
        [[TDFSuitMenuService new] updateSuitMenuDetailWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
//            [parent showView:SUITMENU_EDIT_VIEW];
//            [parent.suitMenuEditView reloadData];
//            [XHAnimalUtil animalEdit:parent action:self.action];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    self.detailId=self.suitMenuDetail._id;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.suitMenuDetail.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"detail_id"] = [NSString isBlank:self.detailId]?@"":self.detailId;
        @weakify(self);
        [[TDFSuitMenuService new] removeSuitMenuDetailWithParam:parma suscess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            NSString* actionStr=[NSString stringWithFormat:@"%d",ACTION_CONSTANTS_DEL];
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:self.detailId forKey:@"detailId"];
            [dic setObject:actionStr forKey:@"action"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SuitModule_Detail_Kind_Change object:dic] ;

//            [parent showView:SUITMENU_EDIT_VIEW];
//            [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated: YES];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

-(void) showHelpEvent
{
    [HelpDialog show:@"suitmenudetail"];
}

#pragma mark -private methord
- (SuitMenuRender *)suitMenuRender
{
    if (!_suitMenuRender) {
        _suitMenuRender = [SuitMenuRender new];
    }
    return _suitMenuRender;
}


- (void) updateSize{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]]) {
            CGRect frame = view.frame;
            frame.size.width = SCREEN_WIDTH;
            view.frame = frame;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
}


@end
