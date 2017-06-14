//
//  MultiDetailManagerView.m
//  RestApp
//
//  Created by zxh on 14-7-30.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MultiMasterManagerView.h"
#import "MultiCheckMasterCell.h"
#import "TDFMediator+MenuModule.h"
#import "MultiDetailView.h"
#import "MenuModuleEvent.h"
#import "SystemUtil.h"
#import "HelpDialog.h"
#import "ObjectUtil.h"

@implementation MultiMasterManagerView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDetail];
    [self createData];
}

-(void) initDetail
{
//    self.multiDetailView=[[MultiDetailView alloc] initWithNibName:@"SampleListView"bundle:nil];
//    [self.view addSubview:self.multiDetailView.view];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
         id delegate  =  self.dic [@"delegate"];
        NSDictionary *constdic  =  self.dic [@"constDic"];
        if ([ObjectUtil isNotEmpty:constdic]) {
            NSString *eventStr  = constdic [@"event"];
            NSString *managerName = constdic [@"managerName"];
            NSString *title  = constdic [@"title"] ;
            [self initDelegate:delegate event:eventStr.intValue title:title managerName:managerName];
        }
       
         id detailMap = self.dic [@"detailMap"];
         NSString * detailName  = self.dic [@"detailName"];
        id headListMap = self.dic [@"headListTemp"];
        id selectLIst  = self.dic [@"selectList"];
        [self  loadData:headListMap detalMap:detailMap selectList:selectLIst detailName:detailName];
    }
}



- (void)loadData:(NSMutableArray*) headListTemp detalMap:(NSMutableDictionary*)detailMap selectList:(NSMutableArray *)selectList detailName:(NSString*)dname
{
    self.dataList=[headListTemp mutableCopy];
    self.detailMap=[detailMap mutableCopy];
    self.selectList=selectList;
    self.detailName=dname;
    [self loadData:self.dataList selectList:self.selectList];
    [self.mainGrid reloadData];
//    [self.multiDetailView.view setHidden:YES];
}

- (void)reLoadData:(NSMutableArray*) headList detalMap:(NSMutableDictionary*)detailMap
{
    [self loadData:headList detalMap:detailMap selectList:self.selectList detailName:self.detailName];
}

-(void) showHelpEvent
{
    if (self.event==KINDMENU_ADDITION) {
        [HelpDialog show:@"basemenuingr"];
    } else if (self.event==KINDMENU_TASTE) {
        [HelpDialog show:@"basemenunote"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultiCheckMasterCell * cell = [tableView dequeueReusableCellWithIdentifier:MultiCheckMasterCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MultiCheckMasterCell" owner:self options:nil].lastObject;
    }
    if (self.dataList.count > 0 && indexPath.row < self.dataList.count) {
        id<INameValueItem> item=[self.dataList objectAtIndex:indexPath.row];
        [cell initDelegate:self obj:item event:@""];
        cell.lblName.text= [item obtainItemName];
        NSMutableArray* arr=[self.detailMap objectForKey:[item obtainItemId]];
        cell.lblDetail.text=[NSString stringWithFormat:NSLocalizedString(@"此分类下共有%lu个%@", nil),(unsigned long)[arr count],self.detailName];
        cell.imgCheck.hidden=![self.selectList containsObject:[item obtainItemId]];
        cell.imgUnCheck.hidden=[self.selectList containsObject:[item obtainItemId]];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    NSMutableArray* datas=[self.detailMap objectForKey:[obj obtainItemId]];
//    [self.mainGrid setHidden:YES];
//    [self.footView setHidden:YES];
//   [self.multiDetailView loadDatas:datas titleName:[obj obtainItemName] mainView:self];
   UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_multiDetailViewControllerWithDatas:datas titlenName:[obj obtainItemName]];
   [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
}

@end
