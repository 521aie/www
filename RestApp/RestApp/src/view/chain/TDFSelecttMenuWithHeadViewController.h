//
//  TDFSelecttMenuWithHeadViewController.h
//  RestApp
//
//  Created by zishu on 16/10/10.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "SelectMultiMenuItem.h"
#import "TDFRootViewController.h"
#import "HeadCheckHandle.h"
#import "NewSelectKindMenuPanel.h"
#import "INameValueItem.h"
#import "ObjectUtil.h"
#import "GlobalRender.h"
#import "MultiCheckHandle.h"
#import "TDFMemberNewEditController.h"
#import "TDFAddChainPriceFormatViewController.h"
#import "TDFChainBrandRelatedGoodsViewController.h"
#import "TDFChainShopPublishGoodsViewController.h"
#import "TDFRootViewController+FooterButton.h"
typedef NS_ENUM(NSInteger,TDFSelecttMenuEvent) {
    TDFSelecttMenuEventShop = 150,
    TDFSelecttMenuEventBranchShop,
};

@interface TDFSelecttMenuWithHeadViewController : TDFRootViewController<HeadCheckHandle,SingleCheckHandle,UITableViewDataSource,UITableViewDelegate>
{
  NewSelectKindMenuPanel *selectKindMenuPanel;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) TDFSelecttMenuEvent event;
@property (nonatomic, strong) id<MultiCheckHandle> delegate;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *managerButton;
@property (nonatomic, strong) UIButton *btnBg;
@property (nonatomic, strong) NSMutableArray *nodeList;    //节点.
@property (nonatomic, strong) NSMutableArray *selectIdSet;
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *content;
@property (nonatomic ,strong) NSMutableDictionary *backDic;
@property (nonatomic ,assign) BOOL  isHideSearch;
@property (nonatomic ,assign) BOOL  isChangeTitle;


@end
