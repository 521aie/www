//
//  SuitMenuKindEditView.m
//  RestApp
//
//  Created by zxh on 14-9-15.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuKindEditView.h"
#import "MenuModule.h"
#import "MenuRender.h"
#import "MenuService.h"
#import "MBProgressHUD.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditItemRadio.h"
#import "EditMultiList.h"
#import "EditItemBase.h"
#import "EditItemList.h"
#import "RemoteEvent.h"
#import "KindMenuListView.h"
#import "NSString+Estimate.h"
#import "NSMutableArray+DeepCopy.h"
#import "MultiCheckView.h"
#import "RemoteResult.h"
#import "JsonHelper.h"
#import "TreeBuilder.h"
#import "KindMenuListView.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "ActionRender.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "TreeNode.h"
#import "UIView+Sizes.h"
#import "KindRender.h"
#import "GlobalRender.h"
#import "FormatUtil.h"
#import "TreeNodeUtils.h"
#import "MenuModuleEvent.h"
#import "TDFOptionPickerController.h"
#import "SuitTasteListView.h"
#import "SampleMenuVO.h"
#import "MenuKindTaste.h"
#import "RatioPickerBox.h"
#import "HelpDialog.h"
#import "ZmTableCell.h"
#import "AdditionListView.h"
#import "MenuAddition.h"
#import "MultiMasterManagerView.h"
#import "TDFMenuService.h"
#import "KindMenuDetailVo.h"
#import "TDFChainMenuService.h"
#import "TDFMediator+MenuModule.h"
#import "TDFRootViewController+FooterButton.h"

@implementation SuitMenuKindEditView

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud  = [[MBProgressHUD alloc] initWithView:self.view];
    service=[ServiceFactory Instance].menuService;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    [self.view addSubview:self.titleDiv];
    [self.view addSubview:self.scrollView];
    
    [self initNotifaction];
    [self initNavigate];
    [self.view setHeight:SCREEN_HEIGHT];
    [self.view setWidth:SCREEN_WIDTH];
    [self initMainView];
    self.treeNodesDel = [[NSMutableArray alloc] init];
    [self createDataSource];
    [self updateSize];
      [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

- (UIView *) titleDiv
{
    if (!_titleDiv) {
        _titleDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleDiv.backgroundColor = [UIColor redColor];
    }
    return _titleDiv;
}


#pragma mark - UI
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
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
        [_container addSubview:self.txtName];
        [_container addSubview:self.rdoIsSecond];
        [_container addSubview:self.lsParent];
        [_container addSubview:self.txtCode];
        [_container addSubview:self.baseDiv];
        [_container addSubview:self.titleAdvance];
        [_container addSubview:self.mlsTaste];
        [_container addSubview:self.rdoIsGroupOther];
        [_container addSubview:self.lsGroup];
        [_container addSubview:self.lsDeductKind];
        [_container addSubview:self.lsDeduct];
        [_container addSubview:self.advanceDiv];
        [_container addSubview:self.memoTitle];
        [_container addSubview:self.memoGrid];
        [_container addSubview:self.tasteDiv];
        [_container addSubview:self.lblTip];
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 219,SCREEN_WIDTH, 66);
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.btnDel];
        [_container addSubview:view];
    }
    return _container;
}

- (UIView *) baseDiv
{
    if (!_baseDiv) {
        _baseDiv = [[UIView alloc] init];
        _baseDiv.frame = CGRectMake(0, 242,SCREEN_WIDTH, 20);
        _baseDiv.backgroundColor = [UIColor clearColor];
    }
    return _baseDiv;
}

- (ItemTitle *)baseTitle {
    if(!_baseTitle) {
        _baseTitle = [[ItemTitle alloc] init];
        [_baseTitle awakeFromNib];
        _baseTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    }
    return _baseTitle;
}

- (EditItemText *)txtName {
    if(!_txtName){
        _txtName = [[EditItemText alloc] init];
        _txtName.frame = CGRectMake(0, 60, SCREEN_WIDTH, 48);
    }
    return _txtName;
}

