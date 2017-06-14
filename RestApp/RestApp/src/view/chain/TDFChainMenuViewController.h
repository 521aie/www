//
//  TDFChainMenuViewController.h
//  RestApp
//
//  Created by zishu on 16/10/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFRootViewController+FooterButton.h"
#import "TDFMediator+SettingModule.h"
#import "HelpDialog.h"
#import "XHAnimalUtil.h"
#import "EventConstants.h"
#import "BackgroundHelper.h"
#import "TDFDecorationViewLayout.h"

@interface TDFChainMenuViewController : TDFRootViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TDFDecorationViewLayoutDelegate>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataArray;
@property (strong, nonatomic) UIView *titleBox;
@property (nonatomic ,strong) UINavigationController *rootController;
@end
