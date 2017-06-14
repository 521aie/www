//
//  TDFBaseView.h
//  RestApp
//
//  Created by hulatang on 16/8/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TDFBaseView : UIView

@property (nonatomic, strong)UITableView *tableView;
/// 返回section的个数
@property (nonatomic, copy)NSInteger (^numberOfSection)(UITableView *tableView);
///返回航高(默认80)
@property (nonatomic, copy)CGFloat (^heightForRowInTableViewWithIndexPath)(UITableView* tableView,NSIndexPath *indexPath);
/// 返回section的row数
@property (nonatomic, copy)int (^numberOfRowWithSection)(NSInteger section);
/// 返回自定义cell(默认一套类似于 “传菜”)
@property (nonatomic, copy)UITableViewCell*(^cellWithTableViewAndIndexPath)(UITableView* tableView,NSIndexPath *indexPath);
///使用默认的cell时，实现为cell赋值
@property (nonatomic, copy)void(^loadDataInCell)(UITableViewCell *cell,NSIndexPath *indexPath);

///自定义区
@property (nonatomic, copy)UIView*(^sectionHeaderview)(UITableView *tableView, NSInteger section);
///返回区头高度
@property (nonatomic, copy)CGFloat(^heightForSectionView)(UITableView* tableView,NSInteger section);
///选择
@property (nonatomic, copy)void(^didSelectRow)(UITableView* tableView,NSIndexPath *indexPath);

@property (nonatomic, copy)void(^showHelpDialog)();

- (instancetype)initWithFrame:(CGRect)frame
              withHeaderImage:(UIImage *)headerImage
                  andHelpText:(NSString *)helpText;

- (instancetype)initWithFrame:(CGRect)frame
              withHeaderImage:(UIImage *)headerImage
                  andHelpText:(NSString *)helpText
                   showDetail:(BOOL)isShowDetail;

- (void)reloadData;

- (void)initFooterListViewWithArray:(NSArray *) array
                       withDelegate:(id)delegate
                        andShowHelp:(BOOL)isShow;
@end
