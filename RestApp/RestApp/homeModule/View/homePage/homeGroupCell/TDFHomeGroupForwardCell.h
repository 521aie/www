//
//  TDFHomeGroupForwardCell.h
//  Pods
//
//  Created by happyo on 2017/3/24.
//
//

#import <UIKit/UIKit.h>
#import "DHTTableViewCellProtocol.h"
#import "TDFHomeGroupForwardItem.h"

@interface TDFHomeGroupForwardChildView : UIView

- (void)configureViewWithModel:(TDFHomeGroupForwardChildCellModel *)model;

@end

@interface TDFHomeGroupForwardCell : UITableViewCell <DHTTableViewCellDelegate>

@end
