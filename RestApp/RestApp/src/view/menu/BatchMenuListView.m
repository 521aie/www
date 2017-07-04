//
//  BatchMenuListView.m
//  RestApp
//
//  Created by zxh on 14-6-20.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import "UIHelper.h"
#import "JsonHelper.h"
#import "MenuModule.h"
#import "ObjectUtil.h"
#import "RemoteEvent.h"
#import "TreeBuilder.h"
#import "MenuService.h"
#import "RemoteResult.h"
#import "SampleMenuVO.h"
#import "XHAnimalUtil.h"
#import "MBProgressHUD.h"
#import "TreeNodeUtils.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "OptionPickerBox.h"
#import "BatchMenuListView.h"
#import "SelectMultiMenuListPanel.h"
#import "TDFMenuService.h"
#import "YYModel.h"
#import "UIViewController+Picker.h"
#import "ViewFactory.h"
#import "TDFRootViewController+FooterButton.h"
#define CHANGEKIND @"CHANGEKIND"
#define CANGIVEGOOD @"CANGIVEGOOD"
#define NOGIVEGOOD @"NOGIVEGOOD"
@interface BatchMenuListView()
@property(nonatomic, assign) BOOL chainDataManager;  //可以添加自己的数据
@end

@implementation BatchMenuListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule*)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         parent = parentTemp;
         service = [ServiceFactory Instance].menuService;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"选择商品", nil) ;
    [self initNavigate];
    [self  initHud];
    [self initGrid];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeAllCheck | TDFFooterButtonTypeNotAllCheck];
    self.titleBox.imgMore.image=[UIImage imageNamed:@"ico_bat.png"];
    self.titleBox.lblRight.text=NSLocalizedString(@"批量", nil);
    [self configRightNavigationBar:@"ico_bat.png" rightButtonName:NSLocalizedString(@"批量", nil)];

    [self.dhListPanel initDelegate:self headChange:MenuModule_Batch_Kind_Select detailChange:MenuModule_Batch_Menu_Select];
    [self.dhListPanel setBackgroundColor:[UIColor clearColor]];
    [self createData];
}


- (void)initHud
{
    hud  = [[MBProgressHUD  alloc] initWithView:self.view];
}
-(void)initGrid
{
    self.dhListPanel.mainGrid.opaque=NO;
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    [self.dhListPanel.mainGrid setTableFooterView:view];
    self.dhListPanel.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dhListPanel.mainGrid.tableFooterView = [ViewFactory generateFooter:60];
}

#pragma navigateBar
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:self.titleStr backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [self.delegate closeView];
    } else if (event==DIRECT_RIGHT) {
       
    }
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.delegate closeView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    if ([ObjectUtil isEmpty:[self.dhListPanel getSelectDatas]]) {
        [AlertBox show:NSLocalizedString(@"请先选择商品后，再进行操作!", nil)];
        return;
    }
    
    if ([self.dhListPanel getSelectDatas].count == 0) {
        UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"删除", nil),NSLocalizedString(@"换分类", nil),NSLocalizedString(@"上架", nil),NSLocalizedString(@"下架", nil),NSLocalizedString(@"允许打折", nil),NSLocalizedString(@"不允许打折", nil),NSLocalizedString(@"可作为赠菜", nil),NSLocalizedString(@"不可作为赠菜", nil),@"外卖时可点", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    UIActionSheet *sheet = nil;
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"0"]) {
        int a = 0;
        for (id<INameValueItem> node in self.headList) {
            NSMutableArray *arr = nil;
            KindMenu *kind = nil;
            TreeNode *tree = nil;
            if ([node isKindOfClass:[KindMenu class]]) {
                kind = (KindMenu *)node;
                arr = [self.detailMap objectForKey:kind.id];
            }else if ([node isKindOfClass:[TreeNode class]])
            {
                tree = (TreeNode *)node;
                arr = [self.detailMap objectForKey:tree.itemId];
            }
            for (SampleMenuVO *item in arr) {
                for (NSString *id in [self.dhListPanel getSelectDatas]) {
                    if ([item.id isEqualToString:id] ) {
                        if (item.chain == 1 && !self.chainDataManager) {
                            a ++ ;
                        }else{
                            a = a + 0;
                        }
                    }
                }
            }
        }
        if (a == [self.dhListPanel getSelectDatas].count) {
            self.isChain = YES;
            sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"上架", nil),NSLocalizedString(@"下架", nil), nil];
        }else if (a == 0) {
            self.isChain = NO;
            sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"删除", nil),NSLocalizedString(@"换分类", nil),NSLocalizedString(@"上架", nil),NSLocalizedString(@"下架", nil),NSLocalizedString(@"允许打折", nil),NSLocalizedString(@"不允许打折", nil),NSLocalizedString(@"可作为赠菜", nil),NSLocalizedString(@"不可作为赠菜", nil),@"外卖时可点",@"外卖时不可点", nil];
        }else{
            self.isChain = YES;
            sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"上架", nil),NSLocalizedString(@"下架", nil), nil];
        }
    }else{
        self.isChain = YES;
        sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择批量操作", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"删除", nil),NSLocalizedString(@"换分类", nil),NSLocalizedString(@"上架", nil),NSLocalizedString(@"下架", nil),NSLocalizedString(@"允许打折", nil),NSLocalizedString(@"不允许打折", nil),NSLocalizedString(@"可作为赠菜", nil),NSLocalizedString(@"不可作为赠菜", nil), @"外卖时可点",@"外卖时不可点",nil];
    }
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)createData
{
    if ([ObjectUtil  isNotEmpty:self.dic]) {
        NSMutableArray *menuTemp  = self.dic [@"menuTemp"];
       NSMutableDictionary *menu  = self.dic  [@"menu"];
        NSMutableArray *node  =  self.dic  [@"node"] ;
        self.chainDataManager = [self.dic[@"addible"] boolValue];
        id<SelectMenuHandle> delefgate  = self.dic [@"delegate"] ;
        [self loadMenus:menuTemp menus:menu nodes:node delegate:delefgate];
    }
   
}

