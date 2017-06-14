//
//  TDFChainMenuViewController.m
//  RestApp
//
//  Created by zishu on 16/10/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFChainMenuViewController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+ChainMenuModule.h"
#import "TDFMediator+SettingModule.h"
#import "TDFMediator+MenuModule.h"
#import "GlorenMenuModules.h"
#import "ActionConstants.h"
#import "MemberButton.h"
#import "memberResuView.h"
#import "SystemUtil.h"
#import "TDFMenuService.h"
#import "AlertBox.h"
#import "TDFDecorationViewLayout.h"
#import "TDFMainButtonCollectionViewCell.h"
#import "TDFFunctionKindVo.h"
#import "TDFFunctionVo.h"
#import "TDFIsOpen.h"
#import "TDFMediator+IssueCenter.h"
#import "MobClick.h"

@implementation TDFChainMenuViewController

#pragma mark -setter&&getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [self initDataArray];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"商品与套餐", nil);
    [self initMainView];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
 }

- (void) initMainView
{
    TDFDecorationViewLayout *flowLayout=[[TDFDecorationViewLayout alloc] init];
     flowLayout.delegate = self;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
     flowLayout.minimumInteritemSpacing=0;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberButton" bundle:nil] forCellWithReuseIdentifier:@"MemberButton"];
       [self.collectionView registerClass:[memberResuView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"supple"];
    [self.collectionView  registerClass:[memberResuView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supple"];
    [self.collectionView
     registerClass:[memberResuView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"memberResuView"];
    [self.collectionView registerClass:[TDFMainButtonCollectionViewCell class] forCellWithReuseIdentifier:@"TDFMainButtonCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

#pragma mark -- TDFDecorationViewLayoutDelegate

- (UIEdgeInsets)decorationViewLayout:(TDFDecorationViewLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 15, 10);
}

- (BOOL)showDecorationViewInSection:(NSInteger)section {
    return YES;
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[section];
        return function.functionVoList.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count > 0?self.dataArray.count:1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDFMainButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TDFMainButtonCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section < self.dataArray.count) {
        cell.lineSpacingForContent = 5;
        TDFFunctionKindVo *function = self.dataArray[indexPath.section];
        if (indexPath.row < function.functionVoList.count) {
            TDFFunctionVo *functionModel = function.functionVoList[indexPath.row];
            cell.contentImageView.image = [UIImage imageNamed:functionModel.iconImageUrl.hUrl];
            cell.textLabel.text = functionModel.actionName;
        }
    }
    return cell;

}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 85);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 240)/5, 15, (SCREEN_WIDTH - 240)/5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(10, section == 0 ? 10 : 74);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArray.count) {
        TDFFunctionKindVo *function = self.dataArray[indexPath.section];
        if (indexPath.row < function.functionVoList.count) {
            TDFFunctionVo *functionModel = function.functionVoList[indexPath.row];
        if ([functionModel.actionCode isEqualToString:PAD_BRAND_RELATEMENU]) {
            UIViewController *viewController = [[TDFMediator new] TDFMediator_TDFChainBrandRelatedGoodsViewController];
            [self.navigationController pushViewController:viewController animated:YES];
        }else if ([functionModel.actionCode isEqualToString:PAD_BRAND_STOREAUTHORITY])
            {
                [MobClick event:@"click_commodity_shop_right"];
                UIViewController *viewController = [[TDFMediator new] TDFMediator_TDFChainShopPowerViewController];
                [self.navigationController pushViewController:viewController animated:YES];
            }else if ([functionModel.actionCode isEqualToString:PAD_BRAND_MENU_WAREHOUSE] || [functionModel.actionCode isEqualToString:PAD_MENU_EDIT])
            {  
                UIViewController *viewController  = [[TDFMediator  sharedInstance]  TDFMediator_menuListViewController];
                [self.navigationController pushViewController:viewController animated:YES];
            }
           else  if ([functionModel.actionCode  isEqualToString:PAD_BRAND_PUBLISHTOSTORE]) //商品下发
           {
               [MobClick event:@"click_commodity_copy_icon"];
               UIViewController *viewController = [[TDFMediator  sharedInstance] TDFMediator_GoodsIssueCenterViewController];
                [self.navigationController pushViewController:viewController animated:YES];
           }else if ([functionModel.actionCode isEqualToString:PAD_MENU_KIND])
           {
               UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_kindMenuListViewController];
               [self.navigationController pushViewController:viewController animated:YES];
           }
           else if ([functionModel.actionCode isEqualToString:PAD_MENU_MAKE])
           {
               UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_makeListViewControllerWthData:nil delegate:nil];
               [self.navigationController pushViewController:viewController animated:YES];
           }
           else if ([functionModel.actionCode isEqualToString:PAD_MENU_TIME])
           {
               UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_MenuTimeListView];
               [self.navigationController pushViewController:viewController animated:YES];
           }else if ([functionModel.actionCode isEqualToString:PAD_MENU_ADDITION]){
               UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_additionListViewControllerWithData:nil isLoad:YES dic: nil];
               [self.navigationController pushViewController:viewController animated:YES];
           }else if ([functionModel.actionCode isEqualToString:PAD_MENU_TASTE]){
               UIViewController *viewController  = [[TDFMediator  sharedInstance]  TDFMediator_tasteListViewControllerWthData:nil isLoad:YES];
               [self.navigationController pushViewController:viewController animated:YES];
           }else if ([functionModel.actionCode isEqualToString:PAD_MENU_RATIO_FORMAT])
           {
               UIViewController *viewController = [[TDFMediator sharedInstance] TDFMediator_DiscountPlanListView];
               [self.navigationController pushViewController:viewController animated:YES];
           }else if ([functionModel.actionCode isEqualToString:PAD_MENU_SPEC])
           {
               UIViewController *viewController  = [[TDFMediator sharedInstance] TDFMediator_specListViewControllerWthData:nil isRefresh:YES  delegate: nil];
               [self.navigationController pushViewController:viewController animated:YES];
           }
    }
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *viewIde = @"supple";
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        memberResuView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewIde forIndexPath:indexPath];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *sectionlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width - 20, 15)];
        [view addSubview:sectionlbl];
        sectionlbl.backgroundColor =[UIColor clearColor];
        sectionlbl.textAlignment = NSTextAlignmentCenter;
        if (indexPath.section < self.dataArray.count) {
            TDFFunctionKindVo *function = self.dataArray[indexPath.section];
            sectionlbl.text = function.name;
        }
        sectionlbl.textColor = [UIColor whiteColor];
        sectionlbl.textAlignment = NSTextAlignmentCenter;
        sectionlbl.font = [UIFont systemFontOfSize:15];
        
        return view;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        memberResuView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"memberResuView" forIndexPath:indexPath];
        view.headerTitle.text = @"";
        view.lineView.hidden = YES;
        view.backgroundColor =[UIColor clearColor];
        
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(30,46);
}

