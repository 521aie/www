//
//  TDFHeadCheckSchemeCell.h
//  ClassProperties
//
//  Created by guopin on 2016/12/14.
//  Copyright © 2016年 ximi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol TDFHealthCheckSchemeCellDelegate<NSObject>
-(void)didSelectCellWithData:(id)data;
@end
@interface TDFHealthCheckSchemeCell : UITableViewCell
@property (nonatomic, weak) id<TDFHealthCheckSchemeCellDelegate> delegate;
-(void)cellLoadData:(id)data;
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data;
@end