#pragma 数据加载.
- (void)loadMenus:(NSMutableArray*)heads menus:(NSMutableDictionary*)details nodes:(NSMutableArray*)nodes delegate:(id<SelectMenuHandle>) delegate;
{
    self.menuKindArr = [[NSMutableArray alloc] init];
    self.suitMenuKindArr = [[NSMutableArray alloc] init];
    self.delegate = delegate;
    self.titleBox.lblRight.text=NSLocalizedString(@"操作", nil);
    [self configRightNavigationBar:@"ico_bat.png" rightButtonName:NSLocalizedString(@"操作", nil)];
    self.headList = [heads mutableCopy];
    self.detailMap = [details mutableCopy];
    self.allNodeList = [nodes mutableCopy];
    for (TreeNode *node in self.allNodeList) {
        if (node.isInclude == 1) {
            [self.suitMenuKindArr addObject:node];
        }else{
            [self.menuKindArr addObject:node];
        }
    }
    
    [self.dhListPanel initSelectData:nil];
    [self pushNotification];
}

- (void)remoteFinish
{
    if (self.isChain && ![self isBrand]) {
    
    }else{
        if (self.batchAction==0) {
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.batchAction] forKey:@"action"];
            [dic setObject:[self.dhListPanel getSelectDatas] forKey:@"ids"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Menu_Batch_Change object:dic] ;
        } else if (self.batchAction==1) {
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.batchAction] forKey:@"action"];
            [dic setObject:self.kindId forKey:@"kindId"];
            [dic setObject:[self.dhListPanel getSelectDatas] forKey:@"ids"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Menu_Batch_Change object:dic];
        }
    }
    [self footerNotAllCheckButtonAction:nil];
    [AlertBox show:NSLocalizedString(@"批量操作成功!", nil)];
    return;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isChain && ![self isBrand]) {
              if (buttonIndex==0) {
                [self batchOperate:NSLocalizedString(@"上架", nil) eventType:buttonIndex];
            } else if(buttonIndex==1) {
                [self batchOperate:NSLocalizedString(@"下架", nil) eventType:buttonIndex];
            } else if(buttonIndex==2) {
                [self batchOperate:NSLocalizedString(@"取消", nil) eventType:buttonIndex];
            }
        }else{
        //获取点击按钮的标题
        if (buttonIndex==0) {     //删除
            [self batchOperate:NSLocalizedString(@"删除", nil) eventType:buttonIndex];
        } else if(buttonIndex==1) {   //换分类
            self.type = CHANGEKIND;
            [self batchOperate:NSLocalizedString(@"换分类", nil) eventType:buttonIndex];
        } else if(buttonIndex==2) {   //上架
            [self batchOperate:NSLocalizedString(@"上架", nil) eventType:buttonIndex];
        } else if(buttonIndex==3) {   //下架
            [self batchOperate:NSLocalizedString(@"下架", nil) eventType:buttonIndex];
        } else if(buttonIndex==4) {   //允许打折
            [self batchOperate:NSLocalizedString(@"允许打折", nil) eventType:buttonIndex];
        } else if(buttonIndex==5) {   //不允许打折
            [self batchOperate:NSLocalizedString(@"不允许打折", nil) eventType:buttonIndex];
        }else if(buttonIndex==6) {   //可作为赠菜
            self.type = CANGIVEGOOD;
            [self batchOperate:NSLocalizedString(@"可作为赠菜", nil) eventType:buttonIndex];
        }else if(buttonIndex==7) {   //不可作为赠菜
            self.type = NOGIVEGOOD;
            [self batchOperate:NSLocalizedString(@"不可作为赠菜", nil) eventType:buttonIndex];
        } else if (buttonIndex == 8) { //外卖时可点
            [self batchOperate:@"外卖时可点" eventType:buttonIndex];
            
        } else if (buttonIndex == 9) { //外卖时不可点
            [self batchOperate:@"外卖时不可点" eventType:buttonIndex];
        }

    }
}

