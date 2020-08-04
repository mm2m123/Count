//
//  TableViewCell.h
//  counter
//
//  Created by 张毅成 on 2020/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end

NS_ASSUME_NONNULL_END
