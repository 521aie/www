//
//  TDFSuitMenuPrinterView.h
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListView.h"
#import "TDFIntroductionHeaderView.h"
@protocol TDFSuitMenuPrinterViewDelegate <NSObject>

@optional
- (void)addNewSuitMenuPrinter;

- (void)showHelpPage:(NSString *)key;

- (void)deletedInfoArray:(NSMutableArray *)array;
@end

@interface TDFSuitMenuPrinterView : UIView
@property (nonatomic, weak)id<TDFSuitMenuPrinterViewDelegate> delegate;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)FooterListView *footerListView;

@end