- (UIButton *)btnDel {
    if(!_btnDel) {
        _btnDel = [[UIButton alloc] init];
        [_btnDel setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnDel.frame = CGRectMake(10, 9, SCREEN_WIDTH-20, 44);
        [_btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
    }
    return _btnDel;
}

- (UITextView *)lblTip {
    if(!_lblTip){
        _lblTip = [[UITextView alloc] init];
        _lblTip.text = NSLocalizedString(@"此分类下包含子分类，如果要设置备注、加料等内容，请前往每个子分类页面，单独进行设置。", nil);
        _lblTip.textColor = [UIColor grayColor];
        _lblTip.font = [UIFont systemFontOfSize:13];
        _lblTip.userInteractionEnabled = NO;
        _lblTip.frame = CGRectMake(10, 217, SCREEN_WIDTH-20, 60);
    }
    return _lblTip;
}

- (UIView *) tasteDiv
{
    if (!_tasteDiv) {
        _tasteDiv = [[UIView alloc] init];
        _tasteDiv.frame = CGRectMake(0, 242,SCREEN_WIDTH, 20);
        _tasteDiv.backgroundColor = [UIColor clearColor];
    }
    return _tasteDiv;
}

- (ItemTitle *)memoTitle {
    if(!_memoTitle) {
        _memoTitle = [[ItemTitle alloc] init];
        [_memoTitle awakeFromNib];
        _memoTitle.frame = CGRectMake(0, 222, SCREEN_WIDTH, 60);
    }
    return _memoTitle;
}

- (ZMKindTable *) memoGrid
{
    if (!_memoGrid) {
        _memoGrid = [[ZMKindTable alloc] initWithFrame:CGRectMake(0, 126, SCREEN_WIDTH, 252)];
        [_memoGrid awakeFromNib];
    }
    return _memoGrid;
}

- (UIView *) advanceDiv
{
    if (!_advanceDiv) {
        _advanceDiv = [[UIView alloc] init];
        _advanceDiv.frame = CGRectMake(0, 242,SCREEN_WIDTH, 20);
        _advanceDiv.backgroundColor = [UIColor clearColor];
    }
    return _advanceDiv;
}

- (EditItemList *)lsDeductKind {
    if(!_lsDeductKind){
        _lsDeductKind = [[EditItemList alloc] init];
        _lsDeductKind.frame = CGRectMake(0, 392, SCREEN_WIDTH, 48);
    }
    return _lsDeductKind;
}

- (EditItemRadio *)rdoIsGroupOther {
    if(!_rdoIsGroupOther) {
        _rdoIsGroupOther = [[EditItemRadio alloc] init];
        _rdoIsGroupOther.frame = CGRectMake(0, 297, SCREEN_WIDTH, 48);
    }
    return _rdoIsGroupOther;
}

- (EditItemList *)lsGroup {
    if(!_lsGroup){
        _lsGroup = [[EditItemList alloc] init];
        _lsGroup.frame = CGRectMake(0, 344, SCREEN_WIDTH, 48);
    }
    return _lsGroup;
}

- (EditItemList *)lsDeduct {
    if(!_lsDeduct){
        _lsDeduct = [[EditItemList alloc] init];
        _lsDeduct.frame = CGRectMake(0, 439, SCREEN_WIDTH, 48);
    }
    return _lsDeduct;
}

- (EditMultiList *) mlsTaste
{
    if (!_mlsTaste) {
        _mlsTaste = [[EditMultiList alloc] initWithFrame:CGRectMake(0, 204, SCREEN_WIDTH, 0)];
    }
    return _mlsTaste;
}

- (ItemTitle *)titleAdvance {
    if(!_titleAdvance) {
        _titleAdvance = [[ItemTitle alloc] init];
        [_titleAdvance awakeFromNib];
        _titleAdvance.frame = CGRectMake(0, 144, SCREEN_WIDTH, 60);
    }
    return _titleAdvance;
}

- (EditItemText *)txtCode {
    if(!_txtCode){
        _txtCode = [[EditItemText alloc] init];
        _txtCode.frame = CGRectMake(0, 251, SCREEN_WIDTH, 48);
    }
    return _txtCode;
}

- (EditItemRadio *)rdoIsSecond {
    if(!_rdoIsSecond) {
        _rdoIsSecond = [[EditItemRadio alloc] init];
        _rdoIsSecond.frame = CGRectMake(0, 48, SCREEN_WIDTH, 48);
    }
    return _rdoIsSecond;
}

- (EditItemList *)lsParent {
    if(!_lsParent){
        _lsParent = [[EditItemList alloc] init];
        _lsParent.frame = CGRectMake(0, 96, SCREEN_WIDTH, 48);
    }
    return _lsParent;
}

- (void)initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"分类", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.title = NSLocalizedString(@"分类", nil);
}

- (void)onNavigateEvent:(NSInteger)event{
    if (event==1) {
        [parent showView:KINDMENU_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    }else{
        self.isContinue = NO;
        [self save];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void)rightNavigationButtonAction:(id)sender
{
    self.isContinue = NO;
    [self save];
}
- (void)createDataSource
{
    if ([ObjectUtil  isNotEmpty: self.sourceDic]) {
        id delegate  =  self.sourceDic [@"delegate"];
        id  data   =  self.sourceDic [@"data"];
        id  node  =  self.sourceDic [@"treeNodes"];
        NSString *actionStr  =  [NSString stringWithFormat:@"%@",self.sourceDic[@"action"]];
        NSString  *isContinueStr  =  [NSString  stringWithFormat:@"%@",self.sourceDic[@"isContinue"]];
        self.delegate  = delegate;
        [self loadData:data node:node action:actionStr.intValue isContinue:isContinueStr.boolValue];
    }
}

- (void)initMainView
{
    self.baseTitle.lblName.text=NSLocalizedString(@"基本设置", nil);
    [self.txtName initLabel:NSLocalizedString(@"套餐分类", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.rdoIsSecond initLabel:NSLocalizedString(@"此分类有上级分类", nil) withHit:NSLocalizedString(@"注:最多可添加到第四级", nil) delegate:self];
    [self.lsParent initLabel:NSLocalizedString(@"上级分类", nil) withHit:nil isrequest:YES delegate:self];
    
    self.titleAdvance.lblName.text=NSLocalizedString(@"高级设置", nil);
    [self.mlsTaste initLabel:NSLocalizedString(@"套餐备注", nil) delegate:self];
    [self.txtCode initLabel:NSLocalizedString(@"套餐分类编码", nil) withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.rdoIsGroupOther initLabel:NSLocalizedString(@"销售额归到其他分类", nil) withHit:nil delegate:self];
    [self.lsGroup initLabel:NSLocalizedString(@"▪︎ 归到分类", nil) withHit:nil isrequest:YES delegate:self];
    [self.lsDeductKind initLabel:NSLocalizedString(@"销售提成", nil) withHit:nil delegate:self];
    [self.lsDeduct initLabel:NSLocalizedString(@"▪︎ 提成金额(元)", nil) withHit:nil delegate:self];
  
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    self.memoTitle.lblName.text=NSLocalizedString(@"套餐备注", nil);
    [self.memoTitle initDelegate:self event:KINDMENU_TASTE btnArrs:nil];
    
    [self.memoGrid initDelegate:self event:KINDMENU_MEMO_EVENT kindName:NSLocalizedString(@"备注分类", nil) addName:NSLocalizedString(@"添选新备注", nil) itemMode:ITEM_MODE_DEL];
    
    self.rdoIsSecond.tag=KINDMENU_IS_SECONDE;
    self.lsParent.tag=KINDMENU_PARENT;
    self.mlsTaste.tag=KINDMENU_TASTE;
    self.rdoIsGroupOther.tag=KINDMENU_IS_GROUP;
    self.lsGroup.tag=KINDMENU_GROUP;
    self.lsDeductKind.tag=KINDMENU_DEDUCT_KIND;
    self.lsDeduct.tag=KINDMENU_DEDUCT;
}

#pragma remote
- (void)loadData:(KindMenu*) objTemp node:(TreeNode*)node action:(int)action isContinue:(BOOL)isContinue
{
    self.action=action;
    self.kindMenu=objTemp;
    self.currTreeNode=node;
    [self loadKindMenuData];
    self.isContinue = isContinue;
    [self.btnDel setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加套餐分类", nil);
        self.title  = NSLocalizedString(@"添加套餐分类", nil);
        [self clearDo];
        [self.memoGrid loadData:nil details:nil detailCount:0];
        [self endShow:YES];
        [self.lsGroup visibal:NO];
        [self.mlsTaste visibal:NO];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
      
    }else{        
        self.titleBox.lblTitle.text=self.kindMenu.name;
        self.title  =  self.kindMenu.name;
        [self fillModel];
        [self endShow:self.currTreeNode.isLeaf];
        if (self.currTreeNode.isLeaf) {
            [self loadTastes];
        } else {
            [UIHelper refreshPos:self.container scrollview:self.scrollView];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
          
        }
    }
    [self.titleBox editTitle:NO act:self.action];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self  configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

- (void)loadKindMenuData
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"types_str"] = [[NSArray arrayWithObjects:@"1", nil] yy_modelToJSONString];
    @weakify(self);
    [[TDFChainMenuService new] listKindMenuForTypesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [hud  hide:YES];
        NSArray *list = [data objectForKey:@"data"];
        NSMutableArray *arr = [JsonHelper transList:list objName:@"KindMenu"];
        self.treeNodes = [TreeBuilder buildTree:arr];
        for (TreeNode *node in self.treeNodes) {
            if ([node.itemName isEqualToString:self.currTreeNode.itemName]) {
                [self.treeNodesDel addObject:node];
            }
        }
        [self.treeNodes removeObjectsInArray:self.treeNodesDel];
        if (self.action == ACTION_CONSTANTS_ADD) {
//            [self clearDo];
        }else{
            [self fillModel];
            [self endShow:self.currTreeNode.isLeaf];
        }
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        @strongify(self);
        [hud  hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

- (void)endShow:(BOOL)visibal
{
    //高级
    [self.titleAdvance visibal:visibal];
    [self.advanceDiv setHidden:visibal];
    [self.advanceDiv setHeight:visibal?20:0];
    
    [self.rdoIsGroupOther visibal:visibal];
    [self.lsGroup visibal:visibal];
    [self.lsDeductKind visibal:visibal];
    
    if (visibal && [self.rdoIsGroupOther getVal]) {
        [self.lsGroup visibal:YES];
    } else {
        [self.lsGroup visibal:NO];
    }
    
    if (visibal) {
        [self showDeduct:[self.lsDeductKind getStrVal].intValue];
    }else{
        [self.lsDeduct visibal:NO];
    }
    
    //备注
    [self.memoTitle visibal:visibal];
    [self.memoGrid visibal:visibal];
    [self.tasteDiv setHidden:visibal];
    [self.tasteDiv setHeight:visibal?20:0];
    
    //提示
    [self.lblTip setHidden:visibal];
    [self.lblTip setHeight:visibal?0:60];
    
    [self.mlsTaste visibal:NO];
}

- (void)loadTastes
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
    parma[@"kind_menu_id"] = [NSString isBlank:self.kindMenu._id]?@"":self.kindMenu._id;
    @weakify(self);
    [[TDFMenuService new] listKindDetailWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [hud  hide:YES];
        KindMenuDetailVo* kindMenuDetailVo = [KindMenuDetailVo yy_modelWithJSON:data[@"data"]];
        [self.mlsTaste initData:kindMenuDetailVo.kindAndTasteVoList];
        [self.mlsTaste visibal:NO];
        [self processMenuKindTaste:kindMenuDetailVo.kindAndTasteVoList];
        
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
  
        
          } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [hud  hide:YES];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 数据层处理
- (void)clearDo{
    TreeNode* firstNode=[TreeNodeUtils getFirstRootKind:self.treeNodes];
    if (firstNode!=nil) {
        [self.lsParent initData:firstNode.itemOrignName withVal:firstNode.itemId];
        [self.lsGroup initData:firstNode.itemOrignName withVal:firstNode.itemId];
    }else{
        [self.lsGroup initData:nil withVal:nil];
        [self.lsParent initData:nil withVal:nil];
    }
    [self.txtName initData:nil];
    [self.rdoIsSecond initShortData:0];
    [self.lsParent visibal:NO];
    [self.mlsTaste initData:nil];
    [self.txtCode initData:nil];
    [self.rdoIsGroupOther initShortData:0];
    [self.lsGroup visibal:NO];
    [self.lsDeductKind initData:NSLocalizedString(@"不提成", nil) withVal:[NSString stringWithFormat:@"%d",DEDUCTKIND_NOSET]];
    [self.lsDeduct visibal:NO];
    [self.lsDeduct initData:nil withVal:nil];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel
{
    [self.txtName initData:self.kindMenu.name];
    [self.rdoIsSecond initShortData:([KindRender isSecond:self.kindMenu]?1:0)];
    if ([self.rdoIsSecond getVal]) {
        NSString* kindName=[KindRender getKindName:self.treeNodes kindId:self.kindMenu.parentId];
        [self.lsParent initData:kindName withVal:self.kindMenu.parentId];
    }else{
        [self.lsParent initData:nil withVal:nil];
    }
    [self.lsParent visibal:[self.rdoIsSecond getVal]];
    [self.txtCode initData:self.kindMenu.code];
    
    [self.rdoIsGroupOther initShortData:([KindRender isGroupOther:self.kindMenu]?1:0)];
    if ([self.rdoIsGroupOther getVal]) {
        NSString* kindName=[KindRender getKindName:self.treeNodes kindId:self.kindMenu.groupKindId];
            [self.lsGroup initData:kindName withVal:self.kindMenu.parentId];}
   
      else{
        [self.lsGroup initData:nil withVal:nil];
     }
    
    [self.lsGroup visibal:[self.rdoIsGroupOther getVal]];
    NSMutableArray* deductKindList=[MenuRender listDeductKind];
    NSString* deductKind=[NSString stringWithFormat:@"%d",self.kindMenu.deductKind ];
    [self.lsDeductKind initData:[GlobalRender obtainItem:deductKindList itemId:deductKind] withVal:deductKind];
    
    [self.lsDeduct initData:[FormatUtil formatDouble4:self.kindMenu.deduct] withVal:[FormatUtil formatDouble4:self.kindMenu.deduct]];
    [self showDeduct:self.kindMenu.deductKind];
}

#pragma notification 处理.
- (void)initNotifaction{
    [UIHelper initNotification:self.container event:Notification_UI_SuitMenu_KindMenuEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SuitMenu_KindMenuEditView_Change object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:REMOTE_SUITMENU_KINDMENU_UPDATE object:nil];
   
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*)notification
{
    if (self.action  == ACTION_CONSTANTS_EDIT) {
        [self  configNavigationBar:[UIHelper currChange: self.container]];
    }
//    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)delFinish:(RemoteResult*)result
{
    [hud  hide:YES];
 
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    if (self.delegate) {
        [self.delegate navitionToPushBeforeJump:nil data:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [parent showView:KINDMENU_LIST_VIEW];
//    [parent.kindMenuListView loadKindMenuData];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}

//加载口味的过程.
- (void)processMenuKindTaste:(NSMutableArray*)tastes
{
    NSMutableDictionary* detailMap=[NSMutableDictionary new];
    NSMutableArray* oldItems=[self.mlsTaste getCurrList];
    NSInteger count=0;
    if(oldItems!=nil && oldItems.count>0){
        for (KindAndTasteVo* kt in oldItems) {
            count=count+1+kt.tasteList.count;
            if ([ObjectUtil isEmpty:kt.tasteList]) {
                [detailMap setObject:[[NSMutableArray alloc]init] forKey:kt.kindTasteId];
            }else{
                [detailMap setObject:kt.tasteList forKey:kt.kindTasteId];
            }
        }
        self.tastesDic=detailMap;
        [self.memoGrid loadData:oldItems details:detailMap detailCount:count];
        return;
    }
    [self.memoGrid loadData:nil details:nil detailCount:0];
}

- (void)remoteFinsh:(RemoteResult*)result
{
    [hud  hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSDictionary *kindMenuDic = [map objectForKey:@"kindMenu"];
    self.kindMenu = [JsonHelper dicTransObj:kindMenuDic obj:[KindMenu alloc]];
//    [parent.kindMenuListView loadKindMenuData];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass: [KindMenuListView class]]) {
            [(KindMenuListView *)viewController  loadKindMenuData];
        }
    }
    
    if (self.isContinue) {
        [self initCurrTreeNode];
        [self loadData:self.kindMenu node:self.currTreeNode action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
        [self continueAdd:self.continueEvent];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
//        [parent showView:KINDMENU_LIST_VIEW];
//        [XHAnimalUtil animalEdit:parent action:self.action];
    }
}

- (void)initCurrTreeNode
{
    self.currTreeNode=[[TreeNode alloc] init];
    self.currTreeNode.parentId=self.kindMenu.parentId;
    self.currTreeNode.itemId=self.kindMenu._id;
    self.currTreeNode.itemName=self.kindMenu.name;
    self.currTreeNode.itemOrignName=self.kindMenu.name;
    self.currTreeNode.orign=self.kindMenu;
}

-(void) loadRelation
{
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
    [self loadTastes];
}

- (void)onMultiItemListClick:(EditMultiList*)obj
{
    
}

#pragma save-data

- (BOOL)valid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"分类名称不能为空!", nil)];
        return NO;
    }
    if ([NSString isBlank:[self.lsDeductKind getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"请选择销售提成", nil)];
        return NO;
    }
    NSString* fixDeduct=[NSString stringWithFormat:@"%d",DEDUCTKIND_FIX ];
    NSString* ratioDeduct=[NSString stringWithFormat:@"%d",DEDUCTKIND_RATIO ];
    if ([fixDeduct isEqualToString:[self.lsDeductKind getStrVal]] || [ratioDeduct isEqualToString:[self.lsDeductKind getStrVal]]) {
        if ([NSString isBlank:[self.lsDeduct getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"提成金额不能为空!", nil)];
            return NO;
        }
        
        if (![NSString isFloat:[self.lsDeduct getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"提成金额不是数字!", nil)];
            return NO;
        }
    }
    
    if ([self.rdoIsSecond getVal] && [NSString isBlank:[self.lsParent getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"请选择上级商品分类!", nil)];
        return NO;
    }
    
    if ([self.rdoIsGroupOther getVal] && [NSString isBlank:[self.lsGroup getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"请选择销售额归到那个分类!", nil)];
        return NO;
    }
    return YES;
}

- (KindMenu*)transMode
{
    KindMenu* obj=[KindMenu new];
    obj.name=[self.txtName getStrVal];
    if ([self.rdoIsSecond getVal]) {
        obj.parentId=[self.lsParent getStrVal];
    }else{
        obj.parentId=@"0";
    }
    obj.deductKind=[self.lsDeductKind getStrVal].intValue;
    if ([NSString isNotBlank:[self.lsDeductKind getStrVal]]) {
        obj.deduct=[self.lsDeduct getStrVal].doubleValue;
    }
    obj.isInclude=1;
    NSMutableArray* endNodes=[TreeNodeUtils convertDotEndNode:self.treeNodes level:4 showAll:NO];
    if ([self.rdoIsGroupOther getVal]) {
        for (TreeNode *node in endNodes) {
            if ([self.lsGroup.lblVal.text isEqualToString:node.itemName]) {
                obj.groupKindId = node.itemId;
            }
        }
    }
    if ([NSString isNotBlank:[self.txtCode getStrVal]]) {
        obj.code=[self.txtCode getStrVal];
    }
    return obj;
}

- (void)save
{
    if (![self valid]) {
        return;
    }
    KindMenu* objTemp=[self transMode];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@分类", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:hud ];
    //套餐分类不需要保存加料信息.
    if (self.action==ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] saveKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            NSDictionary *kindMenuDic = [data objectForKey:@"data"];
            self.kindMenu = [JsonHelper dicTransObj:kindMenuDic obj:[KindMenu alloc]];
            
            
            if (self.isContinue) {
                [self initCurrTreeNode];
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[KindMenuListView class]]) {
                         [(KindMenuListView *)viewController  loadKindMenuData];
                       
                    }
                }
                [self loadData:self.kindMenu node:self.currTreeNode action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
                [self continueAdd:self.continueEvent];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
            } else {
                if (self.delegate) {
                    [self.delegate navitionToPushBeforeJump:nil data:nil];
                }
                [self.navigationController popViewControllerAnimated:YES];
//                [parent showView:KINDMENU_LIST_VIEW];
//                [parent.kindMenuListView loadKindMenuData];
//                [XHAnimalUtil animalEdit:parent action:self.action];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud  hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }else{
        objTemp.id=self.kindMenu._id;
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_str"] = [objTemp yy_modelToJSONString];
        @weakify(self);
        [[TDFMenuService new] updateKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud  hide:YES];
            NSDictionary *kindMenuDic = [data objectForKey:@"data"];
            self.kindMenu = [JsonHelper dicTransObj:kindMenuDic obj:[KindMenu alloc]];
//             [parent.kindMenuListView loadKindMenuData];
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[KindMenuListView class]]) {
                    [(KindMenuListView *)viewController loadKindMenuData];
                }
            }
            
            if (self.isContinue) {
                [self initCurrTreeNode];
                [self loadData:self.kindMenu node:self.currTreeNode action:ACTION_CONSTANTS_EDIT isContinue:self.isContinue];
                [self continueAdd:self.continueEvent];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
            } else {
//                [parent showView:KINDMENU_LIST_VIEW];
//                [XHAnimalUtil animalEdit:parent action:self.action];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud  hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.kindMenu.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.kindMenu.name] andView:self.view andHUD:hud ];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_menu_id"] = [NSString isBlank:self.kindMenu._id]?@"":self.kindMenu._id;
        //        @weakify(self);
        [[TDFMenuService new] removeKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            //            @strongify(self);
            [hud  hide:YES];
            if (self.delegate) {
                [self.delegate navitionToPushBeforeJump:nil data:nil];
            }
            [self.navigationController popViewControllerAnimated: YES];
//            [parent showView:KINDMENU_LIST_VIEW];
//            [parent.kindMenuListView loadKindMenuData];
 //           [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud  hide:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (NSMutableArray*)getTasteIds
{
    NSMutableArray* idList=[NSMutableArray array];
    NSMutableArray* oldItems=[self.mlsTaste getCurrList];
    if (oldItems==nil || [oldItems count]==0) {
        return idList;
    }
    for (KindAndTasteVo* oldItem in oldItems) {
        [idList addObject:oldItem.kindTasteId];
    }
    return idList;
}

- (NSMutableArray*)getTasteIds1
{
    NSMutableArray* idList=[NSMutableArray array];
    NSMutableArray* oldItems=[self.mlsTaste getCurrList];
    if (oldItems==nil || [oldItems count]==0) {
        return idList;
    }
    for (KindAndTasteVo* oldItem in oldItems) {
        [idList addObject:oldItem.kindTasteId];
    }
    return idList;
}

#pragma test event
#pragma edititemlist click event.
//List控件变换.
- (void)onItemListClick:(EditItemList*)obj{
    if (obj.tag==KINDMENU_PARENT) {
        NSMutableArray* list=self.treeNodes==nil?[NSMutableArray array]:[self.treeNodes deepCopy];
        if (self.action==ACTION_CONSTANTS_EDIT) {
            for (TreeNode* node in list) {
                if ([node.itemId isEqualToString:self.kindMenu._id]) {
                    [list removeObject:node];
                    break;
                }
            }
        }
        NSMutableArray* endNodes=[TreeNodeUtils convertDotEndNode:list level:3 showAll:YES];
    
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:endNodes
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:endNodes[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    }else if(obj.tag==KINDMENU_GROUP){
        NSMutableArray* endNodes=[TreeNodeUtils convertDotEndNode:self.treeNodes level:4 showAll:NO];
        NSString *itemID = nil;
        for (TreeNode *node in endNodes) {
            if([node.itemName rangeOfString:NSLocalizedString(@"▪︎", nil)].location !=NSNotFound)
            {
                if ([[NSString stringWithFormat:NSLocalizedString(@"▪︎%@", nil),obj.lblVal.text] isEqualToString:node.itemName]) {
                    itemID = node.itemId;
                }
                
            }else{
                if ([node.itemName isEqualToString:obj.lblVal.text]) {
                    itemID = node.itemId;
                }
            }
        }

        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:endNodes
                                                                                currentItemId:itemID];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:endNodes[index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if(obj.tag==KINDMENU_DEDUCT_KIND){
        
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                      options:[MenuRender listDeductKind]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[MenuRender listDeductKind][index] event:obj.tag];
        };
        
        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    }else if(obj.tag==KINDMENU_DEDUCT){
        NSString* fixDeduct=[NSString stringWithFormat:@"%d",DEDUCTKIND_FIX ];
        NSString* ratioDeduct=[NSString stringWithFormat:@"%d",DEDUCTKIND_RATIO ];
        if ([fixDeduct isEqualToString:[self.lsDeductKind getStrVal]]) {
            
            [self.lsDeduct setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];
            [self.lsDeduct.lblVal becomeFirstResponder];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.lsDeduct.lblVal performSelector:NSSelectorFromString(@"removeGesture") withObject:nil];
            #pragma clang diagnostic pop
        }else if([ratioDeduct isEqualToString:[self.lsDeductKind getStrVal]]){
            int ratio=100;
            if ([NSString isNotBlank:[obj getStrVal]] && ![@"0" isEqualToString:[obj getStrVal]]) {
                ratio=[obj getStrVal].intValue;
            }
            [RatioPickerBox initData:ratio];
            [RatioPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
        
    }
}

//Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result=[[obj getStrVal] isEqualToString:@"1"];
    if (obj.tag==KINDMENU_IS_SECONDE) {
        [self.lsParent visibal:result];
    }else if(obj.tag==KINDMENU_IS_GROUP){
        [self.lsGroup visibal:result];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)clientInput:(NSString*)val event:(NSInteger)eventType
{
    if (eventType==KINDMENU_DEDUCT) {
        [self.lsDeduct changeData:val withVal:val];
    }
}

#pragma 变动的结果.
#pragma 单选页结果处理.
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    if (event==KINDMENU_DEDUCT_KIND) {
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsDeductKind changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self showDeduct:[item obtainItemId].intValue];
        [self.lsDeduct changeData:nil withVal:nil];
    }else if(event==KINDMENU_PARENT){
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsParent changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if(event==KINDMENU_GROUP){
        id<INameItem> item=(id<INameItem>)selectObj;
        [self.lsGroup changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (event==KINDMENU_DEDUCT) {
        NSString* result=(NSString*)selectObj;
        [self.lsDeduct changeData:result withVal:result];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma 多选页结果处理.

- (void)managerEvent:(NSInteger)event
{
    if (event==KINDMENU_TASTE) {   //口味库管理.
//        [parent showView:SUITMENUTASTE_LIST_VIEW];
//        [parent.tasteListView loadData:self.allKindTastes];
//        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
        UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_tasteListViewControllerWthData:self.allKindTastes isLoad:NO];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items
{
    if (event==KINDMENU_TASTE) {
        self.kindTastes=items;
        NSMutableArray* tempTastes=[NSMutableArray new];
        [self.mlsTaste changeData:items];
        [self.mlsTaste visibal:NO];
        if (items!=nil && items.count>0) {
            for (KindAndTasteVo* kt in items) {
                NSMutableArray* tastes=[self.allTastesDic objectForKey:kt.kindTasteId];
                [tempTastes addObjectsFromArray:tastes];
            }
        }
        self.tastes=tempTastes;
        NSMutableArray* tasteIdList=[self getTasteIds1];
        if ([ObjectUtil isEmpty:tasteIdList]) {
            tasteIdList = [[NSMutableArray alloc] init];
        }
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"kind_taste_ids_str"] = [JsonHelper arrTransJson:tasteIdList];
        parma[@"kind_menu_id"] = self.kindMenu._id;
        @weakify(self);
        [[TDFMenuService new] saveKindMenuTastesWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            @strongify(self);
            [hud  hide:YES];
            self.isContinue=NO;
            [self loadRelation];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud  hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
//    [parent showView:SUITMENUKIND_EDIT_VIEW];
//    [UIHelper showHUD:NSLocalizedString(@"正在保存", nil) andView:self.view andHUD:hud ];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

- (void)closeMultiView:(NSInteger)event
{
//    [parent showView:SUITMENUKIND_EDIT_VIEW];
    [self loadTastes];
//    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
}

- (void)showDeduct:(short)val
{
    if (val==0 || val==1) {
        [self.lsDeduct visibal:NO];
        return;
    }
    [self.lsDeduct visibal:YES];
    self.lsDeduct.lblName.text=[MenuRender getDeductdLabel:val];
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"suitsort"];
}

#pragma ItemTitle 添加事件.
-(void) onTitleAddClick:(int)event
{
    if (event==KINDMENU_TASTE) {
        [self showAddEvent:KINDMENU_MEMO_EVENT];
    }else{
        [self showAddEvent:KINDMENU_ADDITION_EVENT];
    }
}

#pragma ISampleListEvent
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
    if ([event isEqualToString:KINDMENU_MEMO_EVENT]) {
        if (self.allKindTastes!=nil && self.allKindTastes.count>0) {
            [self showMultiMemo];
        }else{
            [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud ];
            @weakify(self);
            [[TDFMenuService new] listAllTaste:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [hud  hide:YES];
                NSArray* menuKindTastes = [NSArray yy_modelArrayWithClass:[KindAndTasteVo class] json:data[@"data"]];
                self.allKindTastes=[NSMutableArray arrayWithArray:menuKindTastes];
                [self showMultiMemo];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [hud  hide:YES];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }
}

- (void)dealTasteDic
{
    NSMutableDictionary* detailMap=[NSMutableDictionary new];
    NSMutableArray* arr=nil;
    if(self.allKindTastes!=nil && self.allKindTastes.count>0){
        for (KindAndTasteVo* kt in self.allKindTastes) {
            arr=[NSMutableArray array];
            for (Taste* taste in kt.tasteList) {
                if ([taste.kindTasteId isEqualToString:kt.kindTasteId]) {
                    [arr addObject:taste];
                }
            }
            [detailMap setObject:arr forKey:kt.kindTasteId];
        }
    }
    self.allTastesDic=detailMap;
}

-(void) showMultiMemo
{
//    [parent showView:MULTI_HEAD_CHECK_VIEW];
//    [parent.multiHeadCheckView initDelegate:self event:KINDMENU_TASTE title:NSLocalizedString(@"备注", nil) managerName:NSLocalizedString(@"备注库\n  管理", nil)];
    
    [self dealTasteDic];
    NSMutableArray* selIds=[NSMutableArray new];
    NSMutableArray* oldItems=[self.mlsTaste getCurrList];
    if(oldItems!=nil && oldItems.count>0){
        for (KindAndTasteVo* kt in oldItems) {
            [selIds addObject:kt.kindTasteId];
        }
    }

    NSString *eventStr  =[NSString stringWithFormat:@"%d" ,KINDMENU_TASTE ];
    NSDictionary *constDic  = @{@"event" : eventStr , @"title" : NSLocalizedString(@"备注", nil) , @"managerName" : NSLocalizedString(@"备注库\n  管理", nil)  };
    UIViewController *viewController  = [[TDFMediator sharedInstance]  TDFMediator_multiHeadCheckViewControllerWthData:self.allKindTastes detalMap:self.allTastesDic selectList:selIds detailName:NSLocalizedString(@"备注", nil) constDic:constDic delegate:self];
    [self.navigationController  pushViewController:viewController animated:YES];
}

-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    if ([event isEqualToString:KINDMENU_MEMO_EVENT]) {
        if ([ObjectUtil isNotNull:obj]) {
            KindAndTasteVo* temp=(KindAndTasteVo*)obj;
            [UIHelper showHUD:NSLocalizedString(@"正在删除", nil) andView:self.view andHUD:hud ];
            NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
            parma[@"kind_menu_id"] = [NSString isBlank:self.kindMenu._id]?@"":self.kindMenu._id;
            parma[@"kind_taste_id"] = temp.kindTasteId;
            @weakify(self);
            [[TDFMenuService new] removeKindMenuTasteWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                @strongify(self);
                [hud  hide:YES];
                self.isContinue=NO;
                [self loadRelation];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [hud  hide:YES];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
                [AlertBox show:error.localizedDescription];
            }];
        }
    }    
}

//刷新备注变化.
-(void)refreshMemoChange:(NSMutableArray*) kinds
{
    self.allKindTastes=kinds;
    [self dealTasteDic];
    NSMutableArray* oldItems=[self.mlsTaste getCurrList];
    
    if (oldItems==nil || oldItems.count==0) {
        return;
    }
    BOOL isExist=NO;
    NSMutableArray* newKinds=[NSMutableArray new];
    NSMutableArray* newTastes=[NSMutableArray new];
    for (KindAndTasteVo* oldKind in oldItems) {
        isExist=NO;
        
        if (self.allKindTastes!=nil && self.allKindTastes.count>0) {
            for (KindAndTasteVo* newKind in self.allKindTastes) {
                if ([oldKind.kindTasteId isEqualToString:newKind.kindTasteId]) {
                    isExist=YES;
                    break;
                }
            }
        }
        
        if (isExist) {
            [newKinds addObject:oldKind];
            
            NSMutableArray* tastes=[self.allTastesDic objectForKey:oldKind.kindTasteId];
            [newTastes addObjectsFromArray:tastes];
        }
    }
    
    [self.mlsTaste changeData:newKinds];
    [self.mlsTaste visibal:NO];
    [self processMenuKindTaste:newTastes];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)hasChanged
{
    return self.txtName.isChange || self.rdoIsSecond.isChange || self.lsParent.isChange || self.txtCode.isChange
    || self.rdoIsGroupOther.isChange || self.lsGroup.isChange || self.lsDeductKind.isChange || self.lsDeduct.isChange;
}

- (void) updateSize{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]] || [view isKindOfClass:[ItemTitle class]]) {
            CGRect frame = view.frame;
            frame.size.width = SCREEN_WIDTH;
            view.frame = frame;
        }
    }
}

@end
