//
//  TDFOfficialAccountView.h
//  TDFFakeOfficialAccount
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TDFMenuType) {
    
    TDFMenuTypeNormal          =       0,              //  带子菜单的 Menu
    TDFMenuTypeURL             =       1,              //  URL 型 Menu
    TDFMenuTypeEmpty           =       2,              //  空的，+ 号 Menu
};

@class TDFOfficialAccountView;
@protocol TDFOfficialAccountViewDelegate <NSObject>

@optional
- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectAddItemInSection:(NSUInteger)section;
/**
 *  选择了父级菜单
 */
- (void)officialAccountView:(TDFOfficialAccountView *)accountView didSelectMenuInSection:(NSUInteger)section;

@end

@protocol TDFOfficialAccountViewDataSource <NSObject>

@required
- (NSUInteger)numOfSectionInOfficialAccountView:(TDFOfficialAccountView *)accountView;
- (NSUInteger)officialAccountView:(TDFOfficialAccountView *)accountView numOfItemsInSection:(NSUInteger)section;
- (BOOL)officialAccountView:(TDFOfficialAccountView *)accountView shouldShowAddItemInSection:(NSUInteger)section;
- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView menuTitleForSection:(NSUInteger)section;
- (TDFMenuType)officialAccountView:(TDFOfficialAccountView *)accountView menuTypeForSection:(NSUInteger)section;
- (NSString *)officialAccountView:(TDFOfficialAccountView *)accountView titleForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  微信公众号 View
 */

@interface TDFOfficialAccountView : UIView

@property (weak, nonatomic) id<TDFOfficialAccountViewDelegate> delegate;
@property (weak, nonatomic) id<TDFOfficialAccountViewDataSource> dataSource;

- (void)reloadData;

@end