- (void) leftNavigationButtonAction:(id)sender
{
    [super leftNavigationButtonAction:sender];
    self.titleBox.hidden = YES;
}
- (void)footerHelpButtonAction:(UIButton *)sender {
    if (![[Platform Instance] isChain]) {
          [HelpDialog show:@"MenuAndSuit"];
    }else{
        [HelpDialog show:@"ChainMenu"];
    }
}

#pragma mark --initDataSource
#pragma mark --initDataArray--/目前只改造到第二层，第三层先按照这种数据模式，
- (void)initDataArray {
    if([[Platform Instance] isChain]) {
        //连锁
        NSMutableArray *functionVoArray = [NSMutableArray array];
        
        TDFFunctionKindVo *functionKindVo = [TDFFunctionKindVo new];
        functionKindVo.name = NSLocalizedString(@"商品与套餐", nil);
        
        TDFFunctionVo *functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_BRAND_MENU_WAREHOUSE;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品与套餐", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menuAndSuit";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_BRAND_RELATEMENU;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"品牌关联商品", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_plateRetainMenu";
        [functionVoArray addObject:functionVO];
        functionKindVo.functionVoList = [NSArray arrayWithArray:functionVoArray];
        
        [self.dataArray addObject:functionKindVo];
        
        functionVoArray = [NSMutableArray array];
        
        functionKindVo = [TDFFunctionKindVo new];
        functionKindVo.name = NSLocalizedString(@"其他", nil);
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_BRAND_PUBLISHTOSTORE;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品下发", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_issueMenu";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_BRAND_STOREAUTHORITY;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"门店权限", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_shopAction";
        [functionVoArray addObject:functionVO];
        
        functionKindVo.functionVoList = [NSArray arrayWithArray:functionVoArray];
        
        [self.dataArray addObject:functionKindVo];
    }else {
        ///一
        NSMutableArray *functionVoArray = [NSMutableArray array];
        
        TDFFunctionKindVo *functionKindVo = [TDFFunctionKindVo new];
        functionKindVo.name = NSLocalizedString(@"商品与套餐", nil);
        
        TDFFunctionVo *functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_EDIT;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品与套餐", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menuAndSuit";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_KIND;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"分类管理", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menukind";
        [functionVoArray addObject:functionVO];
        
        functionKindVo.functionVoList = [NSArray arrayWithArray:functionVoArray];
        
        [self.dataArray addObject:functionKindVo];
        
        ///二
        functionVoArray = [NSMutableArray array];
        
        functionKindVo = [TDFFunctionKindVo new];
        functionKindVo.name = NSLocalizedString(@"其他", nil);
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_SPEC;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品规格", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menuspec";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_MAKE;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品做法", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menumake";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_ADDITION;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品加料", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menuaddition";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_TASTE;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品备注", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menutaste";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_TIME;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"商品促销", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_menutime";
        [functionVoArray addObject:functionVO];
        
        functionVO = [TDFFunctionVo new];
        functionVO.actionCode = PAD_MENU_RATIO_FORMAT;
        functionVO.isLock = NO;
        functionVO.actionName = NSLocalizedString(@"打折方案", nil);
        functionVO.iconImageUrl = [TDFFunctionVoIconImageUrl new];
        functionVO.iconImageUrl.hUrl = @"ico_ratio";
        [functionVoArray addObject:functionVO];
        
        functionKindVo.functionVoList = [NSArray arrayWithArray:functionVoArray];
        
        [self.dataArray addObject:functionKindVo];
    }
    
}

- (UINavigationController *)rootController
{
    if (!_rootController) {
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            _rootController = (UINavigationController *)viewController;
        }else if ([viewController isKindOfClass:[UIViewController class]])
        {
            _rootController = viewController.navigationController;
        }
    }
    return  _rootController;
}


@end
