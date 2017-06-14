//
//  UnitListView.m
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitUnitListView.h"
#import "ServiceFactory.h"
#import "SuitUnitEditView.h"
#import "MenuEditView.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "UIHelper.h"
#import "Platform.h"
#import "MenuModule.h"
#import "HelpDialog.h"
#import "GridNVCell2.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "RestConstants.h"
#import "NavigateTitle2.h"
#import "MenuRender.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "MenuModuleEvent.h"
#import "SuitMenuModule.h"
#import "TDFRootViewController+AlertMessage.h"
#import "TDFGoodsService.h"

@implementation SuitUnitListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=parentTemp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add", nil];
    self.defaultList=[DEFAULT_MENU_UNITS componentsSeparatedByString:@"|"];
    [self initDelegate:self event:@"menuunit" title:NSLocalizedString(@"商品单位", nil) foots:arr];
    UIImage *backPicture=[UIImage imageNamed:Head_ICON_CANCEL];
    self.titleBox.imgBack.image=backPicture;
    self.titleBox.lblLeft.text=NSLocalizedString(@"关闭", nil);
}

-(void) onNavigateEvent:(NSInteger)event{
    
    if (event==1) {
        [self.sunitDelegate suitUnitListView:self unitList:self.datas];
        [parent showView:SUITMENU_EDIT_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];

    }
}

#pragma 数据加载
-(void)loadDatas:(NSInteger)event
{
    self.currentEvent=event;
//    NSString* unitStr=[[Platform Instance] getkey:MENU_UNIT];
//     NSString *unitStr= [[NSUserDefaults standardUserDefaults] valueForKey:MENU_UNIT];
//    NSMutableArray* unitList=[MenuRender listMenuUnits:unitStr];
    
    [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
    [TDFGoodsService fetchFoodUnitWithCompleteBlock:^(TDFResponseModel *response) {
        [self.progressHud hide:YES];
        if ([response isSuccess]) {
            if ([response.dataObject isKindOfClass:[NSArray class]]) {
                NSArray *dataList = response.dataObject;
                NSMutableArray *unitList = [NSMutableArray array];
                for (NSDictionary *unitDict in dataList) {
                    NSString *unitDesc = unitDict[@"unitDesc"];
                    NSNumber *unitType = unitDict[@"unitType"];
                    NameItemVO *item = [[NameItemVO alloc] initWithVal:unitDesc andId:unitDesc];
                    item.itemValue = [NSString stringWithFormat:@"%@", unitType];
                    [unitList addObject:item];
                }
                
                self.datas=unitList;
                [self.mainGrid reloadData];
            }
        } else {
            [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
        }
    }];
    
}

-(void)reloadDatas
{
    [self loadDatas:self.currentEvent];
}
#pragma 实现协议 ISampleListEvent

-(void) closeListEvent:(NSString*)event
{
    [parent showView:SUITMENU_EDIT_VIEW];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];

}
-(void) showAddEvent:(NSString*)event
{
    [parent showView:SUITUNIT_EDIT_VIEW];
    [parent.suitUnitEditView loadData:nil action:ACTION_CONSTANTS_ADD];
    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromTop];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
//        NSArray* unitList=nil;
//        NSString* unitStr=[[Platform Instance] getkey:MENU_UNIT];
//         NSString *unitStr= [[NSUserDefaults standardUserDefaults] valueForKey:MENU_UNIT];
//        if ([NSString isBlank:unitStr]) {
//            unitStr=DEFAULT_MENU_UNITS;
//        }
//        NSMutableString* result=[NSMutableString string];
//        unitList=[unitStr componentsSeparatedByString:@"|"];
//        for (NSString* account in unitList) {
//            if (![account isEqualToString:[self.currObj obtainItemId]]) {
//                if ([result length]>0) {
//                    [result appendString:@"|"];
//                }
//                [result appendString:account];
//            }
//        }
////        [[Platform Instance] saveKeyWithVal:MENU_UNIT withVal:result];
//        [[NSUserDefaults standardUserDefaults] setValue:result forKey:MENU_UNIT];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        [TDFGoodsService deleteFoodUnitWithName:[self.currObj obtainItemId] completeBlock:^(TDFResponseModel *response) {
            [self.progressHud hide:YES];
            if ([response isSuccess]) {
                [self loadDatas:self.currentEvent];
            } else {
                [self showMessageWithTitle:response.error.localizedDescription message:nil cancelTitle:NSLocalizedString(@"取消", nil)];
            }
        }];



    }
}
-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=obj;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.currObj obtainItemId]]];
}

-(void) batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids
{
//    NSString* unitStr=[[Platform Instance] getkey:MENU_UNIT];
     NSString *unitStr= [[NSUserDefaults standardUserDefaults] valueForKey:MENU_UNIT];
    if ([NSString isBlank:unitStr]) {
        unitStr=DEFAULT_MENU_UNITS;
    }
//    [[Platform Instance] saveKeyWithVal:MENU_UNIT withVal:DEFAULT_MENU_UNITS];
    [[NSUserDefaults standardUserDefaults] setValue:DEFAULT_MENU_UNITS forKey:MENU_UNIT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadDatas:self.currentEvent];
}
-(void) sortEvent:(NSString*)event ids:(NSMutableArray*)ids
{
    
}
-(void) showHelpEvent:(NSString*)event
{
    [HelpDialog show:@"basemenu"];
}

//编辑键值对对象的Obj
-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridNVCell2 *detailItem = (GridNVCell2 *)[self.mainGrid dequeueReusableCellWithIdentifier:GridNVCell2Indentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GridNVCell2" owner:self options:nil].lastObject;
    }
    detailItem.lblVal.hidden = YES;

    if (self.datas!=nil) {
        id<INameValueItem> item=[self.datas objectAtIndex: indexPath.row];
        [detailItem initDelegate:self obj:item title:@"" event:@""];
//        if ([self.defaultList indexOfObject:[item obtainItemId]]!=NSNotFound) {
        if ([[item obtainItemValue] isEqualToString:@"0"]) { // 0表示系统默认的
            [detailItem.imgDel setHidden:YES];
            [detailItem.btnDel setHidden:YES];
        } else {
            [detailItem.imgDel setHidden:NO];
            [detailItem.btnDel setHidden:NO];
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

-(void) dataChange:(NSNotification*) notification
{
    [self.mainGrid reloadData];
    
    
}

@end