- (void)batchOperate:(NSString*)name eventType:(NSInteger)eventType
{
    if ([name isEqualToString:NSLocalizedString(@"取消", nil)]) {
        return;
    }
    NSInteger count=[self checkValid];
    if (count==0) {
        return;
    }
    if (eventType==1 || eventType == 6 || eventType == 7) {
        if ([name isEqualToString:NSLocalizedString(@"换分类", nil)] || [name isEqualToString:NSLocalizedString(@"可作为赠菜", nil)] || [name isEqualToString:NSLocalizedString(@"不可作为赠菜", nil)]) {
            int a = 0;
            for (id<INameValueItem> node in self.headList) {
                NSMutableArray *arr = nil;
                KindMenu *kind = nil;
                TreeNode *tree = nil;
                if ([node isKindOfClass:[KindMenu class]]) {
                    kind = (KindMenu *)node;
                    arr = [self.detailMap objectForKey:kind.id];
                }else if ([node isKindOfClass:[TreeNode class]])
                {
                    tree = (TreeNode *)node;
                    arr = [self.detailMap objectForKey:tree.itemId];
                }
                
                for (SampleMenuVO *node in arr) {
                    for (NSString *id in [self.dhListPanel getSelectDatas]) {
                        if ([node.id isEqualToString:id] ) {
                            if (node.isInclude == 1) {
                                a ++ ;
                            }else{
                                a = a + 0;
                            }
                        }
                    }
                }
            }
            
            if (a == [self.dhListPanel getSelectDatas].count) {
                if ([self.type isEqualToString:CHANGEKIND]) {
                    NSMutableArray* endNodes=[TreeNodeUtils convertEndNode:self.suitMenuKindArr];
                    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"套餐分类", nil)
                                                                                                  options:endNodes
                                                                                            currentItemId:nil];
                    __weak __typeof(self) wself = self;
                    pvc.competionBlock = ^void(NSInteger index) {
                        
                        [wself pickOption:endNodes[index] event:eventType];
                    };
                    
                    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
                }else{
                    [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"不支持对套餐进行“%@”操作，请不要勾选套餐", nil),name]];
                }
                return;
            }else if (a == 0) {
                if ([self.type isEqualToString:CHANGEKIND]) {
                    NSMutableArray* endNodes=[TreeNodeUtils convertEndNode:self.menuKindArr];
                    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"商品分类", nil)
                                                                                                  options:endNodes
                                                                                            currentItemId:nil];
                    __weak __typeof(self) wself = self;
                    pvc.competionBlock = ^void(NSInteger index) {
                        
                        [wself pickOption:endNodes[index] event:eventType];
                    };
                    
                    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
                    return;
                }
            }else{
                if ([self.type isEqualToString:CHANGEKIND]) {
                    [AlertBox show:NSLocalizedString(@"你既选择了商品又选择了套餐，无法批量换分类。", nil)];
                }else{
                    [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"不支持对套餐进行”%@“操作，请不要勾选套餐", nil),name]];
                }
                return;
            }
 
        }
    }
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"是否对选中的%ld个商品进行\"%@\"操作？", nil),(long)count,name] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    alert1.tag=eventType;
    [alert1 show];
}

- (NSInteger)checkValid
{
    NSMutableArray* ids=[self.dhListPanel getSelectDatas];
    if ([ObjectUtil isEmpty:ids]) {
        [AlertBox show:NSLocalizedString(@"请先选择商品后，再进行操作!", nil)];
        return 0;
    }
    return ids.count;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSInteger event=alertView.tag;
        self.selectMenuIds=[self.dhListPanel getSelectDatas];
        self.batchAction=event;
        if (self.isChain && ![self isBrand]) {
             if(event==0) {  //上架
                    [self showProgressHudWithText:NSLocalizedString(@"正在上架", nil)];
                    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                    parma[@"is_self"] = @"1";
                    parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                    @weakify(self);
                    [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                        @strongify(self);
                        [self.progressHud hideAnimated:YES];
                        [self remoteFinish];
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        [self.progressHud hideAnimated:YES];
                        [AlertBox show:error.localizedDescription];
                    }];
                } else if(event==1) {   //下架remoteFinish:
                    [self showProgressHudWithText:NSLocalizedString(@"正在下架", nil)];
                    NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                    parma[@"is_self"] = @"0";
                    parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                    @weakify(self);
                    [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                        @strongify(self);
                        [self.progressHud hideAnimated:YES];
                        [self remoteFinish];
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

                        [self.progressHud hideAnimated:YES];
                        [AlertBox show:error.localizedDescription];
                    }];
                }   
        }else{
            if (event==0) {     //删除
                [self showProgressHudWithText:NSLocalizedString(@"正在删除", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] removeMenusWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
                
            } else if (event==1) {  //换分类
                [self showProgressHudWithText:NSLocalizedString(@"正在提交", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"kind_menu_id"] = self.kindId;
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] changeKindMenuWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            } else if(event==2) {  //上架
                [self showProgressHudWithText:NSLocalizedString(@"正在上架", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_self"] = @"1";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            } else if(event==3) {   //下架remoteFinish:
                 [self showProgressHudWithText:NSLocalizedString(@"正在下架", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_self"] = @"0";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsSelfWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            } else if(event==4) { //允许打折
                [self showProgressHudWithText:NSLocalizedString(@"正在允许打折", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_ratio"] = @"1";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsRatioWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            } else if(event==5) { //不允许打折BUG
                 [self showProgressHudWithText:NSLocalizedString(@"正在不允许打折", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_ratio"] = @"0";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsRatioWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            }else if (event == 6){
                [self showProgressHudWithText:NSLocalizedString(@"正在可作为赠菜", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_give"] = @"1";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsGiveWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            }else if (event == 7){
                [self showProgressHudWithText:NSLocalizedString(@"正在不可作为赠菜", nil)];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_give"] = @"0";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                @weakify(self);
                [[TDFMenuService new] updateIsGiveWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
                    @strongify(self);
                    [self.progressHud hideAnimated:YES];
                    [self remoteFinish];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [self.progressHud hideAnimated:YES];
                    [AlertBox show:error.localizedDescription];
                }];
            } else if (event == 8) {
                [self showProgressHudWithText:@"正在外卖时可点"];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_takeout"] = @"1";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                [self updateOperateWithParam:parma];
            } else if (event == 9) {
                [self showProgressHudWithText:@"正在外卖时不可点"];
                NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
                parma[@"is_takeout"] = @"0";
                parma[@"menu_id_str"] = [self.selectMenuIds yy_modelToJSONString];
                [self updateOperateWithParam:parma];
            }
        }
  
    }
}


- (void)updateOperateWithParam:(NSDictionary *) param {
    @weakify(self);
    [[TDFMenuService new] updateIsTakeOutWithParam:param sucess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        @strongify(self);
        [self.progressHud hideAnimated:YES];
        [self remoteFinish];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hideAnimated:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

#pragma 批量换分类
- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
     id<INameItem> item=(id<INameItem>)selectObj;
     self.kindId=[item obtainItemId];
     self.selectMenuIds=[self.dhListPanel getSelectDatas];
     UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"是否对选中的%lu个商品进行\"换分类\"操作？", nil),(unsigned long)self.selectMenuIds.count] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    
     alert1.tag=event;
     [alert1 show];
    return YES;
}

- (void)closeSingleView:(int)event
{
    [parent showView:BATCH_MULTI_MENU_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromLeft];
}

-(void) pushNotification
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    dic[@"head_list"] = self.headList;
    dic[@"detail_map"] = self.detailMap;
    dic[@"allNode_list"] = self.allNodeList;
   [[NSNotificationCenter defaultCenter] postNotificationName:MenuModule_Batch_Menu_Select object:dic] ;
    
  
}

-(void) selectObj:(id<IImageDataItem>) obj
{
    
}

-(void) footerAllCheckButtonAction:(UIButton *)sender
{
    [self.dhListPanel selectAll];
}

-(void) footerNotAllCheckButtonAction:(UIButton *)sender
{
    [self.dhListPanel deSelectAll];
}


- (BOOL) isBrand
{
    if ([[[Platform Instance] getkey:IS_BRAND] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
